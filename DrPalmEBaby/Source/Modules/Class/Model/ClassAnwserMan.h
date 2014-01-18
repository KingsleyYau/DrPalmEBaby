//
//  ClassAnwserMan.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-16.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassAnwserContent, ClassAnwserSender, ClassEvent, ClassEventSent;

@interface ClassAnwserMan : NSManagedObject

@property (nonatomic, retain) NSString * anwserMan_id;
@property (nonatomic, retain) NSNumber * awscount;
@property (nonatomic, retain) NSString * awsermanName;
@property (nonatomic, retain) NSNumber * hasNewAnwser;
@property (nonatomic, retain) NSDate * lastawsTime;
@property (nonatomic, retain) NSSet *anwserContents;
@property (nonatomic, retain) NSSet *anwserSender;
@property (nonatomic, retain) ClassEvent *eventParent;
@property (nonatomic, retain) ClassEventSent *eventSentParent;
@end

@interface ClassAnwserMan (CoreDataGeneratedAccessors)

- (void)addAnwserContentsObject:(ClassAnwserContent *)value;
- (void)removeAnwserContentsObject:(ClassAnwserContent *)value;
- (void)addAnwserContents:(NSSet *)values;
- (void)removeAnwserContents:(NSSet *)values;

- (void)addAnwserSenderObject:(ClassAnwserSender *)value;
- (void)removeAnwserSenderObject:(ClassAnwserSender *)value;
- (void)addAnwserSender:(NSSet *)values;
- (void)removeAnwserSender:(NSSet *)values;

@end
