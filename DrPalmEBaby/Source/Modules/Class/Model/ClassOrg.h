//
//  ClassOrg.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-16.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassEventDraft, ClassOrg, ClassUserTopOrg;

@interface ClassOrg : NSManagedObject

@property (nonatomic, retain) NSDate * lastupdate;
@property (nonatomic, retain) NSString * orgID;
@property (nonatomic, retain) NSNumber * orgLeafCount;
@property (nonatomic, retain) NSString * orgName;
@property (nonatomic, retain) NSString * orgPath;
@property (nonatomic, retain) NSString * orgStatus;
@property (nonatomic, retain) NSString * orgType;
@property (nonatomic, retain) NSSet *eventDrafts;
@property (nonatomic, retain) NSSet *orgParents;
@property (nonatomic, retain) NSSet *orgSubs;
@property (nonatomic, retain) NSSet *user;
@end

@interface ClassOrg (CoreDataGeneratedAccessors)

- (void)addEventDraftsObject:(ClassEventDraft *)value;
- (void)removeEventDraftsObject:(ClassEventDraft *)value;
- (void)addEventDrafts:(NSSet *)values;
- (void)removeEventDrafts:(NSSet *)values;

- (void)addOrgParentsObject:(ClassOrg *)value;
- (void)removeOrgParentsObject:(ClassOrg *)value;
- (void)addOrgParents:(NSSet *)values;
- (void)removeOrgParents:(NSSet *)values;

- (void)addOrgSubsObject:(ClassOrg *)value;
- (void)removeOrgSubsObject:(ClassOrg *)value;
- (void)addOrgSubs:(NSSet *)values;
- (void)removeOrgSubs:(NSSet *)values;

- (void)addUserObject:(ClassUserTopOrg *)value;
- (void)removeUserObject:(ClassUserTopOrg *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

@end
