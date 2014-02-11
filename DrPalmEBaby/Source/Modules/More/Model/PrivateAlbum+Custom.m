//
//  PrivateAlbum+Custom.m
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-13.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "PrivateAlbum+Custom.h"
#import "UserInfoManager.h"

@implementation PrivateAlbum (Custom)

+(NSString*)idWithDict:(NSDictionary*)dict
{
   return [dict objectForKey:@"imgid"];
}

-(void)updateWithDict:(NSDictionary*)dict
{
    //id
    self.imageid = [PrivateAlbum idWithDict:dict];
    
    //desc
    id value = [dict objectForKey:@"des"];
    if(value != nil && value != [NSNull null] && [value isKindOfClass:[NSString class]])
    {
        self.des = value;
    }
    
    //status
    value = [dict objectForKey:@"status"];
    if(value != nil && value != [NSNull null] && [value isKindOfClass:[NSString class]])
    {
        self.status = value;
    }
    
    value = [dict objectForKey:@"imgurl"];
    if(value != nil && value != [NSNull null] && [value isKindOfClass:[NSString class]])
    {
        HeadImage* img = [UserInfoManager headImageWithUrl:value];
        //self.image = [UserInfoManager headImageWithUrl:value];
        self.image = img;
    }
}

@end
