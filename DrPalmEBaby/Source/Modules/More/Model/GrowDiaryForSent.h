//
//  GrowDiaryForSent.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-12.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GrowDiaryForSent : NSManagedObject

@property (nonatomic, retain) NSString * diaryid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * user;

@end
