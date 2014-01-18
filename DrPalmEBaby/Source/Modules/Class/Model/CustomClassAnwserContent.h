//
//  CustomClassAnwserContent.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassAnwserContent.h"
@interface ClassAnwserContent (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDictEventId:(NSDictionary *)dict anwserMan_id:(NSString*)anwserMan_id event_id:(NSString *)event_id;
- (void)updateWithDictEventSentId:(NSDictionary *)dict anwserMan_id:(NSString*)anwserMan_id event_id:(NSString *)event_id;
@end
