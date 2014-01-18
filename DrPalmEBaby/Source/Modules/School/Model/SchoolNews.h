//
//  SchoolNews.h
//  DrPalm
//
//  Created by drcom on 13-5-20.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SchoolImage, SchoolNewsCategory;

@interface SchoolNews : NSManagedObject

@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * bookmarked;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSDate * postdate;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * story_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * shareurl;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) SchoolImage *mainImage;
@property (nonatomic, retain) NSSet *subImage;
@end

@interface SchoolNews (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(SchoolNewsCategory *)value;
- (void)removeCategoriesObject:(SchoolNewsCategory *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;
- (void)addSubImageObject:(SchoolImage *)value;
- (void)removeSubImageObject:(SchoolImage *)value;
- (void)addSubImage:(NSSet *)values;
- (void)removeSubImage:(NSSet *)values;
@end
