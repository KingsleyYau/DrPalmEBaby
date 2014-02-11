//
//  SchoolNewsCategory.h
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-7-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SchoolFile, SchoolNews;

@interface SchoolNewsCategory : NSManagedObject

@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSNumber * expectedCount;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSDate * lastUpdateChannel;
@property (nonatomic, retain) NSDate * lastUpdateChannelList;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSNumber * picture;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleofLastNews;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * bShow;
@property (nonatomic, retain) NSString * modulesname;
@property (nonatomic, retain) SchoolFile *logoImage;
@property (nonatomic, retain) NSSet *news;
@end

@interface SchoolNewsCategory (CoreDataGeneratedAccessors)

- (void)addNewsObject:(SchoolNews *)value;
- (void)removeNewsObject:(SchoolNews *)value;
- (void)addNews:(NSSet *)values;
- (void)removeNews:(NSSet *)values;
@end
