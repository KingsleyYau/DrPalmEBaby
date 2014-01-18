//
//  ClassUnRead.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-16.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ClassUnRead : NSManagedObject

@property (nonatomic, retain) NSNumber * unreadcount;
@property (nonatomic, retain) NSString * user;

@end
