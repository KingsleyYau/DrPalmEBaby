//
//  CustomUserInfo.m
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-8-16.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomUserInfo.h"
#import "CoreDataManager.h"
@implementation UserInfo(Custom)

-(BOOL)userIsExist:(NSString*)username
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"username == %@",username];
    NSArray* array = [CoreDataManager objectsForEntity:UserInfoEntityName matchingPredicate:predicate];
    if(array!=nil && array.count > 0)
        return YES;
    else
        return NO;
}

+(UserInfo*)getUserInfo:(NSString*)username
{
    UserInfo* userInfo = nil;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"username == %@",username];
    userInfo = [[CoreDataManager objectsForEntity:UserInfoEntityName matchingPredicate:predicate] lastObject];
    if(userInfo==nil)
    {
        userInfo = [CoreDataManager insertNewObjectForEntityForName:UserInfoEntityName];
    }
    userInfo.username = username;
    return userInfo;
}

@end
