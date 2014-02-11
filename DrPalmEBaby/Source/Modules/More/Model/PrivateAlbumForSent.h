//
//  PrivateAlbumForSent.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-17.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  PrivateAlbumForSent: NSObject
{
    NSString* _imageId;
    NSString* _desc;
    NSString* _status;
    NSData* _data;
}

@property (nonatomic, retain) NSString*  imageId;
@property (nonatomic, retain) NSString*  desc;
@property (nonatomic, retain) NSString*  status;
@property (nonatomic, retain) NSData*    data;

@end
