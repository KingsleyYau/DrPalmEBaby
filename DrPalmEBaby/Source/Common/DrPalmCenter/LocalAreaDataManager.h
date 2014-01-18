//
//  DrPalmCenterDataManager.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalCoreDataManager.h"

#import "AgentCustom.h"
#import "CustomLocalArea.h"
#import "CustomLocalAreaFile.h"

#define DRCOM_TEST_KEY @"DR_COM"

@interface LocalAreaDataManager : NSObject

#pragma mark - (代理商/机构/幼儿园集合)模块
#define TopAgentId [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TopAgentId"]
#pragma mark 查找(代理商/机构/幼儿园集合)
+ (Agent *)agentWithId:(NSString *)itemId;
#pragma mark 添加(代理商/机构/幼儿园集合)
+ (Agent *)agentInsertWithId:(NSString *)itemId;
+ (Agent *)agentWithDict:(NSDictionary *)dict;
#pragma mark (代理商/机构/幼儿园集合)列表
+ (NSArray *)agentList;
#pragma mark (获取培训机构)
+ (Agent *)agentAssociation;
#pragma mark (获取幼儿园)
+ (Agent *)agentGarden;

#pragma mark - 区域模块
#define TopParentId [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TopAreaId"]
#pragma mark 删除关键字节点
+ (void) deleWithSearchString:(NSString*) key;
#pragma mark 删除名字带特殊字符串学校
+ (void) delewithKeyString:(NSString*) key;
#pragma mark 删除自身节点及子节点
+ (void) delWithParentId:(NSString *) parentId;
#pragma mark 按照父区域查询直接子区域
+ (NSArray *)areaWithParentId:(NSString *)parentId;
#pragma mark 收藏的幼儿园
+ (NSArray *)areaBookmark;
#pragma mark 搜索幼儿园
+ (NSArray *)areaWithSearchString:(NSString *)query;
#pragma mark 初始化根节点
+ (LocalArea *)staticTopLocal;
#pragma mark 查找区域
+ (LocalArea *)areaWithId:(NSString *)localId;
#pragma mark 添加区域
+ (LocalArea *)areaInsertWithId:(NSString *)localId;
+ (LocalArea *)areaWithDict:(NSDictionary *)dict parentId:(NSString *)parentId;

#pragma mark - 文件模块
#pragma mark 插入文件
+ (LocalAreaFile *)fileWithUrl:(NSString *)url isLocal:(Boolean)isLocal;
+ (void)clearDataBae;
@end
