//
//  AgentCustom.h
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-8-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Agent.h"

#define INSTITUTION     @"institution"
#define KINDER          @"kinder"

@interface Agent(Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
