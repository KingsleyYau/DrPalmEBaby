//
//  AgentCustom.m
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-8-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "AgentCustom.h"
#import "LocalAreaDefine.h"

@implementation Agent(Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict {
    NSString *value = @"";
    id foundValue = [dict objectForKey:Local_Id];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        value = [dict objectForKey:Local_Id];
    }
    return value;
}

- (void)updateWithDict:(NSDictionary *)dict {    
    //name
    id foundValue = [dict objectForKey:AppType];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.type = foundValue;
}
@end
