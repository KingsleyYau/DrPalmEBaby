//
//  CustomLocalArea.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomLocalArea.h"
#import "LocalAreaDefine.h"
#import "LocalAreaDataManager.h"

@implementation LocalArea (Custom)


+ (NSString *)idWithDict:(NSDictionary *)dict
{
    NSString *value = @"";
    id foundValue = [dict objectForKey:Local_Id];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        value = [dict objectForKey:Local_Id];
    }
    return value;
}

- (void)updateWithDict:(NSDictionary *)dict parentId:(NSString *)parentId {
    // id
    self.local_id = [LocalArea idWithDict:dict];
    
    // name
    id foundValue = [dict objectForKey:LocalArea_Name];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.name = foundValue;
    
    // type
    foundValue = [dict objectForKey:LocalArea_Type];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.type = foundValue;
    
    // key
    foundValue = [dict objectForKey:LocalArea_key];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.schoolKey = foundValue;
    
    // titleurl
    foundValue = [dict objectForKey:LocalArea_TitleUrl];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        self.logo = [LocalAreaDataManager fileWithUrl:foundValue isLocal:NO];
        //self.logo.path = foundValue;
    }

    // 父节点
    foundValue = [dict objectForKey:LocalArea_ParentId];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        self.parent = [LocalAreaDataManager areaInsertWithId:foundValue];
        [self.parent addSubsObject:self];
    }
}

@end
