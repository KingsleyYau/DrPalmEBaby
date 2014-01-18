//
//  SchoolImage.h
//  DrPalm
//
//  Created by KingsleyYau on 13-5-13.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SchoolFile, SchoolNews;

@interface SchoolImage : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) SchoolFile *fullImage;
@property (nonatomic, retain) NSSet *mainImageParent;
@property (nonatomic, retain) NSSet *newsMain;
@property (nonatomic, retain) NSSet *newsSub;
@property (nonatomic, retain) SchoolFile *smallImage;
@property (nonatomic, retain) NSSet *subImageParent;
@property (nonatomic, retain) SchoolFile *thumbImage;
@end

@interface SchoolImage (CoreDataGeneratedAccessors)

- (void)addMainImageParentObject:(SchoolNews *)value;
- (void)removeMainImageParentObject:(SchoolNews *)value;
- (void)addMainImageParent:(NSSet *)values;
- (void)removeMainImageParent:(NSSet *)values;
- (void)addNewsMainObject:(SchoolNews *)value;
- (void)removeNewsMainObject:(SchoolNews *)value;
- (void)addNewsMain:(NSSet *)values;
- (void)removeNewsMain:(NSSet *)values;
- (void)addNewsSubObject:(SchoolNews *)value;
- (void)removeNewsSubObject:(SchoolNews *)value;
- (void)addNewsSub:(NSSet *)values;
- (void)removeNewsSub:(NSSet *)values;
- (void)addSubImageParentObject:(SchoolNews *)value;
- (void)removeSubImageParentObject:(SchoolNews *)value;
- (void)addSubImageParent:(NSSet *)values;
- (void)removeSubImageParent:(NSSet *)values;
@end
