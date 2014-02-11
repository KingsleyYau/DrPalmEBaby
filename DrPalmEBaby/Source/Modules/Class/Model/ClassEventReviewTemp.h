//
//  ClassEventReviewTemp.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-16.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassEvent;

@interface ClassEventReviewTemp : NSManagedObject

@property (nonatomic, retain) NSNumber * bRequired;
@property (nonatomic, retain) NSNumber * iDefault;
@property (nonatomic, retain) NSNumber * iMax;
@property (nonatomic, retain) NSString * itemID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) ClassEvent *eventParent;

@end
