//
//  SystemMessageDataManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "SystemMessageDataManager.h"
#import "LoginManager.h"
@implementation SystemMessageDataManager
// 获取系统消息列表
+ (NSArray *)messageList {
    NSPredicate *predicate = nil;
    NSSortDescriptor *systemIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"system_id" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:systemIdSortDescriptor, nil];
    [systemIdSortDescriptor release];
    
	predicate = [NSPredicate predicateWithFormat:@"user == %@", [LoginManagerInstance() accountName]];
    
    // show everything that comes back
    NSArray *results = [CoreDataManager objectsForEntity:SystemMessageEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return results;
}
// 添加一条系统消息
+ (SystemMessage *)messageWithId:(NSString *)msgId {
    SystemMessage *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(system_id == %@) and (user == %@)", msgId, [LoginManagerInstance() accountName]];
    item = [[CoreDataManager objectsForEntity:SystemMessageEntityName matchingPredicate:predicate] lastObject];
    return item;
}
+ (SystemMessage *)messageWithDict:(NSDictionary *)dict {
    SystemMessage *item = nil;
    NSString *msgId = [SystemMessage idWithDict:dict];
    item = [SystemMessageDataManager messageWithId:msgId];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:SystemMessageEntityName];
    }
    [item updateWithDict:dict];
    return item;
}
@end
