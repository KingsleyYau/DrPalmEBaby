//
//  PrivateAlbum.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-13.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HeadImage;

@interface PrivateAlbum : NSManagedObject

@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSString * imageid;
@property (nonatomic, retain) NSString * des;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * lastupdate;
@property (nonatomic, retain) HeadImage *image;

@end
