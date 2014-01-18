//
//  CustomLatestItem.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-25.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomLatestItem.h"
#import "LoginManager.h"

@implementation LatestItem (Custom)
+ (NSString *)idWithNewsDict:(NSDictionary *)dict
{
    return [dict objectForKey:@"storyid"];
}
+ (NSString *)idWithEventDict:(NSDictionary *)dict
{
    return [dict objectForKey:@"eventid"];
}
- (void)updateWithNewsDict:(NSDictionary *)dict
{
    //id
    self.item_id = [LatestItem idWithNewsDict:dict];
    
    //type
    self.categoryType = SCHOOL_NEWS;
    
    //categoryid
    id foundValue = [dict objectForKey:@"channel"];
    if(foundValue!=nil && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        self.category_id = foundValue;
    }
    
    //lastupdate
    foundValue = [dict objectForKey:@"lastupdate"];
    if(foundValue!=nil && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
    {
        double time = [foundValue doubleValue];
        self.lastUpdate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    self.lastLocalUpdate = [NSDate date];
    
    //title
    foundValue = [dict objectForKey:@"title"];
    if(foundValue != nil && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.title = foundValue;
    
}
- (void)updateWithEventDict:(NSDictionary *)dict
{
    //id
    self.item_id = [LatestItem idWithEventDict:dict];
    
    //type
    self.categoryType = CLASS_EVENT;
    
    //categoryid
    id foundValue = [dict objectForKey:@"type"];
    if(foundValue!=nil && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        self.category_id = foundValue;
    }
    
    //lastupdate
    foundValue = [dict objectForKey:@"lastupdate"];
    if(foundValue!=nil && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
    {
        double time = [foundValue doubleValue];
        self.lastUpdate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //title
    foundValue = [dict objectForKey:@"title"];
    if(foundValue != nil && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.title = foundValue;

    self.lastLocalUpdate = [NSDate date];
    
    //user
    self.user = LoginManagerInstance().accountName;
}
@end
