//
//  LatestItem.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-29.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LatestItem : NSManagedObject

@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSString * categoryType;
@property (nonatomic, retain) NSString * item_id;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSDate * lastLocalUpdate;

@end
