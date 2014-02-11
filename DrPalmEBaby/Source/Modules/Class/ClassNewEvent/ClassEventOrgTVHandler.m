//
//  ClassEventOrgTVHandler.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-6.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassEventOrgTVHandler.h"
#import "ClassDataManager.h"
#pragma mark - 合并的数据定义
@implementation ClassEventOrgTVCombineItem
@synthesize orgId = _orgId;
@synthesize orgParentId = _orgParentId;
- (id)init
{
    if (self = [super init]) {
        self.orgId = nil;
        self.orgParentId = nil;
    }
    return self;
}

- (void)dealloc
{
    self.orgId = nil;
    self.orgParentId = nil;
    [super dealloc];
}
@end
@implementation ClassEventOrgTVHandler
+ (void)combineSubOrg:(NSMutableArray*)srcCheckedOrgs desCheckedOrgs:(NSMutableArray*)desCheckedOrgs
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // 把已选节点转换为合并数据
    NSMutableArray* combineItems = [NSMutableArray array];
    for (ClassOrg* org in srcCheckedOrgs) {
        [ClassEventOrgTVHandler addClassOrgToItemArray:combineItems org:org];
    }
    
    // 开始合并
    BOOL isContinue = NO;
    do {
        isContinue = NO;
        
        for (ClassEventOrgTVCombineItem* item in combineItems) {
            if ([ClassEventOrgTVHandler combineSubItem:item items:combineItems]) {
                isContinue = YES;
                break;
            }
        }
    } while (isContinue);
    
    // 排重
    [ClassEventOrgTVHandler removeRepetitiveCombineItem:combineItems desCheckedOrgs:desCheckedOrgs];
    
    // 建立desCheckedOrgArray
    //    [ClassEventOrgTVHandler createDesCheckedOrgsWithItems:combineItems desCheckedOrgs:desCheckedOrgs];
    
    [pool drain];
}

// 把ClassOrg节点添加到合并列表中
+ (void)addClassOrgToItemArray:(NSMutableArray*)itemArray org:(ClassOrg*)org
{
    for (ClassOrg* parent in org.orgParents) {
        ClassEventOrgTVCombineItem* item = [[[ClassEventOrgTVCombineItem alloc] init] autorelease];
        item.orgId = org.orgID;
        item.orgParentId = parent.orgID;
        [itemArray addObject:item];
    }
}

// 判断是否需要合并
+ (BOOL)isCombineSubItem:(ClassOrg*)parent items:(NSArray*)items
{
    BOOL result = NO;
    NSInteger suborgNumber = [parent.orgSubs count];
    NSInteger suborgCount = 0;
    for (ClassEventOrgTVCombineItem* item in items) {
        if ([item.orgParentId isEqualToString:parent.orgID]) {
            suborgCount++;
            
            if (suborgNumber == suborgCount) {
                result = YES;
                break;
            }
        }
    }
    return result;
}

// 合并item为org
+ (BOOL)combineSubItem:(ClassEventOrgTVCombineItem*)combineItem items:(NSMutableArray*)items
{
    BOOL isCombine = NO;
    
    ClassOrg* org = [ClassDataManager orgWithID:combineItem.orgId];
    
    for (ClassOrg* parent in org.orgParents) {
        if ([parent.orgID isEqualToString:OrgTopDefaultValue]) {
            continue;
        }
        
        // 判断是否需要合并
        if ([ClassEventOrgTVHandler isCombineSubItem:parent items:items]) {
            isCombine = YES;
            
            // 找出所有子item
            NSMutableArray* deleteArray = [NSMutableArray array];
            for (ClassEventOrgTVCombineItem* item in items) {
                if ([item.orgParentId isEqualToString:parent.orgID])
                {
                    [deleteArray addObject:item];
                }
            }
            
            // 删除所有子item
            [items removeObjectsInArray:deleteArray];
            
            // 把org添加到列表中
            [ClassEventOrgTVHandler addClassOrgToItemArray:items org:parent];
        }
    }
    return isCombine;
}

// 建立desCheckedOrgs
+ (void)createDesCheckedOrgsWithItems:(NSArray*)items desCheckedOrgs:(NSMutableArray*)desCheckedOrgs
{
    // 清空
    [desCheckedOrgs removeAllObjects];
    
    // 构建
    for (ClassEventOrgTVCombineItem* item in items) {
        ClassOrg* orgItem = [ClassDataManager orgWithID:item.orgId];
        [desCheckedOrgs addObject:orgItem];
    }
}

// 排重
+ (void)removeRepetitiveCombineItem:(NSMutableArray*)items desCheckedOrgs:(NSMutableArray*)orgs
{
    // 清空
    [orgs removeAllObjects];
    
    // 把选项都从数据库中查出
    for (ClassEventOrgTVCombineItem* item in items) {
        ClassOrg* org = [ClassDataManager orgWithID:item.orgId];
        
        // 排重
        if (![orgs containsObject:org]) {
            [orgs addObject:org];
        }
    }
    
    // 排除没用的子
    for (NSInteger index = 0; index < [orgs count]; index++) {
        ClassOrg* orgItem = [orgs objectAtIndex:index];
        for (NSInteger compIndex = index + 1; compIndex < [orgs count]; compIndex++)
        {
            ClassOrg* orgCompItem = [orgs objectAtIndex:compIndex];
            if ([orgCompItem isProgenitorNode:orgItem]) {
                [orgs removeObject:orgItem];
                index--; // 回到原点
                break;
            }
            else if ([orgItem isProgenitorNode:orgCompItem]) {
                [orgs removeObject:orgCompItem];
                compIndex--; // 回到原点
                continue;
            }
        }
    }
}

+ (void)addToArray:(NSMutableArray*)array eventOrg:(ClassOrg*)eventOrg
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if ([eventOrg.orgSubs count] == 0) {
        // 叶子节点
        [array addObject:eventOrg];
    }
    else {
        NSArray* leafOrgs = [ClassDataManager getLeafOrgWithOrg:eventOrg];
        for (ClassOrg* leafOrg in leafOrgs) {
            if (![array containsObject:leafOrg]) {
                [array addObject:leafOrg];
            }
        }
    }
    
    [pool drain];
}

+ (void)removeToArray:(NSMutableArray*)array eventOrg:(ClassOrg*)eventOrg
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if ([eventOrg.orgSubs count] == 0) {
        // 叶子节点
        [array removeObject:eventOrg];
    }
    else {
        NSArray* leafOrgs = [ClassDataManager getLeafOrgWithOrg:eventOrg];
        for (ClassOrg* leafOrg in leafOrgs) {
            if ([array containsObject:leafOrg]) {
                [array removeObject:leafOrg];
            }
        }
    }
    
    [pool drain];
}
+ (BOOL)isAllOrgChecked:(NSArray *)array checkedArray:(NSArray *)checkArray{
    BOOL bFlag = YES;
    for(ClassOrg *eventOrg in array) {
        if(Checked != [ClassEventOrgTVHandler cellStatusWithEventOrg:checkArray eventOrg:eventOrg]) {
            bFlag = NO;
            break;
        }
    }
    return bFlag;
}
+ (OrgCellStatus)cellStatusWithEventOrg:(NSArray*)array eventOrg:(ClassOrg*)eventOrg
{
    OrgCellStatus status = NoChecked;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSInteger eventOrgLeafNodeCount = [eventOrg.orgLeafCount integerValue];
    NSInteger leafNodeCount = 0;
    for (NSInteger index = 0; index < [array count]; index++) {
        ClassOrg* org = [array objectAtIndex:index];
        
        // 判断是否相等，相等即选中
        if ([eventOrg.orgID isEqualToString:org.orgID]) {
            status = Checked;
            break;
        }
        
        if (eventOrgLeafNodeCount > 0) {
            // 判断指定节点(eventOrg)是否选中节点的父层节点
            if ([eventOrg isProgenitorNode:org]) {
                leafNodeCount++;
                
                // 全部叶子节点都选中
                if (eventOrgLeafNodeCount == leafNodeCount) {
                    status = Checked;
                    break;
                }
            }
            
            // 已选节点数 > 0
            // 已选节点数 + 剩下已选节点数 < 指定组织的叶子节点数
            if (leafNodeCount > 0
                && leafNodeCount + ([array count] - (index + 1)) < eventOrgLeafNodeCount)
            {
                status = SubsChecked;
                break;
            }
        }
    }
    
    [pool drain];
    
    return status;
}

@end
