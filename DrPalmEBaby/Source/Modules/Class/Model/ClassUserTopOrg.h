//
//  ClassUserTopOrg.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-16.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassOrg;

@interface ClassUserTopOrg : NSManagedObject

@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSSet *topOrgs;
@end

@interface ClassUserTopOrg (CoreDataGeneratedAccessors)

- (void)addTopOrgsObject:(ClassOrg *)value;
- (void)removeTopOrgsObject:(ClassOrg *)value;
- (void)addTopOrgs:(NSSet *)values;
- (void)removeTopOrgs:(NSSet *)values;

@end
