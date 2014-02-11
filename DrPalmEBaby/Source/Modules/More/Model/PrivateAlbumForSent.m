//
//  PrivateAlbumForSent.m
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-17.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "PrivateAlbumForSent.h"


@implementation PrivateAlbumForSent

@synthesize imageId = _imageId;
@synthesize desc = _desc;
@synthesize status = _status;
@synthesize data = _data;

-(id)init{
    self = [super init];
    if(self)
    {
        self.imageId = @"";
        self.desc = @"";
        self.status = @"";
        self.data = nil;
    }
    return self;
}

@end
