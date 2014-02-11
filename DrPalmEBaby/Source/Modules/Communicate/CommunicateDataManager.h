//
//  CommunicateDataManager.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "CustomCommunicateList.h"
#import "CustomCommunicateMan.h"
#import "CustomCommunicateFile.h"

@interface CommunicateDataManager : NSObject
// 按联系人获取对话列表
+ (NSArray *)contentListWithManId:(NSString *)manId;
+ (NSArray *)getCommunicateManList;
+ (void)delCommunicateManList;
// 添加一个联系人
+ (CommunicateMan *)manWithId:(NSString *)manId;
+ (CommunicateMan *)manWithDict:(NSDictionary *)dict;
// 按联系人添加一条内容
+ (CommunicateList *)contentWithId:(NSString *)msgId manId:(NSString *)manId;
+ (CommunicateList *)contentWithDict:(NSDictionary *)dict manId:(NSString *)manId;

#pragma mark - 文件与图片模块 (ClassFile/ClassImage)
#pragma mark 插入文件
+ (CommunicateFile *)fileWithUrl:(NSString *)url isLocal:(Boolean)isLocal;
@end
