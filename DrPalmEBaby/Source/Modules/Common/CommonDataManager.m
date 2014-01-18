//
//  CommonDataManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-25.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CommonDataManager.h"
#import "LoginManager.h"

@implementation CommonDataManager
#pragma mark - 最新消息模块 (LatestItem)
// 查找新闻
+ (NSArray *)newsLateList {    
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryType == %@", SCHOOL_NEWS];
    NSArray *items = [CoreDataManager objectsForEntity:LatestItemEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 添加一条新闻
+ (LatestItem *)newsWitdhDict:(NSDictionary *)dict {
    NSString *itemId = [LatestItem idWithNewsDict:dict];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(item_id == %@) and (categoryType == %@)", itemId, SCHOOL_NEWS];
    LatestItem *item = [[CoreDataManager objectsForEntity:LatestItemEntityName matchingPredicate:predicate] lastObject];
    if(!item) {
        item = (LatestItem *)[CoreDataManager insertNewObjectForEntityForName:LatestItemEntityName];
    }
    [item updateWithNewsDict:dict];
    return item;
}
// 查找通告
+ (NSArray *)eventsLateList {
    NSString *user = @"";
    if(LoginManagerInstance().accountName) {
        user = LoginManagerInstance().accountName;
    }
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(categoryType == %@) and (user == %@)", CLASS_EVENT, user];
    NSArray *items = [CoreDataManager objectsForEntity:LatestItemEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 添加一条通告
+ (LatestItem *)eventWitdhDict:(NSDictionary *)dict {
    NSString *user = @"";
    if(LoginManagerInstance().accountName) {
        user = LoginManagerInstance().accountName;
    }
    
    NSString *itemId = [LatestItem idWithEventDict:dict];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(item_id == %@) and (categoryType == %@) and (user == %@)", itemId, CLASS_EVENT, user];
    LatestItem *item = [[CoreDataManager objectsForEntity:LatestItemEntityName matchingPredicate:predicate] lastObject];
    if(!item) {
        item = (LatestItem *)[CoreDataManager insertNewObjectForEntityForName:LatestItemEntityName];
    }
    [item updateWithEventDict:dict];
    return item;
}

+ (void)removeAll
{
    //清除新闻
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(categoryType == %@)",SCHOOL_NEWS];
    NSArray* newsArray = [CoreDataManager objectsForEntity:LatestItemEntityName matchingPredicate:predicate];
    if(newsArray != nil && newsArray.count > 0)
    {
        [CoreDataManager deleteObjects:newsArray];
        [CoreDataManager saveData];
    }
    
    //清除通告
    if(LoginManagerInstance().loginStatus == LoginStatus_online)
    {
        predicate = [NSPredicate predicateWithFormat:@"(categoryType == %@) and (user == %@)",CLASS_EVENT,LoginManagerInstance().accountName];
        NSArray* eventsArray = [CoreDataManager objectsForEntity:LatestItemEntityName matchingPredicate:predicate];
        if(eventsArray != nil && eventsArray.count >0)
        {
            [CoreDataManager deleteObjects:eventsArray];
            [CoreDataManager saveData];
        }
    }
    return;
}
@end
