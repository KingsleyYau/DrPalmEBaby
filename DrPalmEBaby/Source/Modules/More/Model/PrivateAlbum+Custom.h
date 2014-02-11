//
//  PrivateAlbum+Custom.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-13.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "PrivateAlbum.h"

@interface PrivateAlbum (Custom)

+(NSString*)idWithDict:(NSDictionary*)dict;
-(void)updateWithDict:(NSDictionary*)dict;

@end
