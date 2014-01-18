//
//  GrowDiary+Custom.m
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-4.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "GrowDiary+Custom.h"

@implementation GrowDiary (Custom)
+(NSString*)idWithDict:(NSDictionary*)dict
{
    return [dict objectForKey:@"diaryid"];
}
-(void)updateWithDict:(NSDictionary*)dict
{
    self.diaryid = [GrowDiary idWithDict:dict];
    
    //title
    id value = [dict objectForKey:@"title"];
    if(value != nil && value != [NSNull null] && [value isKindOfClass:[NSString class]]){
        self.title = value;
    }
    
    //summary
    value = [dict objectForKey:@"summary"];
    if(value != nil && value != [NSNull null] && [value isKindOfClass:[NSString class]]){
        self.summary = value;
    }
    
    //status
    value = [dict objectForKey:@"status"];
    if(value != nil && value != [NSNull null] && [value isKindOfClass:[NSString class]]){
        self.status = value;
    }
    
    //content
    value = [dict objectForKey:@"contect"];
    if(value != nil && value != [NSNull null] && [value isKindOfClass:[NSString class]]){
        self.content = value;
    }
    
    //content
    value = [dict objectForKey:@"lastupdate"];
    if(value != nil && value != [NSNull null] && [value isKindOfClass:[NSNumber class]]){
        double time = [value doubleValue];
        self.lastupdate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    return;
}
@end
