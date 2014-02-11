//
//  HttpHandler.h
//  DrCOMClientWS
//
//  Created by Keqin Su on 11-4-18.
//  Copyright 2011 City Hotspot Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpHandlerDelegate.h"

@interface HttpHandler : NSObject {
	NSURLConnection *requestConn;
	NSMutableData *responseData;
	id<HttpHandlerDelegate> recvObj;
    
    NSStringEncoding encoding;
    NSURL *originalurl;
    NSURL *currenturl;
    NSString *gwHost;
    NSString *callmode;
}

- (void)setRecvObj:(id<HttpHandlerDelegate>)obj;
- (void)urlRequest:(NSString*)url data:(NSString*)data type:(NSString*)type callbackmode:(NSString*)callbackmode;
- (void)cancelPost;

@end
