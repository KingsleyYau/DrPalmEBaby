//
//  SystemMessageDataManager.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "CustomSystemMessage.h"

@interface SystemMessageDataManager : NSObject
// 获取系统消息列表
+ (NSArray *)messageList;
// 添加一条系统消息
+ (SystemMessage *)messageWithId:(NSString *)msgId;
+ (SystemMessage *)messageWithDict:(NSDictionary *)dict;
@end
