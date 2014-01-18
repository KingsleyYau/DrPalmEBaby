//
//  CustomClassEvent.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomClassEvent.h"
#import "ClassCommonDef.h"
//#import "ClassModuleDefine.h"
//#import "ClassDataManager.h"
//#import "CustomClassFile.h"
//#import "ClassLanguageDef.h"
//#import "NSDate+ToString.h"
@implementation ClassEvent (Custom)
+ (NSString*)idWithDict:(NSDictionary *)dict {
    return [dict objectForKey:EventId];
}

+ (double)lastupdateWithDict:(NSDictionary *)dict{
    return [[dict objectForKey:LastUpdate] doubleValue];
}

+ (double)lastreadWithDict:(NSDictionary*)dict
{
    return [[dict objectForKey:LastReadTime] doubleValue];
}
- (void)updateWithDict:(NSDictionary *)dict {
    //id
    self.event_id = [ClassEvent idWithDict:dict];
    
    //category
    id foundValue = [dict objectForKey:Events_Type];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        ClassEventCategory* category = [ClassDataManager categaoryWithId:foundValue];
        [self addCategoriesObject:category];
        [category addEventsObject:self];
    }
    
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
    
    //isReadForServer
    foundValue = [dict objectForKey:Events_IsReadforServer];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
        self.isReadforServer = [NSNumber numberWithInt:[foundValue intValue]];
    
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
        [self.mainImage.thumbImage addEventParentObject:self];
    }
    
    //LastUpdate
    foundValue = [dict objectForKey:Events_Lastupdate];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSNumber class]]))
    {
        double time = [foundValue doubleValue];
        self.lastUpdate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //lastreadtime
    foundValue = [dict objectForKey:Events_LastReadTime];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSNumber class]]))
    {
        double time = [foundValue doubleValue];
        self.lastreadtime = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //lastaswtime
    foundValue = [dict objectForKey:Events_Lastawstime];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSNumber class]]))
    {
        double time = [foundValue doubleValue];
        self.lastAwsTime = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    //lastawsuserid
    foundValue = [dict objectForKey:Events_LastawsId];
    if(nil != foundValue && [NSNull null] != foundValue &&
       ([foundValue isKindOfClass:[NSString class]] || [foundValue isKindOfClass:[NSString class]]))
    {
        self.lastawsuserid = foundValue;
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
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
    {
        self.summary = foundValue;
    }
    
    //hasatta
    foundValue = [dict objectForKey:Events_Hasatt];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
    {
        self.hasAtt = [NSNumber numberWithInt:[foundValue intValue]];
    }
    
    //ownerid
    foundValue = [dict objectForKey:Events_OwnerId];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.ownerid = foundValue;
    
    //owner
    foundValue = [dict objectForKey:Events_Owner];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.owner= foundValue;
    
    // 回评
    foundValue = [dict objectForKey:Events_NeedReview];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.needreview = foundValue;
    }
    // 回评模板
    foundValue = [dict objectForKey:Events_ReviewTemp];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSArray class]]) {
        for(NSDictionary *dict in foundValue) {
            ClassEventReviewTemp *temp = [ClassDataManager reviewTempInsertWithDictEventId:dict eventId:self.event_id];
            [self addReviewTempObject:temp];
        }
    }
    
    // 反馈和回复
    foundValue = [dict objectForKey:Events_AwsOrgList];
    if(nil !=foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* dict in foundValue)
        {
            // 讨论组
            ClassAnwserMan* classAnswerMan =  [ClassDataManager anwserManWithDictEventId:dict eventId:self.event_id];
            [self addAnwserMansObject:classAnswerMan];
        }
    }
    
    
    
    //attachment
    foundValue = [dict objectForKey:Events_Attachs];
    if(nil !=foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSArray class]])
    {
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
                // TODO:图片附件
                NSString* url = [ClassFile urlWithDict:dict];
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
    
    // 对旧通告处理
    //orieventid
    foundValue = [dict objectForKey:Events_OriEventsId];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {

        ClassEvent *oldEvent = [ClassDataManager eventWithId:foundValue];
        if(oldEvent) {
            //oristatus
            foundValue = [dict objectForKey:Events_OriStatus];
            if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
                oldEvent.status = foundValue;
            }
        }
    }
    
    
    //oristatus
    foundValue = [dict objectForKey:Events_OriStatus];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]])
        self.oristatus = foundValue;
}
- (void)updateFavourWithDict:(NSDictionary *)dict {
    //
    self.event_id = [ClassEvent idWithDict:dict];
    
    // 取消需要同步状态
    self.alreadySynchronize = [NSNumber numberWithBool:YES];
    
    
    
    // 服务器收藏状态
    id foundValue = [dict objectForKey:FavourStatus];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        if([foundValue isEqualToString:FavourBookmark]) {
            // 已收藏
            self.bookmarked = [NSNumber numberWithBool:YES];
        }
        else if([foundValue isEqualToString:FavourUnBookmark]) {
            // 取消收藏
            self.bookmarked = [NSNumber numberWithBool:NO];
        }
    }
    //最后更新时间
    foundValue = [dict objectForKey:FavourLastUpdate];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]])
    {
        self.favourLastUpdate = [NSDate dateWithTimeIntervalSince1970:[foundValue doubleValue]];
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
