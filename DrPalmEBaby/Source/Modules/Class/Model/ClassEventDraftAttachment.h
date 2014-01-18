//
//  ClassEventDraftAttachment.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-16.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassEventDraft;

@interface ClassEventDraftAttachment : NSManagedObject

@property (nonatomic, retain) NSString * attid;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) ClassEventDraft *eventDraft;

@end
