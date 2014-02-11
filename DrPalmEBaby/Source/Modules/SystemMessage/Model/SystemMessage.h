//
//  SystemMessage.h
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-8-19.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SystemMessage : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * inactivetime;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * system_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSString * summary;

@end
