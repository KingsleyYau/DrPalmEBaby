//
//  CustomLocalArea.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalArea.h"
#define SCHOOL @"school"
#define LOCAL @"local"
#define TOPLOCAL_NAME @"TopLocalName"//@"中小学联盟"
@interface LocalArea (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict parentId:(NSString *)parentId;
@end
