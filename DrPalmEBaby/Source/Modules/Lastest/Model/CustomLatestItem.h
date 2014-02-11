//
//  CustomLatestItem.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-25.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#define SCHOOL_NEWS     @"schoolnews"
#define CLASS_EVENT     @"classevent"




#import <Foundation/Foundation.h>
#import "LatestItem.h"
@interface LatestItem (Custom)
+ (NSString *)idWithNewsDict:(NSDictionary *)dict;
+ (NSString *)idWithEventDict:(NSDictionary *)dict;
- (void)updateWithNewsDict:(NSDictionary *)dict;
- (void)updateWithEventDict:(NSDictionary *)dict;
@end
