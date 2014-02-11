//
//  CustomUserInfo.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-8-16.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface UserInfo(Custom)

-(BOOL)userIsExist:(NSString*)username;
+(UserInfo*)getUserInfo:(NSString*)username;

@end
