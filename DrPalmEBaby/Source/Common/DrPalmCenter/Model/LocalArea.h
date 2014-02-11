//
//  LocalArea.h
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-8-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocalArea, LocalAreaFile;

@interface LocalArea : NSManagedObject

@property (nonatomic, retain) NSNumber * bookmark;
@property (nonatomic, retain) NSString * local_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * schoolKey;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) LocalAreaFile *logo;
@property (nonatomic, retain) LocalArea *parent;
@property (nonatomic, retain) NSSet *subs;
@property (nonatomic, retain) NSManagedObject *directParentAgent;
@end

@interface LocalArea (CoreDataGeneratedAccessors)

- (void)addSubsObject:(LocalArea *)value;
- (void)removeSubsObject:(LocalArea *)value;
- (void)addSubs:(NSSet *)values;
- (void)removeSubs:(NSSet *)values;
@end
