//
//  ClassEventCategory.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-16.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassEvent, ClassEventDraft, ClassEventSent, ClassFile;

@interface ClassEventCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * bSend;
@property (nonatomic, retain) NSNumber * bShow;
@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSNumber * expectedCount;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSDate * lastUpdateChannel;
@property (nonatomic, retain) NSDate * lastUpdateChannelList;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSString * modulesname;
@property (nonatomic, retain) NSNumber * picture;
@property (nonatomic, retain) NSNumber * showinlatestlist;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleofLastEvent;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * unreadcount;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *eventsSent;
@property (nonatomic, retain) ClassFile *logoImage;
@property (nonatomic, retain) ClassEventDraft *drafts;
@end

@interface ClassEventCategory (CoreDataGeneratedAccessors)

- (void)addEventsObject:(ClassEvent *)value;
- (void)removeEventsObject:(ClassEvent *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addEventsSentObject:(ClassEventSent *)value;
- (void)removeEventsSentObject:(ClassEventSent *)value;
- (void)addEventsSent:(NSSet *)values;
- (void)removeEventsSent:(NSSet *)values;

@end
