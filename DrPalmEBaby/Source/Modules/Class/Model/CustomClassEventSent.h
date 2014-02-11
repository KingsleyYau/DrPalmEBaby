//
//  CustomClassEventSent.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "ClassEventSent.h"

@interface ClassEventSent (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
- (void)setUpEKEvent:(EKEvent *)ekEvent;
- (NSString *)dateStringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle separator:(NSString *)separator;
@end
