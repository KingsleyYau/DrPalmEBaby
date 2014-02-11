//
//  ClassEventDraft.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-17.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassEventCategory, ClassEventDraftAttachment, ClassOrg;

@interface ClassEventDraft : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * ifshow;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * locationUrl;
@property (nonatomic, retain) NSString * orieventid;
@property (nonatomic, retain) NSString * oristatus;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSSet *addressees;
@property (nonatomic, retain) NSSet *attachments;
@property (nonatomic, retain) NSSet *categories;
@end

@interface ClassEventDraft (CoreDataGeneratedAccessors)

- (void)addAddresseesObject:(ClassOrg *)value;
- (void)removeAddresseesObject:(ClassOrg *)value;
- (void)addAddressees:(NSSet *)values;
- (void)removeAddressees:(NSSet *)values;

- (void)addAttachmentsObject:(ClassEventDraftAttachment *)value;
- (void)removeAttachmentsObject:(ClassEventDraftAttachment *)value;
- (void)addAttachments:(NSSet *)values;
- (void)removeAttachments:(NSSet *)values;

- (void)addCategoriesObject:(ClassEventCategory *)value;
- (void)removeCategoriesObject:(ClassEventCategory *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

@end
