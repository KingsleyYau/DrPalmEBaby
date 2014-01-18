//
//  UserInfo.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-4.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HeadImage;

@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * curscore;
@property (nonatomic, retain) NSDate * headlastupdate;
@property (nonatomic, retain) NSNumber * isautologin;
@property (nonatomic, retain) NSNumber * ispush;
@property (nonatomic, retain) NSNumber * isrememberme;
@property (nonatomic, retain) NSNumber * isshake;
@property (nonatomic, retain) NSNumber * issound;
@property (nonatomic, retain) NSDate * lastlogintime;
@property (nonatomic, retain) NSDate * lastupdate;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * levelupscore;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * pushend;
@property (nonatomic, retain) NSString * pushstart;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * usertype;
@property (nonatomic, retain) NSDate * serviceenddate;
@property (nonatomic, retain) HeadImage *headimage;

@end
