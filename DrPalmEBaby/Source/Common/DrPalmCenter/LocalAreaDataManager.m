//
//  DrPalmCenterDataManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "LocalAreaDataManager.h"

@implementation LocalAreaDataManager

#pragma mark - (代理商/机构/幼儿园集合)模块
#pragma mark 添加(代理商/机构/幼儿园集合)
#pragma mark 查找区域
+ (Agent *)agentWithId:(NSString *)itemId {
    Agent *item = nil;
    NSSortDescriptor *idSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"localID" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    [idSortDescriptor release];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localID == %@", itemId];
    item = [[LocalCoreDataManager objectsForEntity:AgentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors] lastObject];
    
    return item;
}
+ (Agent *)agentInsertWithId:(NSString *)itemId {
    Agent *item = nil;
    item = [LocalAreaDataManager agentWithId:itemId];
    if(!item) {
        item = (Agent *)[LocalCoreDataManager insertNewObjectForEntityForName:AgentEntityName];
    }
    item.localID = itemId;
    return item;
}
+ (Agent *)agentWithDict:(NSDictionary *)dict{
    Agent *item = nil;
    NSString *localId = [Agent idWithDict:dict];
    item = [LocalAreaDataManager agentInsertWithId:localId];
    if(!item) {
        item = (Agent *)[LocalCoreDataManager insertNewObjectForEntityForName:AgentEntityName];
    }
    [item updateWithDict:dict];
    return item;
}
#pragma mark (代理商/机构/幼儿园集合)列表
+ (NSArray *)agentList {
    NSArray *items = nil;
    NSSortDescriptor *nameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"localID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:nameSortDescriptor, nil];
	NSPredicate *predicate = [NSPredicate predicateWithValue:NO];
    items = [LocalCoreDataManager objectsForEntity:AgentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
#pragma mark (获取培训机构)
+ (Agent *)agentAssociation {
    Agent *item = nil;
    NSSortDescriptor *nameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"localID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:nameSortDescriptor, nil];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", INSTITUTION];
    item = [[LocalCoreDataManager objectsForEntity:AgentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors] lastObject];
    return item;
}
#pragma mark (获取幼儿园)
+ (Agent *)agentGarden {
    Agent *item = nil;
    NSSortDescriptor *nameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"localID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:nameSortDescriptor, nil];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", KINDER];
    item = [[LocalCoreDataManager objectsForEntity:AgentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors] lastObject];
    return item;
}


#pragma mark - 区域模块
+ (void) deleWithSearchString:(NSString*) key
{
    NSArray* sonArray = [LocalAreaDataManager areaWithSearchString:key];
    if(sonArray)
    {
        [LocalCoreDataManager deleteObjects:sonArray];
        [LocalCoreDataManager saveData];
    }
}
#pragma mark 删除名字带特殊字符串学校
+ (void) delewithKeyString:(NSString*) key
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name like[cd] %@) and (type == %@)",[NSString stringWithFormat:@"*%@*", key], SCHOOL];
    NSArray* array = [LocalCoreDataManager objectsForEntity:LocalAreaEntityName matchingPredicate:predicate];
    if(array)
    {
        [LocalCoreDataManager deleteObjects:array];
        [LocalCoreDataManager saveData];
    }
}

#pragma mark 删除子节点
+ (void) delWithParentId:(NSString *) parentId
{
    NSArray* sonArray = [LocalAreaDataManager areaWithParentId:parentId];
    if(sonArray)
    {
        [LocalCoreDataManager deleteObjects:sonArray];
        [LocalCoreDataManager saveData];
    }
}

#pragma mark 按照父区域查询直接子区域
+ (NSArray *)areaWithParentId:(NSString *)parentId {
    NSArray *items = nil;

    NSSortDescriptor *idSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    [idSortDescriptor release];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent.local_id == %@", parentId];
    
    items = [LocalCoreDataManager objectsForEntity:LocalAreaEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    
    return items;
}
#pragma mark 收藏的幼儿园
+ (NSArray *)areaBookmark {
    NSArray *items = nil;
    
    NSSortDescriptor *idSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    [idSortDescriptor release];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookmark == 1"];
    items = [LocalCoreDataManager objectsForEntity:LocalAreaEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
#pragma mark 搜索幼儿园
+ (NSArray *)areaWithSearchString:(NSString *)query {
    NSArray *items = nil;
    NSSortDescriptor *nameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:nameSortDescriptor, nil];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name like[cd] %@) and type == %@", [NSString stringWithFormat:@"*%@*", query], SCHOOL];
    items = [LocalCoreDataManager objectsForEntity:LocalAreaEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
   // items = [LocalCoreDataManager objectsForEntity:LocalAreaEntityName matchingPredicate:predicate];
    
    return items;
}
#pragma mark 初始化根节点
+ (LocalArea *)staticTopLocal {
    NSString *topParentId = TopParentId;
    topParentId = (topParentId.length > 0?topParentId:@"0");
    LocalArea *item = [LocalAreaDataManager areaInsertWithId:topParentId];
    item.type = LOCAL;
    item.name = TOPLOCAL_NAME;
    [LocalCoreDataManager saveData];
    return item;
}
#pragma mark 查找区域
+ (LocalArea *)areaWithId:(NSString *)localId {
    LocalArea *item = nil;
    NSSortDescriptor *idSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    [idSortDescriptor release];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"local_id == %@", localId];
    item = [[LocalCoreDataManager objectsForEntity:LocalAreaEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors] lastObject];

    return item;
}
#pragma mark 插入区域
+ (LocalArea *)areaInsertWithId:(NSString *)localId {
    LocalArea *item = nil;
    item = [LocalAreaDataManager areaWithId:localId];
    if(!item) {
        item = (LocalArea *)[LocalCoreDataManager insertNewObjectForEntityForName:LocalAreaEntityName];
    }
    item.local_id = localId;
    return item;
}
#pragma mark 解析协议添加区域
+ (LocalArea *)areaWithDict:(NSDictionary *)dict parentId:(NSString *)parentId {
    LocalArea *item = nil;
    NSString *localId = [LocalArea idWithDict:dict];
    item = [LocalAreaDataManager areaWithId:localId];
    if(!item) {
        item = (LocalArea *)[LocalCoreDataManager insertNewObjectForEntityForName:LocalAreaEntityName];
    }
    [item updateWithDict:dict parentId:parentId];
    return item;
}
#pragma mark - 文件模块
// 插入文件
+ (LocalAreaFile *)fileWithUrl:(NSString *)url isLocal:(Boolean)isLocal {
    LocalAreaFile *file = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path == %@", url];
    file = [[LocalCoreDataManager objectsForEntity:LocalAreaFileEntityName matchingPredicate:predicate] lastObject];
    if (!file) {
        file = [LocalCoreDataManager insertNewObjectForEntityForName:LocalAreaFileEntityName];
    }
    [file updateWithImageUrl:url isLocal:isLocal];
    return file;
}
+ (void)clearDataBae {
    if([LocalAreaDataManager agentAssociation]) {
        [LocalCoreDataManager deleteObject:[LocalAreaDataManager agentAssociation]];
    }
    if([LocalAreaDataManager agentGarden]) {
        [LocalCoreDataManager deleteObject:[LocalAreaDataManager agentGarden]];
    }
    [LocalCoreDataManager saveData];
}
@end
