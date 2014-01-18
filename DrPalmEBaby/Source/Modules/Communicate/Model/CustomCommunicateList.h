//
//  CustomCommunicateList.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicateList.h"
@interface CommunicateList (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict manId:(NSString *)manId;
@end
