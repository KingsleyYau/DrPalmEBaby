//
//  AppDelegate.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-11.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppEnviroment.h"
#import "DrPalmGateWayManager.h"
#import "LoginManager.h"
#import "UserInfoManager.h"
#import "EBabyModuleList.h"
#import "ResourcePacketManager.h"

#import "WXApi.h"
#import "WeiboSDK.h"

#import "WelcomeViewController.h"
#import "UpdateAppViewController.h"

#define AppDelegate() ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define AppEnviromentInstance() AppDelegate().appEnviroment
#define LoginManagerInstance() AppDelegate().loginManager
#define DrPalmGateWayManagerInstance() AppDelegate().gatewayManager
#define UserInfoManagerInstance() AppDelegate().userInfoManager
#define EBabyModuleListInstance() AppDelegate().modulesList
#define ResourcePacketManagerInstance() AppDelegate().resPacketManager

@class ClassEventCategory;
@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate, WeiboSDKDelegate, LoginManagerDelegate> {
    NSUncaughtExceptionHandler *_handler;
}

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic, readonly) UIStoryboard *storyBoard;
@property (strong, nonatomic) AppEnviroment *appEnviroment;             // 全局风格属性控制器
@property (strong, nonatomic) LoginManager *loginManager;               // 登陆控制器
@property (strong, nonatomic) DrPalmGateWayManager *gatewayManager;     // 网关控制器
@property (strong, nonatomic) UserInfoManager *userInfoManager;         // 用户信息控制器
@property (strong, nonatomic) NSString *deviceToken;                    // 设备码
@property (strong, nonatomic) EBabyModuleList *modulesList;             // 模块控制器
@property (strong, nonatomic) ResourcePacketManager *resPacketManager;  // 资源包管理器

@property (strong, nonatomic) WelcomeViewController *welcomeViewController; // 欢迎界面
@property (strong, nonatomic) UpdateAppViewController *updateAppViewController; // 升级界面
@property (strong, nonatomic) MYUIStatusBar *myStatusBar; // 状态栏

- (NSString *)applicationDocumentsDirectory; // 程序可写目录(Document)
- (void)unReadCountDesc:(ClassEventCategory *)category; // 本地计算未读通告条数
- (void)reloadTabBarItem;
- (BOOL)logCrashToFile:(NSString *)errorString;
@end
