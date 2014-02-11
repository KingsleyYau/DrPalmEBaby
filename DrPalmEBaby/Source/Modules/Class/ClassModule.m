//
//  ClassModule.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-9.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "ClassModule.h"
#import "ClassCommonDef.h"
#import "ClassMainViewController.h"

#import "LoginManager.h"
#import "QLoginViewController.h"
@interface ClassModule () {
    
}
@property (nonatomic, strong) ClassMainViewController *vc;
@property (nonatomic, strong) QLoginViewController *qvc;
@end

@implementation ClassModule
- (NSString*)moduleName {
    return @"class";
}
- (UIViewController *)viewController {
    UIViewController *mvc = nil;
    
    LoginManager *loginManager = LoginManagerInstance();
    if (LoginStatus_online == loginManager.loginStatus ||
        LoginStatus_local == loginManager.loginStatus) {
        // 已经登陆
        if(!self.vc) {
            UIStoryboard *storyBoard = AppDelegate().storyBoard;
            ClassMainViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassMainViewController"];
            self.vc = vc;
        }
        self.vc.needGetUnreadCount = YES;
        mvc = self.vc;
    }
    else{
        // 没有登陆
        if(!self.qvc) {
            UIStoryboard *storyBoard = AppDelegate().storyBoard;
            QLoginViewController *qvc = [storyBoard instantiateViewControllerWithIdentifier:@"QLoginViewController"];
            self.qvc = qvc;
        }
        mvc = self.qvc;
    }
    
    return mvc;
}
- (NSString *)iconName {
    LoginManager *loginManager = LoginManagerInstance();
    if (LoginStatus_off == loginManager.loginStatus){
        return @"class-lock";
    }
    else {
        return @"class";
    }
}
@end
