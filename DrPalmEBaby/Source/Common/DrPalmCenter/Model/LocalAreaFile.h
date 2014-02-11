//
//  LocalAreaFile.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocalArea;

@interface LocalAreaFile : NSManagedObject

@property (nonatomic, retain) NSString * contenttype;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * fileext;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * pathtype;
@property (nonatomic, retain) NSSet *logoParent;
@end

@interface LocalAreaFile (CoreDataGeneratedAccessors)

- (void)addLogoParentObject:(LocalArea *)value;
- (void)removeLogoParentObject:(LocalArea *)value;
- (void)addLogoParent:(NSSet *)values;
- (void)removeLogoParent:(NSSet *)values;
@end
