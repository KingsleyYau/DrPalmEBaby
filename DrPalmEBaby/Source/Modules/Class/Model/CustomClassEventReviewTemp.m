//
//  CustomClassEventReviewTemp.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomClassEventReviewTemp.h"
#import "ClassDataManager.h"
@implementation ClassEventReviewTemp (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict {
    NSString *itemID = nil;
    // id
    id foundValue = [dict objectForKey:@"id"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSString class]]) {
        itemID = foundValue;
    }
    return itemID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    // 名称
    foundValue = [dict objectForKey:@"title"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSString class]]) {
        self.name = foundValue;
    }
    // 类型
    foundValue = [dict objectForKey:@"type"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSString class]]) {
        self.type = foundValue;
    }
    // 默认
    foundValue = [dict objectForKey:@"default"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSNumber class]]) {
        self.iDefault = foundValue;
    }
    // 最大
    foundValue = [dict objectForKey:@"max"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSNumber class]]) {
        self.iMax = foundValue;
    }
    // 必要
    foundValue = [dict objectForKey:@"required"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSNumber class]]) {
        self.bRequired = foundValue;
    }
}
@end
