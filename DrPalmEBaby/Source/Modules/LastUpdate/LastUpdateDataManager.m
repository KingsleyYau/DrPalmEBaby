//
//  LastUpdateDataManager.m
//  DrPalm
//
//  Created by drcom on 13-3-5.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "LastUpdateDataManager.h"
#import "CustromLastUpdate.h"
#import "LoginManager.h"

@implementation LastUpdateDataManager

+(BOOL)updateLastUpdateWithCategory:(NSInteger)category lastupdate:(NSDate*)lastupdate hasUser:(BOOL)hasUser
{
    
    NSPredicate *predicate = nil;
    if(!hasUser)
        predicate = [NSPredicate predicateWithFormat:@"category == %d", category];
    else
        predicate = [NSPredicate predicateWithFormat:@"(category == %d) and (user == %@)",category,LoginManagerInstance().accountName];
    LastUpdate *item = [[CoreDataManager objectsForEntity:LastUpdateEntityName matchingPredicate:predicate] lastObject];
    if(item == nil)
        item = (LastUpdate*) [CoreDataManager insertNewObjectForEntityForName:LastUpdateEntityName];
    
    item.category = [NSNumber numberWithInteger:category];
    item.lastupdate = lastupdate;
    if(hasUser)
        item.user = LoginManagerInstance().accountName;
    //[item updateWithCategory:category lastupdate:lastupdate hasUser:hasUser];
    [CoreDataManager saveData];
    return YES;
}
+(NSDate*)getLastUpdateWithCategory:(NSInteger)category hasUser:(BOOL)hasUser
{
    NSDate* date = nil;
    LastUpdate *item = nil;
    NSPredicate* predicate = nil;
    if(!hasUser)
        predicate = [NSPredicate predicateWithFormat:@"category == %d", category];
    else
        predicate = [NSPredicate predicateWithFormat:@"(category == %d) and (user == %@)",category,LoginManagerInstance().accountName];
    item = [[CoreDataManager objectsForEntity:LastUpdateEntityName matchingPredicate:predicate] lastObject];
    if(item != nil)
        date = item.lastupdate;

    return date;
}

+(void)clearSchoolLastUpdate
{
    NSDate* time = [NSDate dateWithTimeIntervalSince1970:0];
    for(int i=Category_SchoolActivity; i <=Category_SchoolMain ; i++)
    {
        [LastUpdateDataManager updateLastUpdateWithCategory:i lastupdate:time hasUser:NO];
    }
    return;
}

+(void)clearClassLastUpdate
{
    NSDate* time = [NSDate dateWithTimeIntervalSince1970:0];
    for(int i=Category_ClassNews; i <=Category_ClassSent ; i++)
    {
        [LastUpdateDataManager updateLastUpdateWithCategory:i lastupdate:time hasUser:YES];
    }
    return;
}

+ (void)updateUnReadCountWithCategory:(NSInteger)category unReadCount:(NSNumber *)unReadCount hasUser:(BOOL)hasUser {
    NSPredicate *predicate = nil;
    if(!hasUser)
        predicate = [NSPredicate predicateWithFormat:@"category == %d", category];
    else
        predicate = [NSPredicate predicateWithFormat:@"(category == %d) and (user == %@)",category,LoginManagerInstance().accountName];
    LastUpdate *item = [[CoreDataManager objectsForEntity:LastUpdateEntityName matchingPredicate:predicate] lastObject];
    if(item == nil)
        item = (LastUpdate*) [CoreDataManager insertNewObjectForEntityForName:LastUpdateEntityName];
    
    item.category = [NSNumber numberWithInteger:category];
    item.unReadCount =  unReadCount;
    if(hasUser)
        item.user = LoginManagerInstance().accountName;
    [CoreDataManager saveData];
}
+ (NSNumber *)getUnReadCountWithCategory:(NSInteger)category hasUser:(BOOL)hasUser {
    NSPredicate* predicate = nil;
    if(!hasUser)
        predicate = [NSPredicate predicateWithFormat:@"category == %d", category];
    else
        predicate = [NSPredicate predicateWithFormat:@"(category == %d) and (user == %@)",category,LoginManagerInstance().accountName];
    LastUpdate *item = [[CoreDataManager objectsForEntity:LastUpdateEntityName matchingPredicate:predicate] lastObject];
    return item.unReadCount;
}


@end
