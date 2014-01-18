//
//  CustomCommunicateList.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomCommunicateList.h"
#import "CommunicateDataManager.h"

@implementation CommunicateList (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict
{
    return [dict objectForKey:@"msgid"];
}
- (void)updateWithDict:(NSDictionary *)dict manId:(NSString *)manId
{
    self.message_id = [CommunicateList idWithDict:dict];
    //sendcid
    id foundValue = [dict objectForKey:@"sendcid"];
    if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]])
        self.send_cid = foundValue;
    
    //sendname
    foundValue = [dict objectForKey:@"sendcname"];
    if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]])
        self.sendName = foundValue;

    
    //recvcid
    foundValue = [dict objectForKey:@"recvcid"];
    if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]])
        self.recv_cid = foundValue;

    
    //recvcname
    foundValue = [dict objectForKey:@"recvcname"];
    if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]])
        self.recvName = foundValue;

    
    //body
    foundValue = [dict objectForKey:@"body"];
    if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]])
        self.body = foundValue;
    
    //lastupdate
    foundValue = [dict objectForKey:@"lastupdate"];
    if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSNumber class]])
    {
        double time = [foundValue doubleValue];
        self.lastupdate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //
    CommunicateMan* commman = [CommunicateDataManager manWithId:manId];
    self.contactMan = commman;
    [commman addContactListObject:self];

}
@end
