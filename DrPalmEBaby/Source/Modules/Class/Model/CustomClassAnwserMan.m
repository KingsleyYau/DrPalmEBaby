//
//  CustomClassAnwserMan.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomClassAnwserMan.h"
#import "ClassDataManager.h"
@implementation ClassAnwserMan (Custom)
- (void)updateWithDict:(NSDictionary *)dict
{
    //反馈人id
    id foundValue = [dict objectForKey:@"aswpubid"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
        self.anwserMan_id = foundValue;
    
    //反馈人名称
    foundValue = [dict objectForKey:@"awspubname"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
        self.awsermanName = foundValue;
    
    //lastawstime
    foundValue = [dict objectForKey:@"lastawstime"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSNumber class]])
    {
        double time = [foundValue doubleValue];
        self.lastawsTime = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //反馈数量
    foundValue = [dict objectForKey:@"awscount"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSNumber class]])
    {
        NSInteger count = [foundValue integerValue];
        self.awscount = [NSNumber numberWithInteger:count];
        //self.hasNewAnwser = [NSNumber numberWithBool:count>0?YES:NO];
    }
    
    // 讨论组成员
    foundValue = [dict objectForKey:@"memberlist"];
    if(nil != foundValue && nil != [NSNull null] && [foundValue isKindOfClass:[NSArray class]]) {
        for(NSDictionary *dict in foundValue) {
            ClassAnwserSender *item = [ClassDataManager anwserSenderWithDict:dict];
            [self addAnwserSenderObject:item];
        }
    }
}
@end
