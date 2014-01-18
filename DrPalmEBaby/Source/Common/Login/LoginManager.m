//
//  LoginManager.m
//  MIT Mobile
//
//  Created by fgx_lion on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LoginManager.h"

//#import "UserInfoManager.h"
#import "LoginLanguageDef.h"
#import "ErrorCodeDef.h"
//#import "LoginSuccessOperationManager.h"

#import "RequestOperator.h"
#import "CommonRequestOperator.h"

#import "ClassDataManager.h"
#import "ClassRequestOperator.h"
#import "ClassAttachmentDownloader.h"

// url
#define LOGIN_PATH      @"login"
#define LOGOUT_PATH     @"logout"

// url param
#define USERID_PARAM        @"userid"
#define PWD_PARAM           @"pwd"
#define SCHOOLID_PARAM      @"market_id"
#define DEVICETOKEN_PARAM   @"devicetoken"
#define USERTYPE_PARAM      @"type"
#define USERTYPE_VALUE      @"0"
#define SESSIONKEY_PARAM    @"sessionkey"

// protocol
#define OPRET       @"opret"
#define OPFLAG      @"opflag"
#define OPCODE      @"code"
#define OPFLAGSUCCESS   @"1"
#define OPFLAGFAIL      @"0"
#define SESSIONKEY  @"sessionkey"

#define ACCOUNTINFO @"accountinfo"
#define USERNAME    @"username"
#define MEMBERKEY   @"memberkey"
#define UNGETCOUNT  @"ungetcount"
#define ACCTYPE     @"acctype"
#define ACCTYPE_TEACHER @"0"
#define ACCTYPE_PARENT  @"1"
#define ACCTYPE_STUDENT @"2"


#define LEVEL            @"level"
#define LEVELUPSCORE     @"levelupscore"
#define CURSCORE         @"curscore"
#define HEADURL          @"headurl"
#define HEADLASTUPDATE   @"headlastupdate"
#define LASTUPDATE       @"lastupdate"


#define PUSHINFO   @"pushinfo"
#define IFPUSH     @"ifpush"
#define IFSOUND    @"ifsound"
#define IFSHAKE    @"ifshake"
#define PUSHTIME   @"pushtime"
#define PUSH_START @"start"
#define PUSH_END   @"end"

#define SENDPERMIS @"sendpermis"
// error
#define ProtocalError   @"protocal error"

@interface LoginManager() <ClassRequestOperatorDelegate, CommonRequestOperatorDelegate,ClassAttachmentDownloaderDelegate>
@property (nonatomic, retain) CommonRequestOperator *commonRequestOperator;
@property (nonatomic, retain) ClassRequestOperator *classRequestOperator;
//@property (nonatomic, retain) LoginSuccessOperationManager *loginSuccessOperationManager;

-(void)handleLogin:(id)data;
-(void)handleLogout:(id)data;
-(BOOL)isOnline;
-(UserType)userTypeWithData:(id)data;
-(void)callDelegateChangeStatus;
-(void)callDelegateError:(LoginManagerHandleStatus)status error:(NSString*)error;

// TODO:同步收藏逻辑
- (void)cancelSynchronize;
- (BOOL)synchronizeBookmarkEvent;
- (BOOL)submitBookmarkEvent;
@end

@implementation LoginManager
@synthesize accountName = _accountName;
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize memberKey = _memberKey;
@synthesize sessionKey = _sessionKey;
@synthesize loginStatus = _loginStatus;
@synthesize ungetEventCount = _ungetEventCount;
@synthesize handleStatus = _handleStatus;
@synthesize userType = _userType;
//@synthesize loginSuccessOperationManager = _loginSuccessOperationManager;
@synthesize commonRequestOperator;
@synthesize classRequestOperator;
-(id)init
{
    if (self = [super init])
    {
        _sessionKey = nil;
        _accountName = nil;
        _userName = nil;
        _memberKey = nil;
        _connectionWrapper = nil;
        _userType = UserTypeStudent;
        _handleStatus = LoginManagerHandleNone;
        _delegates = [[NSMutableSet alloc] init];
        _ungetEventCount = 0;
        
        _requestUrlPath = nil;
        _requestParams = nil;
        
        _delegateLock = [[NSLock alloc] init];
//        self.loginSuccessOperationManager = [[[LoginSuccessOperationManager alloc] init] autorelease];
//        [self.loginSuccessOperationManager registerLoginManager:self];
        //self.requestOperator = [[[RequestOperator alloc] init] autorelease];
        self.commonRequestOperator = [[[CommonRequestOperator alloc] init] autorelease];
        self.commonRequestOperator.delegate = self;
    }
    return self;
}

-(void)dealloc
{
    [self cancel];
    [self cancelSynchronize];
    
    if(_delegates) {
        [_delegates removeAllObjects];
        [_delegates release];
        _delegates = nil;
    }
    
    [_userName release];
    _userName = nil;
    [_accountName release];
    _accountName = nil;
    [_memberKey release];
    _memberKey = nil;
    
//    self.loginSuccessOperationManager = nil;
    
    self.commonRequestOperator = nil;
    
    [_delegateLock release];
    _delegateLock = nil;

    [super dealloc];
}
- (void)reset {
    [_sessionKey release];
    _sessionKey = nil;
    
    _userType = UserTypeUnkonw;
    _loginStatus = LoginStatus_off;
    [_accountName release];
    _accountName = nil;

}
#pragma mark - delegate operation
-(void)addDelegate:(id<LoginManagerDelegate>)delegate
{
    //if([_delegateLock tryLock]) {
        [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
        [_delegates addObject:delegate];
        [_delegateLock unlock];
    //}

}

-(void)removeDelegate:(id<LoginManagerDelegate>)delegate
{
    //if([_delegateLock tryLock]) {
        [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
        [_delegates removeObject:delegate];
        [_delegateLock unlock];
    //}
}

-(void)callDelegateChangeStatus
{
    //if([_delegateLock tryLock]) {
        [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
        for (id<LoginManagerDelegate> delegate in _delegates)
        {
            //        NSLog(@"%@", [delegate description]);
            if([delegate respondsToSelector:@selector(loginStatusChanged:)]) {
                [delegate loginStatusChanged:_loginStatus];
            }
        }
    
        
        [_delegateLock unlock];
    //}y

}

-(void)callDelegateError:(LoginManagerHandleStatus)status error:(NSString*)error
{
    for (id<LoginManagerDelegate> delegate in _delegates) 
    {
        if([delegate respondsToSelector:@selector(handleError:error:)]) {
            [delegate handleError:status error:error];
        }
    }
}

#pragma mark - online (login/logout..)
-(void)cancel
{
    _handleStatus = LoginManagerHandleNone;
    [self.commonRequestOperator cancel];
    

}
- (void)cancelSynchronize {
    if( self.classRequestOperator) {
        [self.classRequestOperator cancel];
        self.classRequestOperator = nil;
    }
}
-(BOOL)autoLogin
{
//    for (AccountInfo *accountInfo in [SettingManagerInstance() getAccountArray]) {
//        if (accountInfo.bAutoLogin){
//            return [self login:accountInfo.account password:accountInfo.password];
//        }
//    }
    if([UserInfoManagerInstance().userInfo.isautologin boolValue])
    {
        return [self login:UserInfoManagerInstance().userInfo.username password:UserInfoManagerInstance().userInfo.password];
    }
    return NO;
}





-(BOOL)login:(NSString*)username password:(NSString*)password
{

    if (LoginManagerHandleNone == _handleStatus && LoginStatus_online != _loginStatus)
    {
        _handleStatus = LoginManagerHandleLogin;
        [_accountName release];
        _accountName = [[username lowercaseString] copy];
        _password = [password copy];
        
        NSString *deviceToken = nil;
        if (nil != AppDelegate().deviceToken){
            deviceToken = [[NSString stringWithFormat:@"%@", AppDelegate().deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
            deviceToken = [deviceToken substringWithRange:NSMakeRange(1, [deviceToken length]-2)];
        }
        return [self.commonRequestOperator login:username pwd:[password toMD5String] token:deviceToken];
    }
    else if (LoginManagerHandleLogin == _handleStatus){
        return YES;
    }
    else {
        return NO;
    }
    return NO;
}

-(void)handleLogin:(id)data
{
    BOOL success = NO;
    NSString* opcode = nil;
    if ([data isKindOfClass:[NSDictionary class]])
    {
        // opret protocal
        NSDictionary* oprect = [data objectForKey:OPRET];
        NSString* opflag = [oprect objectForKey:OPFLAG];
        if ([opflag isEqualToString:OPFLAGSUCCESS])
        {
            [_sessionKey release];
            _sessionKey = [[data objectForKey:SESSIONKEY] copy];
            
            [UserInfoManagerInstance() loadCurUserInfo:LoginManagerInstance().accountName];
                        
            [_memberKey release];
            _memberKey = [[data objectForKey:MEMBERKEY] copy];
            
            _ungetEventCount = [[data objectForKey:UNGETCOUNT] integerValue];
            
            _userType = [self userTypeWithData:[data objectForKey:ACCTYPE]];
            NSNumber* no = [NSNumber numberWithInteger:(NSInteger)_userType];
            UserInfoManagerInstance().userInfo.usertype = no;
            //帐号信息
            id accountinfodata = [data objectForKey:ACCOUNTINFO];
            if(accountinfodata != nil && accountinfodata != [NSNull null] && [accountinfodata isKindOfClass:[NSDictionary class]])
            {
                //username
                [_userName release];
                _userName = [[accountinfodata objectForKey:USERNAME] copy];
                
                //levle
                id value = [accountinfodata objectForKey:LEVEL];
                if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
                {
                    UserInfoManagerInstance().userInfo.level = value;
                }
                
                //curscore
                value = [accountinfodata objectForKey:CURSCORE];
                if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
                {
                    UserInfoManagerInstance().userInfo.curscore = value;
                }
                
                //levelupscore
                value = [accountinfodata objectForKey:LEVELUPSCORE];
                if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
                {
                    UserInfoManagerInstance().userInfo.levelupscore = value;
                }
                
                //lastupdate
                value = [accountinfodata objectForKey:LASTUPDATE];
                if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
                {
                    
                    UserInfoManagerInstance().userInfo.lastupdate =[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
                }
                
                //headlastupdate
                value = [accountinfodata objectForKey:HEADLASTUPDATE];
                if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
                {
                    
                    UserInfoManagerInstance().userInfo.headlastupdate =[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
                }
                
                //headurl
                value = [accountinfodata objectForKey:HEADURL];
                if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSString class]])
                {
                    HeadImage* img = [HeadImage imgWithUrl:value];
                    UserInfoManagerInstance().userInfo.headimage = img;
                    if(img.data == nil)
                    {
                        ClassAttachmentDownloader* downloader = [[[ClassAttachmentDownloader alloc] init] autorelease];
                        [downloader startDownload:img.url delegate:self];
                    }
                    
                }

            }
                        
            id pushinfodata = [data objectForKey:PUSHINFO];
            if(pushinfodata != nil && [pushinfodata isKindOfClass:[NSDictionary class]])
            {
                //ifpush
                id foundData = [pushinfodata objectForKey:IFPUSH];
                if(foundData != nil && [foundData isKindOfClass:[NSString class]]){
                    UserInfoManagerInstance().userInfo.ispush = [NSNumber numberWithBool:[foundData boolValue]];
                }
                //ifsound
                foundData = [pushinfodata objectForKey:IFSOUND];
                if(foundData != nil && [foundData isKindOfClass:[NSString class]])
                {
                    UserInfoManagerInstance().userInfo.issound = [NSNumber numberWithBool:[foundData boolValue]];;
                }
                //ifshake
                foundData = [pushinfodata objectForKey:IFSHAKE];
                if(foundData != nil && [foundData isKindOfClass:[NSString class]])
                {
                    UserInfoManagerInstance().userInfo.isshake = [NSNumber numberWithBool:[foundData boolValue]];;
                }
                //pushtime
                id pushtimeData = [pushinfodata objectForKey:PUSHTIME];
                if(pushtimeData != nil && pushtimeData != [NSNull null] && [pushtimeData isKindOfClass:[NSArray class]]){
                    id timeData = [pushtimeData lastObject];
                    if(timeData != nil && [timeData isKindOfClass:[NSDictionary class]]){
                        //start
                        id timestart = [timeData objectForKey:PUSH_START];
                        if(timestart != nil && [timestart isKindOfClass:[NSString class]]){
                            UserInfoManagerInstance().userInfo.pushstart = timestart;
                        }
                        //end
                        id timeend = [timeData objectForKey:PUSH_END];
                        if(timeend != nil && [timeend isKindOfClass:[NSString class]]){
                            UserInfoManagerInstance().userInfo.pushend = timeend;
                        }
                    }
                }
            }
            
            // TODO:可发送分类
            id foudValue = [data objectForKey:SENDPERMIS];
            if(nil != foudValue && [NSNull null] != foudValue && [foudValue isKindOfClass:[NSArray class]]) {
                // TODO:禁止所有分类发送
                NSArray *array = [ClassDataManager categoryList];
                for(ClassEventCategory *item in array) {
                    item.bSend = [NSNumber numberWithBool:NO];
                }
                // TODO:开发可发送分类
                for(NSString *itemId in foudValue) {
                    ClassEventCategory *item = [ClassDataManager queryCategaoryWithId:itemId];
                    if(item) {
                        item.bSend = [NSNumber numberWithBool:YES];
                    }
                }
            }
            
            success = [self isOnline];
            _loginStatus = success ? LoginStatus_online : _loginStatus;
        }
        else
        {
            opcode = [oprect objectForKey:OPCODE];
        }
    }
    
    // TODO:同步收藏
    [self synchronizeBookmarkEvent];
    
    // TODO:回调界面
    if (success)
    {
        [self callDelegateChangeStatus];
    }
    else
    {
        [_accountName release];
        _accountName = nil;
        
        NSString *error = (nil!=opcode && [opcode length]>0) ? ErrorCodeToString(opcode) : ProtocalError;
        [self callDelegateError:_handleStatus error:error];
    }
    _handleStatus = LoginManagerHandleNone;
}
    
-(UserType)userTypeWithData:(id)data
{
    UserType userType = UserTypeStudent;
    if ([data isKindOfClass:[NSString class]])
    {
        if ([ACCTYPE_STUDENT isEqualToString:data]){
            userType = UserTypeStudent;
        }
        else if ([ACCTYPE_TEACHER isEqualToString:data]){
            userType = UserTypeTeacher;
        }
        else if ([ACCTYPE_PARENT isEqualToString:data]){
            userType = UserTypeParent;
        }
    }
    return userType;
}

-(BOOL)logout
{
    if (LoginManagerHandleNone == _handleStatus && LoginStatus_off != _loginStatus){
        _handleStatus = LoginManagerHandleLogout;
        //[self.commonRequestOperator logout];
        [self handleLogout:nil];
        return YES;
    }
    else if (LoginManagerHandleLogout == _handleStatus){
        return YES;
    }
    else{
        return NO;
    }
}

-(void)handleLogout:(id)data
{
    BOOL success = NO;
    // 清除班级分类最后更新
    [ClassDataManager removeAllCategoryLasUpdate];
    
//    NSString* opcode = nil;
//    if ([data isKindOfClass:[NSDictionary class]])
//    {
//        // opret protocal
//        NSDictionary* oprect = [data objectForKey:OPRET];
//        NSString* opflag = [oprect objectForKey:OPFLAG];
//        if ([opflag isEqualToString:OPFLAGSUCCESS])
//        {
            [_sessionKey release];
            _sessionKey = nil;
            
            _userType = UserTypeUnkonw;
            _loginStatus = LoginStatus_off;
            [_accountName release];
            _accountName = nil;
            
            success = YES;

//        }
//        else
//        {
//            opcode = [oprect objectForKey:OPCODE];
//        }
//    }
    
    if (success)
    {
        [self callDelegateChangeStatus];
    }
    _handleStatus = LoginManagerHandleNone;
//    else
//    {
//        NSString *error = (nil!=opcode && [opcode length]>0) ? opcode : ProtocalError;
//        [self callDelegateError:_handleStatus error:error];
//    }
}

-(BOOL)isOnline
{
    return (nil != _sessionKey && [_sessionKey length] > 0);
}

-(UserType)getUserType
{
    return _userType;
}

#pragma mark - local (login/logout..)
-(BOOL)localLogin:(NSString*)username password:(NSString*)password
{
    BOOL result = NO;
    if (LoginStatus_online == _loginStatus)
    {
        result = YES;
    }
    else if (LoginStatus_off == _loginStatus)
    {
        // compare local password
        if ([UserInfoManagerInstance().userInfo.password isEqualToString:password])
        {
            //[_accountName release];
            _accountName = [username retain];
            _loginStatus = LoginStatus_local;
            _userType = (UserType)[UserInfoManagerInstance().userInfo.usertype integerValue];
            [self callDelegateChangeStatus];
            result = YES;
        }
        else
        {
            [self callDelegateError:LoginManagerHandleLocalLogin error:LoginUserOrPswError];
        }
    }
    return result;
}

-(BOOL)autoLocalLogin
{
    if (LoginStatus_online == _loginStatus)
    {
        _loginStatus = LoginStatus_local;
        [self callDelegateChangeStatus];
        return YES;
    }
    return NO;
}

-(BOOL)localLogout
{
    if (LoginStatus_local == _loginStatus)
    {
        _loginStatus = LoginStatus_off;
        [_accountName release];
        _accountName = nil;
        [self callDelegateChangeStatus];
        return YES;
    }
    return NO;
}

#pragma mark ClassAttachmentDownloaderDelegate <NSObject>
- (void)attachmentDownloader:(ClassAttachmentDownloader*)attachmentDownloader downloadFinish:(NSData*)data contentType:(NSString*)contentType
{
    HeadImage* img = [HeadImage imgWithUrl:attachmentDownloader.url];
    img.data = data;
    [CoreDataManager saveData];
    UserInfoManagerInstance().userInfo.headimage = img;
    return;
}
- (void)attachmentDownloader:(ClassAttachmentDownloader *)attachmentDownloader downloadFail:(NSError*)error
{
    return;
}
#pragma mark - (同步收藏)
- (BOOL)synchronizeBookmarkEvent {
    // TODO:获取服务器收藏
    ClassEvent *event = [ClassDataManager eventLastSynchronize];
    
    [self cancelSynchronize];
    if(!self.classRequestOperator) {
        self.classRequestOperator = [[[ClassRequestOperator alloc] init] autorelease];
        self.classRequestOperator.delegate = self;
    }
    
    NSInteger favourLastUpdate = [event.favourLastUpdate timeIntervalSinceReferenceDate];
    return [self.classRequestOperator getBookmarkEvent:favourLastUpdate];
}
- (BOOL)submitBookmarkEvent {
    // TODO:同步本地修改收藏到服务器
    NSArray *array = [ClassDataManager eventListWithBookmarkSynchronize];
    
    [self cancelSynchronize];
    if(!self.classRequestOperator) {
        self.classRequestOperator = [[[ClassRequestOperator alloc] init] autorelease];
        self.classRequestOperator.delegate = self;
    }
    return [self.classRequestOperator submitBookmarkEvent:array];
}
#pragma mark - (班级协议回调 ClassRequestOperatorDelegate)
- (void)operateFinish:(id)json requestType:(ClassRequestOperatorStatus)type {
    [self cancelSynchronize];
    switch (type) {
        case ClassRequestOperator_GetBookmarkEvent: {
            // TODO:获取服务器收藏成功,开始同步本地修改
            [self submitBookmarkEvent];
        }break;
        case ClassRequestOperator_SubmitBookmarkEvent: {
            
        }break;
        default:
            break;
    }
}
-(void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancelSynchronize];
    switch (type) {
        case ClassRequestOperator_GetBookmarkEvent: {
        }break;
        case ClassRequestOperator_SubmitBookmarkEvent: {

        }break;
        default:
            break;
    }
}
#pragma mark - (协议回调 CommonRequestOperatorDelegate)
-(void)requestFinish:(id)json requestType:(CommonRequestOperatorStatus)type {
    LoginManagerHandleStatus handleStatus = _handleStatus;
    [self cancel];
    switch (type) {
        case CommonRequestOperatorStatus_Login: {
            if (LoginManagerHandleLogin == handleStatus) {
                [self handleLogin:json];
            }
            else if (LoginManagerHandleLogout == handleStatus)
            {
                // 不等注销
                [self handleLogout:json];
            }
        }break;
        case CommonRequestOperatorStatus_Logout: {
            
        }break;
        default:
            break;
    }
}
-(void)requestFail:(NSString*)error requestType:(CommonRequestOperatorStatus)type {
    LoginManagerHandleStatus status = _handleStatus;
    [self cancel];
    switch (type) {
        case CommonRequestOperatorStatus_Login: {
            if([error isEqualToString:CommonRequestGetGatewayFailed] || [error isEqualToString:CONNECTION_ERROR])
                [self localLogin:self.accountName password:self.password];
            else
                [self callDelegateError:status error:error];
        }break;
        case CommonRequestOperatorStatus_Logout: {
            // 不处理注销返回
            //[self handleLogout:nil];
        }break;
        default:
            break;
    }
}
@end
