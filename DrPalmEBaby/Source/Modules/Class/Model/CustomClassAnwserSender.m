//
//  CustomClassAnwserSender.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomClassAnwserSender.h"
#import "ClassDataManager.h"
@implementation ClassAnwserSender (Custom)
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
    foundValue = [dict objectForKey:@"name"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSString class]]) {
        self.senderName = foundValue;
    }
    
    
    // 头像最后更新时间
    foundValue = [dict objectForKey:@"headimglastupdate"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSNumber class]]) {
        double time = [foundValue doubleValue];
        if(!self.senderImageLastUpdate || [self.senderImageLastUpdate isEqualToDate:[self.senderImageLastUpdate earlierDate:[NSDate dateWithTimeIntervalSince1970:time]]]) {
            // 头像有更新
            self.senderImageLastUpdate = [NSDate dateWithTimeIntervalSince1970:time];
            
            // 头像
            foundValue = [dict objectForKey:@"headimgurl"];
            if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSString class]]) {
                ClassFile *file = [ClassDataManager fileWithUrl:foundValue isLocal:NO];
                file.data = nil;
                self.senderImage = file;
            }
        }
    }
}
@end
