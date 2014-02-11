//
//  CustomClassEventSent.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomClassEventSent.h"
#import "ClassCommonDef.h"
@implementation ClassEventSent (Custom)

+ (NSString *)idWithDict:(NSDictionary *)dict
{
    return [dict objectForKey:EventId];
}

- (void)updateWithDict:(NSDictionary *)dict
{
    //id
    self.event_id = [ClassEventSent idWithDict:dict];
    
    //ownerid
    id foundValue = [dict objectForKey:Events_OwnerId];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.ownerid = foundValue;
    
    //owner
    foundValue = [dict objectForKey:Events_Owner];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.owner= foundValue;

    
    //category
    foundValue = [dict objectForKey:Events_Type];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        ClassEventCategory* category = [ClassDataManager categaoryWithId:foundValue];
        [self addCategoriesObject:category];
        [category addEventsSentObject:self];
    }
    //orieventid
    foundValue = [dict objectForKey:Events_OriEventsId];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.orieventid = foundValue;
    
    
    //oristatus
    foundValue = [dict objectForKey:Events_OriStatus];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.oristatus = foundValue;
    
    //publid
    foundValue = [dict objectForKey:Events_PubId];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.pub_id = foundValue;
    
    //pubname
    foundValue = [dict objectForKey:Events_PubName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.pubName = foundValue;
    
    //postDate
    foundValue = [dict objectForKey:Events_PostDate];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSNumber class]]))
    {
        double time = [foundValue doubleValue];
        self.postDate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //start
    foundValue = [dict objectForKey:Events_Start];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSNumber class]]))
    {
        double time = [foundValue doubleValue];
        self.startDate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    //end
    foundValue = [dict objectForKey:Events_End];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSNumber class]]))
    {
        double time = [foundValue doubleValue];
        self.endDate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    //status
    foundValue = [dict objectForKey:Events_Status];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.status = foundValue;
    
    //ifeshow
    foundValue = [dict objectForKey:Events_Ifeshow];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
        self.ifshow = [NSNumber numberWithInt:[foundValue intValue]];
    
    //title
    foundValue = [dict objectForKey:Events_Title];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.title = foundValue;
    
    //location
    foundValue = [dict objectForKey:Events_Location];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.location = foundValue;
    
    //locurl
    foundValue = [dict objectForKey:Events_Locationurl];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.locationUrl = foundValue;
    
    //cancelledtime
    foundValue = [dict objectForKey:Events_Cancelled];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSNumber class]]))
    {
        double time = [foundValue doubleValue];
        self.cancelDate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //thumburl
    foundValue = [dict objectForKey:Events_Thumburl];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        self.mainImage = [ClassDataManager imageWithImageFullUrl:foundValue isLocal:NO];
        [self.mainImage.thumbImage addEventSentParentObject:self];
    }
    
    //LastUpdate
    foundValue = [dict objectForKey:Events_Lastupdate];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSNumber class]]))
    {
        double time = [foundValue doubleValue];
        self.lastUpdate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //lastaswtime
    foundValue = [dict objectForKey:Events_Lastawstime];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSNumber class]]))
    {
        double time = [foundValue doubleValue];
        self.lastAwsTime = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //awscount
    foundValue = [dict objectForKey:Events_AwsCount];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSNumber class]]))
    {
        NSInteger count = [foundValue integerValue];
        self.awscount = [NSNumber numberWithInteger:count];
    }
    
    
    //hasatta
    foundValue = [dict objectForKey:Events_Hasatt];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
    {
        self.hasAtt = [NSNumber numberWithInt:[foundValue intValue]];
    }
    
    //body
    foundValue = [dict objectForKey:Events_Body];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        self.body = foundValue;
    }
    
    //cleanbody
    foundValue = [dict objectForKey:Events_CleanBody];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        self.cleanbody = foundValue;
    }
    
    //summary
    foundValue = [dict objectForKey:Events_Summary];
    if (nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        self.summary = foundValue;
    }
    // readcount 列表拿回
    foundValue = [dict objectForKey:Events_ReadTotal];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
    {
        self.readCount = [NSNumber numberWithInt:[foundValue intValue]];
    }
    // readcount 详细拿回
    foundValue = [dict objectForKey:Events_ReadCount];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
    {
        self.readCount = [NSNumber numberWithInt:[foundValue intValue]];
    }
    // readtotal 详细拿回
    foundValue = [dict objectForKey:Events_RecvTotal];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
    {
        self.readTotal = [NSNumber numberWithInt:[foundValue intValue]];
    }
    //readtotal列表拿回
    foundValue = [dict objectForKey:Events_SentTotal];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
    {
        self.readTotal = [NSNumber numberWithInt:[foundValue intValue]];
    }
    
    //awslist
    foundValue = [dict objectForKey:Events_AwsOrgList];
    if(nil !=foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* dict in foundValue)
        {
            ClassAnwserMan* classAnswerMan =  [ClassDataManager anwserManWithDictEventSentId:dict eventId:self.event_id];
            [self addAnwserMansObject:classAnswerMan];
        }
    }
    
    //attachment
    foundValue = [dict objectForKey:Events_Attachs];
    if(nil !=foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSArray class]]){
        for(NSDictionary* dict in foundValue)
        {
            //attsize
            id attsize = [dict objectForKey:Events_AttSize];
            if(nil !=attsize && [NSNull null] != attsize && [attsize isKindOfClass:[NSNumber class]])
            {
                NSInteger size = [attsize integerValue];
                self.attasize = [NSNumber numberWithInteger:size];
            }
            
            
            ClassEventCategory *category = [[self.categories allObjects] lastObject];
            if(category && [category.category_id isEqualToString:ClassCategoryIdVideo]) {
                // TODO:视频附件
                NSString* url = [ClassFile preViewUrlWithDict:dict];
                if (nil != url) {
                    ClassFile* classfile = [ClassDataManager fileWithUrl:url isLocal:NO];
                    id attDes = [dict objectForKey:Events_AttachDes];
                    if(attDes!= nil && attDes != [NSNull null] && [attDes isKindOfClass:[NSString class]]) {
                        classfile.title = attDes;
                        classfile.caption = attDes;
                    }
                    
                    id attId = [dict objectForKey:Events_AttachId];
                    if ([attId isKindOfClass:[NSString class]]) {
                        classfile.attid = attId;
                    }
                    [self addAttachmentsObject:classfile];
                }
                NSString* rtspurl = [ClassFile urlWithDict:dict];
                self.rtspurl = rtspurl;
            }
            else {
                NSString *url = [ClassFile urlWithDict:dict];
                //url = @"http://picm.photophoto.cn/015/037/003/0370032269.jpg";
                if (nil != url) {
                    ClassFile* classfile = [ClassDataManager fileWithUrl:url isLocal:NO];
                    id attDes = [dict objectForKey:Events_AttachDes];
                    if(attDes!= nil && attDes != [NSNull null] && [attDes isKindOfClass:[NSString class]]) {
                        classfile.title = attDes;
                        classfile.caption = attDes;
                    }
                    
                    id attId = [dict objectForKey:Events_AttachId];
                    if ([attId isKindOfClass:[NSString class]]) {
                        classfile.attid = attId;
                    }
                    [self addAttachmentsObject:classfile];
                }
            }

        }
    }

    // sortField
    if (nil == self.sortField) {
        self.sortField = self.lastUpdate;
    }
    else {
        if (NSOrderedAscending == [self.sortField compare:self.lastAwsTime]) {
            self.sortField = self.lastAwsTime;
        }
    }
}

- (void)setUpEKEvent:(EKEvent *)ekEvent
{
    ekEvent.title = self.title;
    ekEvent.startDate = self.startDate;
    ekEvent.endDate = self.endDate;
    if (self.location.length > 0) {
        ekEvent.location = self.location;
    }
    
    if (self.description >0){
        ekEvent.notes = self.description;
    }
}
- (NSString *)dateStringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle separator:(NSString *)separator {
	NSMutableArray *parts = [NSMutableArray arrayWithCapacity:2];
    NSString *startDateString = [self.startDate toStringYMDHMS];
    NSString *endDateString = [self.endDate toStringYMDHMS];
    
    [parts addObject:[NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"StartTime", nil), startDateString]];
    [parts addObject:[NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"EndTime", nil), endDateString]];
	
	return [parts componentsJoinedByString:separator];
}
@end
