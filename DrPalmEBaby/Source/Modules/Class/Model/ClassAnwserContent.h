//
//  ClassAnwserContent.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-16.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassAnwserMan, ClassAnwserSender;

@interface ClassAnwserContent : NSManagedObject

@property (nonatomic, retain) NSString * anwser_id;
@property (nonatomic, retain) NSDate * anwserDate;
@property (nonatomic, retain) NSString * anwserPub_id;
@property (nonatomic, retain) NSString * anwserPubName;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) ClassAnwserMan *anwserMan;
@property (nonatomic, retain) ClassAnwserSender *anwserSender;

@end
