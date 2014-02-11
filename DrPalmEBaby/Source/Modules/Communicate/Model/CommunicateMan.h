//
//  CommunicateMan.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-12-18.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CommunicateFile, CommunicateList;

@interface CommunicateMan : NSManagedObject

@property (nonatomic, retain) NSString * contact_id;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSNumber * isShow;
@property (nonatomic, retain) NSDate * lastMessageDate;
@property (nonatomic, retain) NSNumber * unread;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSDate * headImageLastUpdate;
@property (nonatomic, retain) NSSet *contactList;
@property (nonatomic, retain) CommunicateFile *headImage;
@end

@interface CommunicateMan (CoreDataGeneratedAccessors)

- (void)addContactListObject:(CommunicateList *)value;
- (void)removeContactListObject:(CommunicateList *)value;
- (void)addContactList:(NSSet *)values;
- (void)removeContactList:(NSSet *)values;

@end
