//
//  LastUpdate.h
//  DrPalm
//
//  Created by KingsleyYau on 13-4-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LastUpdate : NSManagedObject

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSDate * lastupdate;
@property (nonatomic, retain) NSNumber * unReadCount;
@property (nonatomic, retain) NSString * user;

@end
