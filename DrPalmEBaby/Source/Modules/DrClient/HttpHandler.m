//
//  HttpHandler.m
//  DrCOMClientWS
//
//  Created by Keqin Su	on 11-4-18.
//  Copyright 2011 City Hotspot Co., Ltd. All rights reserved.
//

#import "HttpHandler.h"
#import "Utilities.h"
#import "DrCOMDefine.h"

@interface HttpHandler(private) 

- (void)releaseHandle;
@end

@implementation HttpHandler

-(id)init {
	if (self == [super init]) {
		responseData = [[NSMutableData alloc] init];
	}
    encoding = NSUTF8StringEncoding;
    originalurl = nil;
    currenturl = nil;
    gwHost = nil;
    callmode = nil;
	return self;
}

- (void)dealloc {
	[recvObj release];
	[responseData release];

    if (requestConn) {
        [self cancelPost];
    }
	
	[originalurl release];
	originalurl = nil;
    
	[currenturl release];
	currenturl = nil;
    
	[gwHost release];
	gwHost =nil;
	
	[super dealloc];
}

- (void)setRecvObj:(id<HttpHandlerDelegate>)obj 
{ 
    [recvObj release];
    recvObj = [obj retain];
}

- (void)urlRequest:(NSString*)url data:(NSString*)data type:(NSString*)type callbackmode:(NSString*)callbackmode{
	NSURL *tmpUrl = [[NSURL URLWithString:url] retain];
	[originalurl release];
	originalurl = tmpUrl;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:originalurl];
		
	if ([type isEqualToString:@"POST"]) {
		if ([data length] > 0) {
			[request setHTTPMethod:@"POST"];			
			NSString *postLength = [NSString stringWithFormat:@"%d", [data length]];
			[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
			
			NSDate *date = [NSDate date];
			NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
			NSString* strDate = [formatter stringFromDate:date];
			[formatter release];
			NSString *strUrl = [NSString stringWithFormat:@"%@%@", data, strDate];
			NSString *strUip = [NSString stringWithFormat:@"%@.%@", DrCOM_Uip, [Utilities MD5StringOfString:strUrl]];

			[request setValue:strDate forHTTPHeaderField:@"Date"];
			[request setValue:strUip forHTTPHeaderField:@"Uip"];
		}
	} else {
		[request setHTTPMethod:@"GET"];
	}
	
	[request setValue:@"text/xml" forHTTPHeaderField: @"Content-Type"];
	[request setValue:@"utf-8" forHTTPHeaderField: @"Charset"];
	
	NSData *body = [data dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:body];
	
	[callbackmode retain];
	[callmode release];
	callmode = callbackmode;
	
	requestConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancelPost {
	[requestConn cancel];
	[self releaseHandle];
}

- (NSURLRequest*)connection:(NSURLConnection*)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse *httpRespones = (NSHTTPURLResponse*)response;
	if ([response respondsToSelector:@selector(allHeaderFields)]) {
		NSDictionary *dictionary = [httpRespones allHeaderFields];
		NSString *tmpHost = [[dictionary valueForKey:@"Server"] retain];
		[gwHost release];
		gwHost = tmpHost;
	}
	
	encoding = NSUTF8StringEncoding;
	NSString *type = [response textEncodingName]; 
	if ([type isEqualToString:@"zh-cn"] || [type isEqualToString:@"gb2312"] || [type isEqualToString:@""] || (type == nil)) {
		encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	}
	
	NSURL *tmpUrl = [[response URL] retain];
	[currenturl release];
	currenturl = tmpUrl;
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self releaseHandle];
	
	NSString *data = [[NSString alloc] initWithData:responseData encoding:encoding];
    if (recvObj) {
        if ([callmode isEqualToString:@"Check"]) {
            [recvObj onHttpReceiveForCheck:data original:originalurl current:currenturl gwHost:gwHost];
        } else if ([callmode isEqualToString:@"Login"]) {
            [recvObj onHttpReceiveForLogin:data];
        } else if ([callmode isEqualToString:@"Logout"]) {
            [recvObj onHttpReceiveForLogout:data];		
        } else if ([callmode isEqualToString:@"Status"]) {
            [recvObj onHttpReceiveForStatus:data];
        } else if ([callmode isEqualToString:@"Version"]) {
            [recvObj onHttpReceiveForVersion:data];        
        }
    }

	[data release];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
	//NSLog(@"code: %d, domain: %@, localizedDesc: %@",[error code],[error domain],[error localizedDescription]);
    if (recvObj) {    
        if (![callmode isEqualToString:@"Version"]) {
            [recvObj onHttpError:error];
        }
    }
	
	[self releaseHandle];
}

-(void)releaseHandle {
	[requestConn release];
	requestConn = nil;
}
@end

@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
	return YES; // Should probably return YES only for a specific host
}

@end
