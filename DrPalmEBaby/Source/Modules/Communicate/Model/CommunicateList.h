//
//  CommunicateList.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CommunicateMan;

@interface CommunicateList : NSManagedObject

@property (nonatomic, retain) NSString * message_id;
@property (nonatomic, retain) NSString * send_cid;
@property (nonatomic, retain) NSString * recv_cid;
@property (nonatomic, retain) NSString * recvName;
@property (nonatomic, retain) NSString * sendName;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * lastupdate;
@property (nonatomic, retain) CommunicateMan *contactMan;

@end
