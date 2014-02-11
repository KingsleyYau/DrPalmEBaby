//
//  PrivateAlbumLastupdate.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-13.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PrivateAlbumLastupdate : NSManagedObject

@property (nonatomic, retain) NSDate * lastupdate;
@property (nonatomic, retain) NSString * user;

@end
