//
//  CustomSystemMessage.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomSystemMessage.h"

@implementation SystemMessage (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict
{
    return [dict objectForKey:@"sysmsgid"];
}
- (void)updateWithDict:(NSDictionary *)dict
{
    //sysid
    self.system_id = [SystemMessage idWithDict:dict];
    
    //title
    id foundValue = [dict objectForKey:@"title"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
        self.title = foundValue;
    
    //lastupdate
    foundValue = [dict objectForKey:@"lastupdate"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSNumber class]])
    {
        double time = [foundValue doubleValue];
        self.lastUpdate = [NSDate dateWithTimeIntervalSince1970:time];

    }
    
    //inactivetime
    foundValue = [dict objectForKey:@"inactivetime"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSNumber class]])
    {
        double time = [foundValue doubleValue];
        self.inactivetime = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //body
    foundValue = [dict objectForKey:@"body"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
        self.body = foundValue;
    
    // 摘要
    foundValue = [dict objectForKey:@"summary"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]]) {
        self.summary = foundValue;
    }
}
@end
