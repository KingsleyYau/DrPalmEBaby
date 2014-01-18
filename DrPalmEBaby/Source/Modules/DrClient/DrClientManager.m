//
//  DrClientManager.m
//  DrPalm
//
//  Created by fgx_lion on 12-3-19.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "DrClientManager.h"
#import "HttpHandler.h"
#import "DrCOMDefine.h"
#import "Utilities.h"
#import "DrClientLanguageDef.h"

@interface DrClientManager()
// Request Function
-(BOOL)demoLoginRequest:(NSString*)username password:(NSString*)password;
-(BOOL)loginRequest:(NSString*)host username:(NSString*)username password:(NSString*)password;
-(BOOL)checkRequest;
-(BOOL)statusRequest;
-(BOOL)versionRequest;

// Private Function
- (void)getHttpHandler;
- (void)getHttVersionpHandler;
- (void)urlRequest:(NSString*)url data:(NSString*)data type:(NSString*)type callbackmode:(NSString*)callbackmode;
- (NSString*)grantUpdateRequest;
- (void)timerFireMethod:(NSTimer*)theTimer;
-(BOOL)loginStatus:(NSString*)msg msga:(NSString*)msga xip:(NSString*)xip mac:(NSString*)mac time:(NSString*)time flow:(NSString*)flow code:(NSString*)code;
@end

@implementation DrClientManager
@synthesize delegate = _delegate;
@synthesize loginUsername = _loginUsername;
@synthesize loginPassword = _loginPassword;
@synthesize gwUrl = _gwUrl;
@synthesize errorMessage = _errorMessage;
@synthesize macList = _macList;
@synthesize timer = _timer;
@synthesize httpControl = _httpControl;
@synthesize httpVersion = _httpVersion;

- (id)init
{
    self = [super init];
    if (nil != self){
        self.delegate = nil;
        self.loginUsername = nil;
        self.loginPassword = nil;
        self.gwUrl = nil;
        self.errorMessage = nil;
        self.macList = nil;
        self.timer = nil;
        self.httpControl = nil;
        self.httpVersion = nil;
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    self.loginUsername = nil;
    self.loginPassword = nil;
    self.gwUrl = nil;
    self.errorMessage = nil;
    self.macList = nil;
    [self.timer invalidate];
    self.timer = nil;
    self.httpControl = nil;
    self.httpVersion = nil;
    [super dealloc];
}

#pragma mark - public interface
- (BOOL)login:(NSString*)username password:(NSString*)password
{
    // init value
    _successed = NO;
	self.errorMessage = nil;
    _checkTime = 1;
    
    if ([username isEqualToString:DRCOM_Demo_User] && [password isEqualToString:DRCOM_Demo_Pass]) {
        self.gwUrl = [[NSString stringWithFormat:@"http://%@/", DRCOM_Demo_Adress] retain];
        [self demoLoginRequest:username password:password];
    } else {
        self.loginUsername = username;
        self.loginPassword = password;
        [self checkRequest];
    }
    
    return YES;
}

- (BOOL)logout
{
	self.errorMessage = nil;
	[self.timer invalidate];
	self.timer = nil;
    
    NSString *url = [NSString stringWithFormat:@"%@%@", _gwUrl, DrCOM_Logout];
	[self urlRequest:url data:@"" type:@"GET" callbackmode:@"Logout"];
    
    return YES;
}

#pragma mark - Request
-(BOOL)demoLoginRequest:(NSString*)username password:(NSString*)password
{
    NSString *url = [NSString stringWithFormat:@"https://%@/", DRCOM_Demo_Adress];
    NSString *postMessage = [NSString stringWithFormat:DrCOM_Login, username, password, _macList, DrCOM_Def_Num];
    [self urlRequest:url data:postMessage type:@"POST" callbackmode:@"Login"];
    return YES;
}

-(BOOL)loginRequest:(NSString*)host username:(NSString*)username password:(NSString*)password
{
    NSString *url = [NSString stringWithFormat:@"https://%@/", host];
    NSString *postMessage = [NSString stringWithFormat:DrCOM_Login, username, password, _macList, DrCOM_Def_Num];
    [self urlRequest:url data:postMessage type:@"POST" callbackmode:@"Login"];
    
    return YES;
}

-(BOOL)checkRequest
{
    [self urlRequest:DrCOM_TestUrl data:@"" type:@"GET" callbackmode:@"Check"];
    return YES;
}

-(BOOL)statusRequest
{
    [self urlRequest:_gwUrl data:@"" type:@"GET" callbackmode:@"Status"];
    return YES;
}

-(BOOL)versionRequest
{
    NSString *parm = [self grantUpdateRequest];
    NSString *url = [NSString stringWithFormat:@"http://%@%@", DrCOM_Update_Svr, parm];
    [self urlRequest:url data:@"" type:@"GET" callbackmode:@"Version"];
    return YES;
}

#pragma mark - Private Function
- (void)getHttpHandler {
    if (_httpControl) {
        self.httpControl = nil;
    }
    
    _httpControl = [[HttpHandler alloc] init];
    [_httpControl setRecvObj:self];
}

- (void)getHttVersionpHandler {
    if (_httpVersion) {
        self.httpVersion = nil;
    }
    _httpVersion = [[HttpHandler alloc] init];
    [_httpVersion setRecvObj:nil];
}

- (void)urlRequest:(NSString*)url data:(NSString*)data type:(NSString*)type callbackmode:(NSString*)callbackmode 
{
    if ([callbackmode isEqualToString:@"Version"]) {
        [self getHttVersionpHandler];        
        [_httpVersion urlRequest:url data:data type:type callbackmode:callbackmode];        
    } else {
        [self getHttpHandler];
        [_httpControl urlRequest:url data:data type:type callbackmode:callbackmode];
    }
}

- (NSString*)grantUpdateRequest 
{
    //grant time
    NSString* strTime = nil;
    NSDate *date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHMMSS"];
    strTime = [formatter stringFromDate:date];
    [formatter release];
    
    //grant time
    NSString* strType = nil;
    int iType = (int)time(NULL) % 3;
    switch (iType) {
        case 0: strType = DrCOM_HTTP_TYPE_0000; break;
        case 1: strType = DrCOM_HTTP_TYPE_0003; break;
        case 2: strType = DrCOM_HTTP_TYPE_0006; break;
    }
    
    //grant key
    NSString* strKey = @"";
    
    //grant hash & version
    NSString* strHash = DrCOM_Hash;
    NSString* strVer = DrCOM_Version;
    
    //grant rand
    int iRnd = rand() % 1000000;
    NSString* strRnd = [NSString stringWithFormat:@"%06i", iRnd];
    
    //grant chk
    NSString* strChk = nil;
    NSString* strTmp = nil;
    
    if ([strType isEqualToString:DrCOM_HTTP_TYPE_0000]) {
        strTmp = [NSString stringWithFormat:@"%@%@%@%@", strTime, strHash, strVer, strKey];
        strChk = [Utilities MD5StringOfString:strTmp];
        strChk = [strChk substringFromIndex:[strChk length] - 8];
    } else {
        strTmp = [NSString stringWithFormat:@"%@%@%@%@%@", strTime, strHash, strVer, strKey, strRnd];
        if ([strType isEqualToString:DrCOM_HTTP_TYPE_0003]) {
            strChk = [NSString stringWithFormat:@"%lu", [Utilities CRC32StringOfString:strTmp]];
        } else if ([strType isEqualToString:DrCOM_HTTP_TYPE_0006]) {
            strChk = [Utilities MD5StringOfString:strTmp];
            strChk = [strChk substringFromIndex:[strChk length] - 8];
        }
    }
    
    //get mac hash
    NSString* strMac = [Utilities MD5StringOfString:[Utilities GetHardwareAddress:@"en0"]];
    
    NSString* ret = [NSString stringWithFormat:DrCOM_Update_Parm, strTime, strType, strKey, strHash, strVer, strRnd, strChk, strMac];
    return ret;
}

- (void)timerFireMethod:(NSTimer*)theTimer 
{
	[self urlRequest:DrCOM_TestUrl data:@"" type:@"GET" callbackmode:@"Check"];
}

- (BOOL)loginStatus:(NSString*)msg msga:(NSString*)msga xip:(NSString*)xip mac:(NSString*)mac time:(NSString*)time flow:(NSString*)flow code:(NSString*)code 
{
	NSString *tmp = nil;
	if ([msg length] > 1) {
		if ([msg isEqualToString:@"00"] || [msg isEqualToString:@"01"]) {
			if ([msga length] > 0) {
				if ([msga isEqualToString:@"error0"]) {
					tmp = [NSString stringWithString:DrClientIPNotAllow];
				} else if ([msga isEqualToString:@"error1"]) {
					tmp = [NSString stringWithString:DrClientNotAllowLogin];
				} else if ([msga isEqualToString:@"error2"]) {
					tmp = [NSString stringWithString:DrClientNotAllowChangePassword];
				} else {
					tmp = [NSString stringWithFormat:@"%@.", msga];
				}
			} else {
				tmp = [NSString stringWithString:DrClientInvalidAccountPassword];
			}
		} else if ([msg isEqualToString:@"02"]) {
			tmp = [NSString stringWithFormat:DrClientTieUp, xip, mac];
		} else if ([msg isEqualToString:@"03"]) {
			tmp = [NSString stringWithFormat:DrClientAddressOnlyIP, xip];
		} else if ([msg isEqualToString:@"04"]) {
			tmp = [NSString stringWithString:DrClientChargeOverspend];
		} else if ([msg isEqualToString:@"05"]) {
			tmp = [NSString stringWithString:DrClientBreakOff];
		} else if ([msg isEqualToString:@"06"]) {
			tmp = [NSString stringWithString:DrClientSystemBufferFull];
		} else if ([msg isEqualToString:@"08"]) {
			tmp = [NSString stringWithString:DrClientTieUpCanNotAmend];
		} else if ([msg isEqualToString:@"09"]) {
			tmp = [NSString stringWithString:DrClientConfirmPasswordDiffer];
		} else if ([msg isEqualToString:@"10"]) {
			tmp = [NSString stringWithString:DrClientPasswordAmendSuccessed];
		} else if ([msg isEqualToString:@"11"]) {
			tmp = [NSString stringWithFormat:DrClientAddressOnlyMAC, mac];
		} else if ([msg isEqualToString:@"15"]) {
			return YES;
		}
	} else {
		if ([code isEqualToString:@"0000"] || [code isEqualToString:@"FFFF"]) {
			return YES;
		}
	}
	if ([tmp length] > 0) {
		[Utilities showDrAlert:tmp];
	}
	return NO;
}

#pragma mark - HttpHandlerDelegate
- (void)onHttpReceiveForCheck:(NSString*)data original:(NSURL*)original current:(NSURL*)current gwHost:(NSString*)gwHost
{
	NSString *or = [original host];
	NSString *cu = [current host];
	if (![or isEqualToString:cu]) {
		NSRange keyRange = [data rangeOfString:DrCOM_0_html];
		if ((keyRange.length > 0) && ([gwHost isEqualToString:DrCOM_Server] || [gwHost isEqualToString:DrCOM_Server_IIS])){
#ifdef DO_NOT_ALLOW_NAT
			//check NAT
			NSString* ifname = nil;
			NSString* ip = [Utilities findStringBetween:data strBegin:@"v46ip='" strEnd:@"'"];
			if (ip == nil) {
				ip = [Utilities findStringBetween:data strBegin:@"v46ip=\"" strEnd:@"\""];
			}
			if ((ip != nil) && (![ip isEqualToString:@"127.0.0.1"])) {
				ifname = [Utilities compareIPAddress:ip];
			}
			if (ifname == nil){
				[self loginFail:DrClientNotAllowUseNAT];
				return;
			}
#endif
			[[current absoluteString] retain];
			self.gwUrl = [current absoluteString];
			_successed = NO;
			_checkTime = 1;
            [self loginRequest:[current host] username:_loginUsername password:_loginPassword];
			
		}
	} else {
		if (_successed) {
            //get info every 2 mins
			if (_checkTime == 0) {
				[self statusRequest];
			}
            
            /*app usually is put in backgroud, so sendng update data is no use.
             //add by Keqin in 2011-10-24 for connect to update server every 60 mins, the first time will be sent in login success
             if (checkTime == 0) {
             NSString *parm = [self grantUpdateRequest];
             NSString *url = [NSString stringWithFormat:@"http://%@%@", DrCOM_Update_Svr, parm];
             [self urlRequest:url data:@"" type:@"GET" callbackmode:@"Version"];
             }
             //add end
             */
            
			_checkTime++;
			_checkTime = _checkTime % 4;
            
		} else {
			if ([_gwUrl length] > 0) {
				cu = [[NSURL URLWithString:_gwUrl] host];
				[self loginRequest:cu username:_loginUsername password:_loginPassword];
			} else {
				[_delegate loginFail:DrClientAlreadOnline];
			}
		} 
	}
}

- (void)onHttpReceiveForLogin:(NSString*)data 
{
    NSString* error = nil;
	if ([data rangeOfString:DrCOM_2_html].length > 0) {
		NSString *msg = [Utilities findStringBetween:data strBegin:@"Msg=" strEnd:@";time"];
		NSString *msga = [Utilities findStringBetween:data strBegin:@"msga='" strEnd:@"';"];
		NSString *xip = [Utilities findStringBetween:data strBegin:@"xip=" strEnd:@";mac"];
		NSString *mac = [Utilities findStringBetween:data strBegin:@"mac=" strEnd:@";va"];
		NSString *time = [Utilities findStringBetween:data strBegin:@"time='" strEnd:@"';flow"];
		NSString *flow = [Utilities findStringBetween:data strBegin:@"flow='" strEnd:@"';fsele"];
		NSString *code = [Utilities findStringBetween:data strBegin:@"mcode = " strEnd:@";"];
		_successed = [self loginStatus:msg msga:msga xip:xip mac:mac time:time flow:flow code:code];
	} else if ([data rangeOfString:DrCOM_3_html].length > 0) {
		_successed = YES;
	} else {
		error = DrClientCanNotFind;
	}
    
	if (_successed) {
        [_delegate loginSuccess];
        if (_timer == nil) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:(30.0) target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        }
        [self statusRequest];
        _sendUpdate = YES;
	} else {
		[_delegate loginFail:error];
	}
}

- (void)onHttpReceiveForLogout:(NSString*)data 
{
	if ([data length] > 0) {
        //		[self setViewControl:NO];
        //		if (![[fileController readParamInSettingFile:DrCOMRememberPass] isEqualToString:DrCOMYES]) {
        //			passField.text = @"";
        //		}
        //		//add by Keqin in 2011-04-30
        //		[gwUrl release];
        //		gwUrl = @"";
        //		[gwUrl retain];
        //		[fileController writeParamInSettingFile:DrCOMUrl value:gwUrl];
        //		//add end
        [_delegate logoutSuccess];
	}
}

- (void)onHttpReceiveForStatus:(NSString*)data 
{
	if ([data rangeOfString:DrCOM_1_html].length > 0) {
		NSString *time = [Utilities findStringBetween:data strBegin:@"time='" strEnd:@"';flow"];
		NSString *flow = [Utilities findStringBetween:data strBegin:@"flow='" strEnd:@"';fsele"];
        [_delegate statusChange:time flow:flow];
		
        // 发信息到更新服务器
        if (_sendUpdate) {
            _sendUpdate = NO;
            //send data to update server, because the app will be run in background immediately after login
            //            NSString *parm = [self grantUpdateRequest];
            //            NSString *url = [NSString stringWithFormat:@"http://%@%@", DrCOM_Update_Svr, parm];
            //            [self urlRequest:url data:@"" type:@"GET" callbackmode:@"Version"];
            [self versionRequest];
        }
	} else {
        // 失败
        [_delegate statusChange:nil flow:nil];
	}
}

- (void)onHttpReceiveForVersion:(NSString*)data 
{
	if ([data length] > 0) {
        [Utilities showDrAlert:data];
    }
}

- (void)onHttpError:(NSError*)error 
{	
    [_delegate requestFail:[error localizedDescription]];
}
@end
