//
//  Agent.h
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-8-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocalArea;

@interface Agent : NSManagedObject

@property (nonatomic, retain) NSString * localID;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *directSubLocalArea;
@end

@interface Agent (CoreDataGeneratedAccessors)

- (void)addDirectSubLocalAreaObject:(LocalArea *)value;
- (void)removeDirectSubLocalAreaObject:(LocalArea *)value;
- (void)addDirectSubLocalArea:(NSSet *)values;
- (void)removeDirectSubLocalArea:(NSSet *)values;
@end
