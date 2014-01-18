//
//  CustomClassAnwserContent.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomClassAnwserContent.h"
#import "ClassDataManager.h"

@implementation ClassAnwserContent (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict
{
    return [dict objectForKey:@"awsid"];
}

- (void)updateWithDictEventId:(NSDictionary *)dict anwserMan_id:(NSString*)anwserMan_id event_id:(NSString *)event_id
{
    //answerid
    self.anwser_id = [ClassAnwserContent idWithDict:dict];
    //answerdate
    id foundValue = [dict objectForKey:@"awstime"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSNumber class]])
    {
        double time = [foundValue doubleValue];
        self.anwserDate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    //pubid
    foundValue = [dict objectForKey:@"pubid"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]]) {
        self.anwserPub_id = foundValue;
        ClassAnwserSender *item = [ClassDataManager anwserSenderInsertWithId:foundValue];
        self.anwserSender = item;
    }
    
    //pubname
    foundValue = [dict objectForKey:@"name"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]]) {
        self.anwserPubName = foundValue;
    }
    
//    //receiverid
//    foundValue = [dict objectForKey:@"recid"];
//    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
//        self.receiver_id = foundValue;
//    
//    //recname
//    foundValue = [dict objectForKey:@"recname"];
//    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
//        self.receiverName = foundValue;
    
    //body
    foundValue = [dict objectForKey:@"awsbody"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
        self.body = foundValue;
    
    
    ClassAnwserMan* classAswMan = [ClassDataManager anwserManWithIdEventId:anwserMan_id eventId:event_id];
    [classAswMan addAnwserContentsObject:self];
    
    return;
}
- (void)updateWithDictEventSentId:(NSDictionary *)dict anwserMan_id:(NSString*)anwserMan_id event_id:(NSString *)event_id
{
    //answerid
    self.anwser_id = [ClassAnwserContent idWithDict:dict];
    //answerdate
    id foundValue = [dict objectForKey:@"awstime"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSNumber class]])
    {
        double time = [foundValue doubleValue];
        self.anwserDate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    //pubid    
    foundValue = [dict objectForKey:@"pubid"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]]) {
        self.anwserPub_id = foundValue;
        ClassAnwserSender *item = [ClassDataManager anwserSenderInsertWithId:foundValue];
        self.anwserSender = item;
    }
    
    //pubname
    foundValue = [dict objectForKey:@"name"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
        self.anwserPubName = foundValue;
    
    //receiverid
//    foundValue = [dict objectForKey:@"recid"];
//    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
//        self.receiver_id = foundValue;
//    
//    //recname
//    foundValue = [dict objectForKey:@"recname"];
//    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
//        self.receiverName = foundValue;
    
    //body
    foundValue = [dict objectForKey:@"awsbody"];
    if(foundValue != nil && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
        self.body = foundValue;
    
    
    ClassAnwserMan* classAswMan = [ClassDataManager anwserManWithIdEventSentId:anwserMan_id eventId:event_id];
    [classAswMan addAnwserContentsObject:self];
    self.anwserMan = classAswMan;
    return;
}


@end
