//
//  LoginManager.h
//  MIT Mobile
//
//  Created by fgx_lion on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//  登录模块，负责向网关登录，并记录登录信息

#import <Foundation/Foundation.h>

typedef enum
{
    LoginStatus_off,
    LoginStatus_local,
    LoginStatus_online,
}LoginStatus;

typedef enum 
{
    UserTypeUnkonw,
    UserTypeStudent,
    UserTypeTeacher,
    UserTypeParent
}UserType;

typedef enum
{
    LoginManagerHandleNone,
    LoginManagerHandleLogin,
    LoginManagerHandleLogout,
    LoginManagerHandleLocalLogin
}LoginManagerHandleStatus;

@protocol LoginManagerDelegate <NSObject>
@optional
- (void)loginStatusChanged:(LoginStatus)status;
- (void)handleError:(LoginManagerHandleStatus)status error:(NSString*)error;
@end

@class LoginSuccessOperationManager;
@interface LoginManager : NSObject
{
    NSString* _sessionKey;
    NSString* _accountName;
    NSString* _memberKey;
    NSString* _userName;
    NSString* _password;
    UserType _userType;
    NSInteger   _ungetEventCount;
    LoginManagerHandleStatus _handleStatus;
    LoginStatus _loginStatus;
    
    ConnectionWrapper *_connectionWrapper;
    NSMutableSet* _delegates;
    
    NSString* _requestUrlPath;
    NSMutableDictionary* _requestParams;
    
    LoginSuccessOperationManager    *_loginSuccessOpertionManager;
    NSLock *_delegateLock;
}
@property (nonatomic, readonly) NSString* accountName;
@property (nonatomic, readonly) NSString* userName;
@property (nonatomic, readonly) NSString* password;
@property (nonatomic, readonly) NSString* memberKey;
@property (nonatomic, readonly) NSString* sessionKey;
//@property (nonatomic, retain) NSString* sessionKey;
@property (nonatomic, readonly) LoginStatus loginStatus;
@property (nonatomic, readonly) NSInteger   ungetEventCount;
@property (nonatomic, readonly) LoginManagerHandleStatus handleStatus;
@property (nonatomic, readonly) UserType userType;

-(void)addDelegate:(id<LoginManagerDelegate>)delegate;
-(void)removeDelegate:(id<LoginManagerDelegate>)delegate;

-(BOOL)autoLogin;
-(BOOL)login:(NSString*)username password:(NSString*)password;
-(BOOL)logout;
-(void)cancel;

-(BOOL)localLogin:(NSString*)username password:(NSString*)password;
-(BOOL)autoLocalLogin;
-(BOOL)localLogout;

- (void)reset;
-(UserType)getUserType;
@end

#define IsOnlineStatus  (LoginStatus_online == LoginManagerInstance().loginStatus)
