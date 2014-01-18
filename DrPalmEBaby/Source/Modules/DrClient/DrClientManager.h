//
//  DrClientManager.h
//  DrPalm
//
//  Created by fgx_lion on 12-3-19.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpHandlerDelegate.h"

typedef enum {
    DrClientConnectFail,
}DrClientErrorCode;

@protocol DrClientManagerDelegate <NSObject>
- (void)loginSuccess;
- (void)loginFail:(NSString*)error;
- (void)logoutSuccess;
//- (void)logoutFail:(NSString*)error;
- (void)requestFail:(NSString*)error;
- (void)statusChange:(NSString*)time flow:(NSString*)flow;
@end

@class HttpHandler;
@interface DrClientManager : NSObject<HttpHandlerDelegate>{
    id<DrClientManagerDelegate> _delegate;
    
    NSString    *_loginUsername;
    NSString    *_loginPassword;
    NSString    *_gwUrl;
    BOOL        _successed;
    BOOL        _sendUpdate;
    NSInteger   _checkTime;
    NSString    *_errorMessage;
    NSString    *_macList;
    NSTimer     *_timer;
    HttpHandler *_httpControl;
    HttpHandler *_httpVersion;
}

@property (nonatomic, retain) id<DrClientManagerDelegate>   delegate;
@property (nonatomic, retain) NSString* loginUsername;
@property (nonatomic, retain) NSString* loginPassword;
@property (nonatomic, retain) NSString* gwUrl;
@property (nonatomic, retain) NSString* macList;
@property (nonatomic, retain) NSString* errorMessage;
@property (nonatomic, retain) NSTimer*  timer;
@property (nonatomic, retain) HttpHandler*  httpControl;
@property (nonatomic, retain) HttpHandler*  httpVersion;

- (BOOL)login:(NSString*)username password:(NSString*)password;
- (BOOL)logout;
@end
