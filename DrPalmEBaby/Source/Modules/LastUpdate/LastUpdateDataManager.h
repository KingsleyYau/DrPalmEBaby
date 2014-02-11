//
//  LastUpdateDataManager.h
//  DrPalm
//
//  Created by drcom on 13-3-5.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "ListCategoryDef.h"

#define UPDATETIMEINTEVAL    15*60            //自动刷新间隔时间

@interface LastUpdateDataManager : NSObject

+(BOOL)updateLastUpdateWithCategory:(NSInteger)category lastupdate:(NSDate*)lastupdate hasUser:(BOOL)hasUser;
+(NSDate*)getLastUpdateWithCategory:(NSInteger)category hasUser:(BOOL)hasUser;


+(void)clearSchoolLastUpdate;
+(void)clearClassLastUpdate;

+ (void)updateUnReadCountWithCategory:(NSInteger)category unReadCount:(NSNumber *)unReadCount hasUser:(BOOL)hasUser;
+ (NSNumber *)getUnReadCountWithCategory:(NSInteger)category hasUser:(BOOL)hasUser;
@end
