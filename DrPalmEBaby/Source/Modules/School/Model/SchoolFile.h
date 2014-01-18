//
//  SchoolFile.h
//  DrPalm
//
//  Created by KingsleyYau on 13-5-13.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SchoolImage, SchoolNewsCategory;

@interface SchoolFile : NSManagedObject

@property (nonatomic, retain) NSString * contenttype;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * fileext;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * pathtype;
@property (nonatomic, retain) NSSet *fullParent;
@property (nonatomic, retain) NSSet *smallParent;
@property (nonatomic, retain) NSSet *thumParent;
@property (nonatomic, retain) SchoolNewsCategory *newsCategoryLogo;
@end

@interface SchoolFile (CoreDataGeneratedAccessors)

- (void)addFullParentObject:(SchoolImage *)value;
- (void)removeFullParentObject:(SchoolImage *)value;
- (void)addFullParent:(NSSet *)values;
- (void)removeFullParent:(NSSet *)values;
- (void)addSmallParentObject:(SchoolImage *)value;
- (void)removeSmallParentObject:(SchoolImage *)value;
- (void)addSmallParent:(NSSet *)values;
- (void)removeSmallParent:(NSSet *)values;
- (void)addThumParentObject:(SchoolImage *)value;
- (void)removeThumParentObject:(SchoolImage *)value;
- (void)addThumParent:(NSSet *)values;
- (void)removeThumParent:(NSSet *)values;
@end
