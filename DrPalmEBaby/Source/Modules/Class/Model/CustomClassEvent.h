//
//  CustomClassEvent.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "ClassEvent.h"

#define FavourUnBookmark    @"C"
#define FavourBookmark      @"N"

@interface ClassEvent (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict;
+ (double)lastupdateWithDict:(NSDictionary*)dict;
+ (double)lastreadWithDict:(NSDictionary*)dict;
- (void)updateWithDict:(NSDictionary *)dict;
- (void)updateFavourWithDict:(NSDictionary *)dict;

- (void)setUpEKEvent:(EKEvent *)ekEvent;
- (NSString *)dateStringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle separator:(NSString *)separator ;

@end
