//
//  GrowDiary+Custom.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-4.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "GrowDiary.h"

@interface GrowDiary (Custom)
+(NSString*)idWithDict:(NSDictionary*)dict;
-(void)updateWithDict:(NSDictionary*)dict;
@end
