//
//  ClassEventSent.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-16.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassAnwserMan, ClassEventCategory, ClassFile, ClassImage;

@interface ClassEventSent : NSManagedObject

@property (nonatomic, retain) NSNumber * attasize;
@property (nonatomic, retain) NSNumber * awscount;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * cancelDate;
@property (nonatomic, retain) NSString * cleanbody;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * event_id;
@property (nonatomic, retain) NSNumber * hasAtt;
@property (nonatomic, retain) NSNumber * hasLastAws;
@property (nonatomic, retain) NSNumber * ifshow;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSDate * lastAwsTime;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * locationUrl;
@property (nonatomic, retain) NSString * orieventid;
@property (nonatomic, retain) NSString * oristatus;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSString * ownerid;
@property (nonatomic, retain) NSDate * postDate;
@property (nonatomic, retain) NSString * pub_id;
@property (nonatomic, retain) NSString * pubName;
@property (nonatomic, retain) NSNumber * readCount;
@property (nonatomic, retain) NSString * reader;
@property (nonatomic, retain) NSNumber * readTotal;
@property (nonatomic, retain) NSString * rtspurl;
@property (nonatomic, retain) NSDate * sortField;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unreader;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSSet *anwserMans;
@property (nonatomic, retain) NSSet *attachments;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) ClassImage *mainImage;
@end

@interface ClassEventSent (CoreDataGeneratedAccessors)

- (void)addAnwserMansObject:(ClassAnwserMan *)value;
- (void)removeAnwserMansObject:(ClassAnwserMan *)value;
- (void)addAnwserMans:(NSSet *)values;
- (void)removeAnwserMans:(NSSet *)values;

- (void)addAttachmentsObject:(ClassFile *)value;
- (void)removeAttachmentsObject:(ClassFile *)value;
- (void)addAttachments:(NSSet *)values;
- (void)removeAttachments:(NSSet *)values;

- (void)addCategoriesObject:(ClassEventCategory *)value;
- (void)removeCategoriesObject:(ClassEventCategory *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

@end
