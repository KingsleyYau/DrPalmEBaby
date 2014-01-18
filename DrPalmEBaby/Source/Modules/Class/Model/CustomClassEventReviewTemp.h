//
//  ClassEventReviewTemp.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassEventReviewTemp.h"

#define ReviewTypeText      @"text"
#define ReviewTypeCount     @"count"

@interface ClassEventReviewTemp (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
