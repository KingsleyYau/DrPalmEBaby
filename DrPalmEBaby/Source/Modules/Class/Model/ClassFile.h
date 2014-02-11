//
//  ClassFile.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-16.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassAnwserSender, ClassEvent, ClassEventCategory, ClassEventSent, ClassImage;

@interface ClassFile : NSManagedObject

@property (nonatomic, retain) NSString * attid;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * contenttype;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * fileext;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * pathtype;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *classCategory;
@property (nonatomic, retain) NSSet *eventParent;
@property (nonatomic, retain) NSSet *eventSentParent;
@property (nonatomic, retain) NSSet *fullParent;
@property (nonatomic, retain) NSSet *senderImage;
@property (nonatomic, retain) NSSet *smallParent;
@property (nonatomic, retain) NSSet *thumbParent;
@end

@interface ClassFile (CoreDataGeneratedAccessors)

- (void)addClassCategoryObject:(ClassEventCategory *)value;
- (void)removeClassCategoryObject:(ClassEventCategory *)value;
- (void)addClassCategory:(NSSet *)values;
- (void)removeClassCategory:(NSSet *)values;

- (void)addEventParentObject:(ClassEvent *)value;
- (void)removeEventParentObject:(ClassEvent *)value;
- (void)addEventParent:(NSSet *)values;
- (void)removeEventParent:(NSSet *)values;

- (void)addEventSentParentObject:(ClassEventSent *)value;
- (void)removeEventSentParentObject:(ClassEventSent *)value;
- (void)addEventSentParent:(NSSet *)values;
- (void)removeEventSentParent:(NSSet *)values;

- (void)addFullParentObject:(ClassImage *)value;
- (void)removeFullParentObject:(ClassImage *)value;
- (void)addFullParent:(NSSet *)values;
- (void)removeFullParent:(NSSet *)values;

- (void)addSenderImageObject:(ClassAnwserSender *)value;
- (void)removeSenderImageObject:(ClassAnwserSender *)value;
- (void)addSenderImage:(NSSet *)values;
- (void)removeSenderImage:(NSSet *)values;

- (void)addSmallParentObject:(ClassImage *)value;
- (void)removeSmallParentObject:(ClassImage *)value;
- (void)addSmallParent:(NSSet *)values;
- (void)removeSmallParent:(NSSet *)values;

- (void)addThumbParentObject:(ClassImage *)value;
- (void)removeThumbParentObject:(ClassImage *)value;
- (void)addThumbParent:(NSSet *)values;
- (void)removeThumbParent:(NSSet *)values;

@end
