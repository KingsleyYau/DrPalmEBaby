//
//  CustomCommunicateMan.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomCommunicateMan.h"
#import "CommunicateDataManager.h"
@implementation CommunicateMan (Custom)

+ (NSString *)idWithDict:(NSDictionary *)dict{
    return [dict objectForKey:@"cid"];
}
- (void)updateWithDict:(NSDictionary *)dict
{
    //id
    self.contact_id = [CommunicateMan idWithDict:dict];
    
    //name
    id foundValue = [dict objectForKey:@"cname"];
    if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]])
        self.contactName = foundValue;
    
    //lastupdate
    foundValue = [dict objectForKey:@"lastupdate"];
    if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSNumber class]])
    {
        double time = [foundValue doubleValue];
        self.lastMessageDate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //unread
    foundValue = [dict objectForKey:@"unread"];
    if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSNumber class]])
    {
        NSInteger unread = [foundValue integerValue];
        self.unread = [NSNumber numberWithInteger:unread];
    }
    
    // 头像最后更新
    foundValue = [dict objectForKey:@"headimglastupdate"];
    if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSNumber class]]) {
        double time = [foundValue doubleValue];
 
        if(!self.headImageLastUpdate || [self.headImageLastUpdate isEqualToDate:[self.headImageLastUpdate earlierDate:[NSDate dateWithTimeIntervalSince1970:time]]]) {
            // 头像有更新
            self.headImageLastUpdate = [NSDate dateWithTimeIntervalSince1970:time];
            
            foundValue = [dict objectForKey:@"headimgurl"];
            if(foundValue != nil && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]) {
                CommunicateFile *file = [CommunicateDataManager fileWithUrl:foundValue isLocal:NO];
                self.headImage = file;
            }
        }
        
    }
    
    self.isShow = [NSNumber numberWithBool:YES];

}
@end
