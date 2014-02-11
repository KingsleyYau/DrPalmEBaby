//
//  CommonDataManager.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-25.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"

#import "CustomLatestItem.h"
#import "GrowDiary+Custom.h"

@interface CommonDataManager : NSObject

#pragma mark - 最新消息模块 (LatestItem)
// 查找新闻
+ (NSArray *)newsLateList;
// 添加一条新闻
+ (LatestItem *)newsWitdhDict:(NSDictionary *)dict;
// 查找通告
+ (NSArray *)eventsLateList;
// 添加一条通告
+ (LatestItem *)eventWitdhDict:(NSDictionary *)dict;
//清除所有
+ (void)removeAll;

@end
