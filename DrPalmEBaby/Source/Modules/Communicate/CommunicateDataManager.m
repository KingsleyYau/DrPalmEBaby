//
//  CommunicateDataManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CommunicateDataManager.h"
#import "LoginManager.h"
@implementation CommunicateDataManager
// 按联系人获取对话列表
+ (NSArray *)contentListWithManId:(NSString *)manId {
    NSPredicate *predicate = nil;
    NSSortDescriptor *messageIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastupdate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:messageIdSortDescriptor, nil];
    [messageIdSortDescriptor release];
    
	predicate = [NSPredicate predicateWithFormat:@"(contactMan.contact_id == %@) and (contactMan.user == %@)", manId, [LoginManagerInstance() accountName]];
    
    // show everything that comes back
    NSArray *results = [CoreDataManager objectsForEntity:CommunicateListEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return results;
}
//获取联系人列表
+ (NSArray *)getCommunicateManList
{
    NSPredicate *predicate = nil;
    NSSortDescriptor* communicateManSortDescripotor = [[NSSortDescriptor alloc] initWithKey:@"lastMessageDate" ascending:NO];
    NSSortDescriptor* nameSortDescripotor = [[NSSortDescriptor alloc] initWithKey:@"contact_id" ascending:YES];
    NSArray* sortDescriptors = [NSArray arrayWithObjects:communicateManSortDescripotor,nameSortDescripotor, nil];
    [communicateManSortDescripotor release];
    
    predicate = [NSPredicate predicateWithFormat:@"user == %@",[LoginManagerInstance() accountName]];
    
    NSArray* results = [CoreDataManager objectsForEntity:CommunicateManEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return results;
}
//删除联系人列表
+ (void)delCommunicateManList
{
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"user == %@",[LoginManagerInstance() accountName]];
    
    NSArray* results = [CoreDataManager objectsForEntity:CommunicateManEntityName matchingPredicate:predicate];
    if(results)
    {
        [CoreDataManager deleteObjects:results];
        [CoreDataManager saveData];
    }
}

// 添加一个联系人
+ (CommunicateMan *)manWithId:(NSString *)manId {
    CommunicateMan *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contact_id == %@ and (user == %@)", manId, [LoginManagerInstance() accountName]];
    item = [[CoreDataManager objectsForEntity:CommunicateManEntityName matchingPredicate:predicate] lastObject];
    return item;
}
+ (CommunicateMan *)manWithDict:(NSDictionary *)dict {
    CommunicateMan *item = nil;
    NSString *manId = [CommunicateMan idWithDict:dict];
    item = [CommunicateDataManager manWithId:manId];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:CommunicateManEntityName];
    }
    [item updateWithDict:dict];
    return item;
}
// 按联系人添加一条内容
+ (CommunicateList *)contentWithId:(NSString *)msgId manId:(NSString *)manId {
    CommunicateList *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(message_id == %@) and (contactMan.contact_id == %@) and (contactMan.user == %@)", msgId, manId, [LoginManagerInstance() accountName]];
    item = [[CoreDataManager objectsForEntity:CommunicateListEntityName matchingPredicate:predicate] lastObject];
    return item;
}
+ (CommunicateList *)contentWithDict:(NSDictionary *)dict manId:(NSString *)manId {
    CommunicateList *item = nil;
    NSString *msgId = [CommunicateList idWithDict:dict];
    item = [CommunicateDataManager contentWithId:msgId manId:manId];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:CommunicateListEntityName ];
    }
    [item updateWithDict:dict manId:manId];
    return item;
}
#pragma mark - 文件模块 (CommunicateFile)
// 插入文件
+ (CommunicateFile *)fileWithUrl:(NSString *)url isLocal:(Boolean)isLocal {
    CommunicateFile *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path == %@", url];
    item = [[CoreDataManager objectsForEntity:ClassFileEntityName matchingPredicate:predicate] lastObject];
    if (!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:CommunicateFileEntityName];
    }
    [item updateWithImageUrl:url isLocal:isLocal];
    return item;
}
@end
