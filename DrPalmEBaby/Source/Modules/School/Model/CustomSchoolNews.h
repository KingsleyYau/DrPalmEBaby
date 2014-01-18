//
//  CustomSchoolNews.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolNews.h"
@interface SchoolNews (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict;
+ (BOOL)isDeleteNews:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
