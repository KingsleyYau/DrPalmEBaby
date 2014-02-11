//
//  HeadImage.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-8-29.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfo;

@interface HeadImage : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *userinfohead;
@end

@interface HeadImage (CoreDataGeneratedAccessors)

- (void)addUserinfoheadObject:(UserInfo *)value;
- (void)removeUserinfoheadObject:(UserInfo *)value;
- (void)addUserinfohead:(NSSet *)values;
- (void)removeUserinfohead:(NSSet *)values;
@end
