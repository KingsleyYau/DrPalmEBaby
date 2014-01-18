//
//  ClassRequestOperator.m
//  DrPalm
//
//  Created by JiangBo on 13-1-14.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "ClassRequestOperator.h"
#import "ClassCommonDef.h"
#import "ClassModuleDefine.h"
#import "LoginManager.h"
#import "ClassDataManager.h"
#import "CustomClassEvent.h"
#import "CustomClassAnwserContent.h"
#import "CustomCommunicateList.h"
#import "CommunicateDataManager.h"
#import "SystemMessageDataManager.h"
#import "CommunicateMan.h"
#import "SBJSON.h"
#import "NSStringCheck.h"

@implementation ReviewDraft
@end

@interface ClassRequestOperator() {
    
}
@property (nonatomic, retain) RequestOperator *requestOperator;
#pragma mark 处理获取通告列表返回
-(void)handleGetEventList:(id)data;
#pragma mark 处理获取通告详细返回
-(void)handleGetEventDetail:(id)data;
#pragma mark 处理获取已发通告列表返回
-(void)handleGetSentEventList:(id)data;
#pragma mark 处理获取已发通告详细返回
-(void)handleGetSentEventDetail:(id)data;
#pragma mark 处理获取已读明细信息返回
-(void)handleGetEventReadInfo:(id)data;
#pragma mark 处理发送通告返回
-(void)handleSubmitClass:(id)data;
#pragma mark 处理删除已发通告返回
-(void)handleDelSendEvent:(id)data;

#pragma mark  处理获取组织结构返回
//-(void)handleGetOrgInfo:(id)data;
//处理组织结构获取返回
//-(void)handleGetOrgnization:(id)data;
////处理上级节点组织结构获取返回
//-(void)handleGetParentOrgnization:(id)data;

//处理自动回复返回
//-(void)handleAutoAnswer:(id)data;
////处理批量自动回复返回
//-(void)handleBatAutoAnswer:(id)data;
//处理获取已发通告的反馈人列表返回
//-(void)handleGetAnswerList:(id)data;

#pragma mark 处理获取已发通告某反馈人回复内容返回
-(void)handleGetAnswerContent:(id)data;
//
-(void)handleSentAnswer:(id)data;
//
-(void)handleGetContactList:(id)data;
//
-(void)handleGetContactMsgs:(id)data;
//
-(void)handleSentContctMsgs:(id)data;
#pragma mark 处理获取系统信息列表返回
-(void)handleGetSysMsgs:(id)data;
#pragma mark 处理获取系统消息内容返回
#pragma mark 处理获取最新我的班级信息返回
-(void)handleGetEventModuleInfoList:(id)data;
#pragma mark 处理获取收藏班级信息
- (void)handleGetBookmarkEvent:(id)data;
#pragma mark 处理提交收藏班级信息
- (void)handleSubmitBookmarkEvent:(id)data;
@end

@implementation ClassRequestOperator
@synthesize delegate;
@synthesize requestOperator = _requestOperator;
-(id)init
{
    self = [super init];
    if(self)
    {
        _requestOperator = [[RequestOperator alloc] init];
        _requestOperator.delegate = self;
        [self cancel];
    }
    return self;
}

-(void)cancel
{
    _status = ClassRequestOperator_None;
    [self.requestOperator cancel];
}

-(void)dealloc
{
    [self cancel];
    self.delegate = nil;
    self.requestOperator = nil;
    self.requestOperator.delegate = nil;
    [super dealloc];
}

#pragma mark 获取通告列表
-(BOOL)getEventList:(NSString *)type lastupdate:(NSInteger)lastupdate lastReadTime:(NSInteger)lastReadTime;
{
    [self cancel];
    _status = ClassRequestOperator_GetEventList;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary  dictionary];
    
    // SessionKey
    LoginManager* loginmanager = LoginManagerInstance();
    if(loginmanager.sessionKey.length > 0) {
        [paramDict setObject:loginmanager.sessionKey forKey:SESSION_KEY];
    }
    
    // 分类
    if(type.length > 0) {
        [paramDict setObject:type forKey:GetEventList_Type];
        self.requestOperator.paramOperation = type;
    }

    // 最后更新
    NSString* nslastupdate = [NSString stringWithFormat:@"%d",lastupdate];
    [paramDict setObject:nslastupdate forKey:LastUpdate];
    
    // 最后阅读
    NSString* nslastreadtime = [NSString stringWithFormat:@"%d",lastReadTime];
    [paramDict setObject:nslastreadtime forKey:LastReadTime];

    return [self.requestOperator sendSingleGet:GetEventList_Path paramDict:paramDict];
}

//处理获取通告列表返回
-(void)handleGetEventList:(id)data
{
    if(nil == data || [NSNull null] == data || ![data isKindOfClass:[NSDictionary class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:@"parse fail" requestType:ClassRequestOperator_GetEventList];
        });
        return;
    }

    //当前条数
    int curCount = [[data objectForKey:CurrentCount] intValue];
    //剩余条数
    int retCount = [[data objectForKey:RetCount] intValue];

    id items = [data objectForKey:EventListItems];
    _lastupdatetime = 0;
    _lastreadtime = 0;
    if(items == nil ||[NSNull null] == items) 
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFinish:[NSNumber numberWithInteger:curCount] requestType:ClassRequestOperator_GetEventList];
        });
        return;
    }
    if([items isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSInteger i = 0;
            for (NSDictionary* dict in (NSArray*)items)
            {
                double lastupdate = [ClassEvent lastupdateWithDict:dict];
                double lastread   = [ClassEvent lastreadWithDict:dict];
                if(_lastupdatetime<lastupdate)
                    _lastupdatetime = lastupdate;
//                if([ClassDataManager eventIsExist:[ClassEvent idWithDict:dict]])
//                   i++;
                if(_lastreadtime<lastread)
                    _lastreadtime = lastread;
                
                [ClassDataManager eventWitdhDict:dict];
            }
            
            if(self.requestOperator.paramOperation) {
                //分类最后更新时间和条数
                ClassEventCategory* category = [ClassDataManager queryCategaoryWithId:self.requestOperator.paramOperation];
                if(category)
                {
                    category.lastUpdated = [NSDate date];
                    if(_lastupdatetime != 0)
                        category.lastUpdateChannelList = [NSDate dateWithTimeIntervalSince1970:_lastupdatetime];
                    //            category.expectedCount = [NSNumber numberWithInt:i];
                    category.expectedCount = [NSNumber numberWithInt:curCount];
                }
            }

            [CoreDataManager saveData];
        });
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetEventList];
        });
    }
    
    //补取或返回
    dispatch_async(dispatch_get_main_queue(), ^{
        if(retCount > 0)
        {
//            NSInteger lastreadtime = 0;
//            NSDate* date = [ClassDataManager lastReadTimeWithCatalog:self.requestOperator.paramOperation];
//            if(date)
//                lastreadtime = [date timeIntervalSince1970];
            [self getEventList:self.requestOperator.paramOperation lastupdate:_lastupdatetime lastReadTime:_lastreadtime];
            //[self getEventList:self.requestOperator.paramOperation lastupdate:_lastupdatetime];
            if([delegate respondsToSelector:@selector(updatedData:requestType:)]) {
                [delegate updatedData:curCount requestType:ClassRequestOperator_GetEventList];
            }
        }
        else
        {
            if([delegate respondsToSelector:@selector(operateFinish:requestType:)]) {
            [delegate operateFinish:[NSNumber numberWithInteger:curCount] requestType:ClassRequestOperator_GetEventList];
            }
        }


    });

}
#pragma mark 获取通告详细
-(BOOL)getEventDetail:(NSString *)eventid isAllField:(BOOL)isAllField
{
    [self cancel];
    _status = ClassRequestOperator_GetEventDetail;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    NSString *allField = [NSString stringWithFormat:@"%d", isAllField];
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sessionKey,SESSION_KEY,
                                      eventid,EventId,
                                      allField, AllField,
                                      nil];
    return [self.requestOperator sendSingleGet:GetEventsDetail_Path paramDict:paramDict];
}
//处理获取通告详细返回
-(void)handleGetEventDetail:(id)data
{
    if(nil == data || [NSNull null] == data || ![data isKindOfClass:[NSDictionary class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:@"parse fail" requestType:ClassRequestOperator_GetEventDetail];
        });
        return;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ClassEvent* classevent = [ClassDataManager eventWitdhDict:data];
            //classevent.isReadforLocal = [NSNumber numberWithBool:YES];  //已读
            classevent.isReadforServer = [NSNumber numberWithBool:YES]; //已读
            [CoreDataManager saveData];
            [delegate operateFinish:nil requestType:ClassRequestOperator_GetEventDetail];
         });
    }
    return;
}
#pragma mark 获取已发通告列表
-(BOOL)getSentEventList:(NSInteger)lastupdae
{
    [self cancel];
    _status = ClassRequestOperator_GetSentEventList;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    
    NSString* nslastupdate = [NSString stringWithFormat:@"%d",lastupdae];
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sessionKey,SESSION_KEY,
                                      nslastupdate,LastUpdate,
                                      nil];
    return [self.requestOperator sendSingleGet:GetSentEventsList_Path paramDict:paramDict];
}
//处理获取已发通告列表返回
-(void)handleGetSentEventList:(id)data
{
    if(nil == data || [NSNull null] == data || ![data isKindOfClass:[NSDictionary class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetSentEventList];
        });
        return;
    }
    
    //当前条数
    //int curCount = [[data objectForKey:CurrentCount] intValue];
    //剩余条数
    int retCount = [[data objectForKey:RetCount] intValue];
    
    id items = [data objectForKey:EventListItems];
    _lastupdatetime = 0;
    if([items isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSInteger i = 0;
            for (NSDictionary* dict in (NSArray*)items)
            {
                NSInteger lastupdate = [ClassEvent lastupdateWithDict:dict];
                if(_lastupdatetime > lastupdate || _lastupdatetime == 0)
                    _lastupdatetime = lastupdate;
                
                [ClassDataManager eventSentWitdhDict:dict];
            }
            [CoreDataManager saveData];
        });
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetSentEventList];
        });
    }
    
    //补取或返回
    dispatch_async(dispatch_get_main_queue(), ^{
        if(retCount > 0)
        {
            //[self getSentEventList:_lastupdatetime];
            [delegate updatedData:_lastupdatetime requestType:ClassRequestOperator_GetSentEventList];
        }
        else
            [delegate operateFinish:[NSNumber numberWithInteger:_lastupdatetime] requestType:ClassRequestOperator_GetSentEventList];
        
    });
}
#pragma mark 获取已发通告详细
-(BOOL)getSentEventDetail:(NSString *)eventid
{
    [self cancel];
    _status = ClassRequestOperator_GetSentEventDetail;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sessionKey,SESSION_KEY,
                                      eventid,EventId,
                                      nil];
    return [self.requestOperator sendSingleGet:GetSentEventsDetail_Path paramDict:paramDict];
}
//处理获取已发通告详细返回
-(void)handleGetSentEventDetail:(id)data
{
    if(nil == data || [NSNull null] == data || ![data isKindOfClass:[NSDictionary class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetSentEventDetail];
        });
        return;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ClassEventSent *classeventsent = [ClassDataManager eventSentWitdhDict:data];
            classeventsent.isRead = [NSNumber numberWithBool:YES];  //已读
            [CoreDataManager saveData];
            [delegate operateFinish:nil requestType:ClassRequestOperator_GetSentEventDetail];
        });
    }
    return;
}
#pragma mark 获取已读明细信息
-(BOOL)getEventReadInfo:(NSString*)eventid
{
    [self cancel];
    _status = ClassRequestOperator_GetEventReadInfo;
    self.requestOperator.paramOperation = eventid;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sessionKey,SESSION_KEY,
                                      eventid,EventId,
                                      nil];
    return [self.requestOperator sendSingleGet:GetEventReadInfo_Path paramDict:paramDict];
}
//处理获取已读明细信息返回
-(void)handleGetEventReadInfo:(id)data
{
    if(nil == data || [NSNull null] == data || ![data isKindOfClass:[NSDictionary class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetEventReadInfo];
        });
        return;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ClassEventSent *classeventsent = [ClassDataManager eventSentWithId:self.requestOperator.paramOperation];
            if(classeventsent)
            {
                //readlist
                NSString* reader = @"";
                id readlist = [data objectForKey:GetEventReadInfo_ReadList];
                if(readlist != nil && readlist != [NSNull null] && [readlist isKindOfClass:[NSArray class]])
                {
                    for (NSDictionary* dict in (NSArray*)readlist)
                    {
                        id name = [dict objectForKey:GetEventReadInfo_Name];
                        if(name != nil && name !=[NSNull null] && [name isKindOfClass:[NSString class]])
                        {
                           reader = [reader stringByAppendingFormat:@"%@ ",name];
                        }
                    }
                    classeventsent.reader = reader;
                }
                //unreadlist
                NSString* unreader = @"";
                id unreadlist = [data objectForKey:GetEventReadInfo_UnreadList];
                if(unreadlist != nil && unreadlist != [NSNull null] && [unreadlist isKindOfClass:[NSArray class]])
                {
                    for (NSDictionary* dict in (NSArray*)unreadlist)
                    {
                        id name = [dict objectForKey:GetEventReadInfo_Name];
                        if(name != nil && name !=[NSNull null] && [name isKindOfClass:[NSString class]])
                        {
                           unreader = [unreader stringByAppendingFormat:@"%@ ",name];
                        }
                    }
                    classeventsent.unreader = unreader;
                }
            }
            [CoreDataManager saveData];
            [delegate operateFinish:nil requestType:ClassRequestOperator_GetEventReadInfo];
        });
    }
    return;

}

#pragma mark 删除已发通告
-(BOOL)delSendEvent:(NSString*)eventId
{
    [self cancel];
    _status = ClassRequestOperator_DelSendEvent;
    
    NSMutableArray *postArray = [NSMutableArray array];
    
    // sessionkey
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0) {
        sessionKey = loginmanager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    
    // eventId
    [postArray addObject:[self.requestOperator buildPostParam:EventId content:eventId]];
    
    return [self.requestOperator sendSinglePost:DelSendEvent_Path paramArray:postArray];
}


#pragma mark 处理删除已发通告返回
-(void)handleDelSendEvent:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate operateFinish:nil requestType:ClassRequestOperator_DelSendEvent];
    });
}


#pragma mark 发布通告
-(BOOL)submitClass:(ClassEventDraft*)draft
{
    [self cancel];
    _status = ClassRequestOperator_SubmitClassEvent;
    
    NSMutableArray *postArray = [NSMutableArray array];
    
    // sessionkey
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0) {
        sessionKey = loginmanager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    
    // 构建ownerid及ownerName
    NSMutableString* ownerid = [NSMutableString string];
    NSMutableString* ownerName = [NSMutableString string];
    for (ClassOrg* org in draft.addressees)
    {
        // ownerid
        if ([ownerid length] > 0) {
            [ownerid appendString:@","];
        }
        [ownerid appendString:org.orgID];
        
        // ownerName
        if ([ownerName length] > 0) {
            [ownerName appendString:@","];
        }
        [ownerName appendString:org.orgName];
    }
    
    // 接收人id
    [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_OwnerId content:ownerid]];
    // 接收人名
    [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_Owner content:ownerName]];
    // 标题
    [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_Title content:draft.title]];
    // 内容
    [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_Body content:[draft.body commitString]]];
    //分类
    ClassEventCategory* category =  [[draft.categories allObjects] lastObject];
    [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_Type content:category.category_id]];
    //是否加急
    [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_Ifeshow content:[draft.ifshow boolValue]?@"1":@"0"]];
    // 地点
    [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_Location content:[draft.location length] > 0 ? draft.location : @"　"]];
    if ([draft.locationUrl length] > 0) {
        [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_LocUrl content:draft.locationUrl]];
    }
    // 开始时间
    if(draft.startDate != nil) {
        [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_Start content:[NSString stringWithFormat:@"%.0f", [draft.startDate timeIntervalSince1970]]]];
    }
    // 结束时间
    if(draft.endDate != nil){
        [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_End  content:[NSString stringWithFormat:@"%.0f", [draft.endDate timeIntervalSince1970]]]];
    }
    // oristatus
    if(draft.orieventid != nil && ![draft.orieventid isEqualToString:@""]){
        [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_OriEventsId content:draft.orieventid]];
        [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_Oristatus content:draft.oristatus]];
    }
    //附件
    NSMutableArray* attachments = [NSMutableArray array];
    NSInteger i = 1;
    for (ClassEventDraftAttachment *file in draft.attachments) {
        NSMutableDictionary* attachmentInfo = [NSMutableDictionary dictionary];
        [attachmentInfo setObject:[file.title length] > 0 ? file.title: @"" forKey:SubmitEvent_FileTitle];
        [attachmentInfo setObject:@"" forKey:SubmitEvent_FileFrom];
        if ([file.attid length] > 0) {
            // 服务器已有附件，不用发送文件数据
            [attachmentInfo setObject:SubmitEvent_IdType forKey:SubmitEvent_AttachType];
            [attachmentInfo setObject:file.attid forKey:SubmitEvent_Item];
        }
        else {
            // 添加到文件数据到boundary
            NSString *attachmentType = [file.type lowercaseString];
            NSString *paramName = nil;
            NSString *fileName = nil;
            if ([attachmentType isEqualToString:@"png"]){
                paramName = [NSString stringWithFormat:@"%d", i];
                fileName = [NSString stringWithFormat:@"%d.png", i];
                [postArray addObject:[self.requestOperator buildFilePostParam:paramName contentType:@"image/png" data:file.data fileName:fileName]];
            }
            else if ([attachmentType isEqualToString:@"jpg"]){
                paramName = [NSString stringWithFormat:@"%d", i];
                fileName = [NSString stringWithFormat:@"%d.jpg", i];
                [postArray addObject:[self.requestOperator buildFilePostParam:paramName contentType:@"image/jpeg" data:file.data fileName:fileName]];
            }
            
            // 填写Json
            [attachmentInfo setObject:SubmitEvent_FileType forKey:SubmitEvent_AttachType];
            [attachmentInfo setObject:paramName forKey:SubmitEvent_Item];
            
            i++;
        }
        [attachments addObject:attachmentInfo];
    }
    
    // file项
    if ([attachments count] > 0) {
        SBJSON* json = [[SBJSON alloc] init];
        [postArray addObject:[self.requestOperator buildPostParam:SubmitEvent_Attachment content:[json stringWithObject:attachments error:nil]]];
        [json release];
    }

    return [self.requestOperator sendSinglePost:SubmitClassEvent_Path paramArray:postArray];
}

#pragma mark 处理发送通告返回
-(void)handleSubmitClass:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(operateFinish:requestType:)]) {
            [delegate operateFinish:nil requestType:ClassRequestOperator_SubmitClassEvent];
        }
    });
    return;
}

//-(BOOL)getOrganization:(NSString *)orgid start:(NSString*)start
//{
//    [self cancel];
//    _status = ClassRequestOperator_GetOrganization;
//    self.requestOperator.paramOperation = orgid;
//    
//    LoginManager* loginmanager = LoginManagerInstance();
//    NSString *sessionKey = @"";
//    if(loginmanager.sessionKey.length > 0)
//        sessionKey = loginmanager.sessionKey;
//    
//    NSMutableDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      sessionKey, SESSION_KEY,
//                                      orgid, OrgId,
//                                      start, GetOrginazation_Start,
//                                      nil];
//    return [self.requestOperator sendSingleGet:GetOrginazation_Path paramDict:paramDict];
//    
//}
////处理组织结构获取返回
//-(void)handleGetOrgnization:(id)data
//{
//    if(nil == data || [NSNull null] == data || ![data isKindOfClass:[NSDictionary class]])
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetOrganization];
//        });
//        return;
//    }
//    
//    BOOL bHasMore = [[data objectForKey:GetOrgnization_More] intValue] == 1?YES:NO;   //是否还有
//    int  end      = [[data objectForKey:GetOrgnization_End] intValue];                // 当前截至纪录号
//    int  reCount  = [[data objectForKey:GetOrgnization_Count] intValue];              //本次返回条数
//    
//    //解析保存
//    id items = [data objectForKey:GetOrgnization_OrgList];
//    if([items isKindOfClass:[NSArray class]])
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            for (NSDictionary* dict in (NSArray*)items)
//            {
//                [ClassDataManager orgWithDict:dict parentId:self.requestOperator.paramOperation];
//            }
//            [CoreDataManager saveData];
//        });
//        
//    }
//    else
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetOrganization];
//        });
//    }
//
//    //是否有更多
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if(bHasMore) //继续请求,同时回调本次返回条数
//        {
//            NSString* nsend = [NSString stringWithFormat:@"%d",end];
//            [self getOrganization:self.requestOperator.paramOperation start:nsend];
//            if(delegate != nil)
//            {
//                [delegate updatedData:reCount requestType:ClassRequestOperator_GetOrganization];
//            }
//        }
//        else
//        {
//            if(delegate != nil)
//            {
//                [delegate operateFinish:[NSNumber numberWithInt:reCount] requestType:ClassRequestOperator_GetOrganization];
//            }
//
//        }
//    });
//}
//
////上级节点组织结构获取
//-(BOOL)getParentOrganization:(NSArray *)orgids
//{
//    [self cancel];
//    _status = ClassRequestOperator_GetParentOrganization;
//    self.requestOperator.paramOperation = orgids;
//    
//    LoginManager* loginmanager = LoginManagerInstance();
//    NSString *sessionKey = @"";
//    if(loginmanager.sessionKey.length > 0)
//        sessionKey = loginmanager.sessionKey;
//    
//    NSMutableDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      sessionKey,SESSION_KEY,
//                                      orgids,OrgId,nil];
//    return [self.requestOperator sendSingleGet:GetParentOrgnization_Path paramDict:paramDict];
//}
//
////处理上级节点组织结构获取返回
//-(void)handleGetParentOrgnization:(id)data
//{
//    if(nil == data || [NSNull null] == data || ![data isKindOfClass:[NSDictionary class]])
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetParentOrganization];
//        });
//        return;
//    }
//    
//    //解析保存
//    id items = [data objectForKey:GetOrgnization_OrgList];
//    if([items isKindOfClass:[NSArray class]])
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            for (NSDictionary* dict in (NSArray*)items)
//            {
//                [ClassDataManager orgWithDict:dict subId:self.requestOperator.paramOperation];
//            }
//            [CoreDataManager saveData];
//        });
//        
//    }
//    else
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetEventList];
//        });
//    }
//}

//自动回复
//-(BOOL)autoAnswer:(NSString *)eventid
//{
//    [self cancel];
//    self.httpClient = [[[HttpClient alloc] init] autorelease];
//    self.httpClient.delegate = self;
//    _status = ClassRequestOperator_AutoAnswer;
//    
//    LoginManager* loginmanager = LoginManagerInstance();
//    if(loginmanager.sessionKey == nil)
//        return NO;
//    NSMutableDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:SESSION_KEY,loginmanager.sessionKey,
//                                      eventid,EventId,nil];
//    return [self sendSingleGet:AutoAnswer_Path paramDict:paramDict];
//}
////处理自动回复返回
//-(void)handleAutoAnswer:(id)data
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [delegate operateFinish:nil requestType:ClassRequestOperator_AutoAnswer];
//    });
//    return;
//}
////批量自动回复
//-(BOOL)batAutoAnswer:(NSString *)eventids
//{
//    [self cancel];
//    self.httpClient = [[[HttpClient alloc] init] autorelease];
//    self.httpClient.delegate = self;
//    _status = ClassRequestOperator_BatAutoAnswer;
//    
//    LoginManager* loginmanager = LoginManagerInstance();
//    if(loginmanager.sessionKey == nil)
//        return NO;
//    NSMutableDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:SESSION_KEY,loginmanager.sessionKey,
//                                      eventids,EventIds,nil];
//    return [self sendSingleGet:BatAutoAnswer_Path paramDict:paramDict];
//}
//-(void)handleBatAutoAnswer:(id)data
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [delegate operateFinish:nil requestType:ClassRequestOperator_BatAutoAnswer];
//    });
//    return;
//}
//获取已发通告的反馈人列表
//-(BOOL)getAnswerList:(NSString *)eventid
//{
//    [self cancel];
//    self.httpClient = [[[HttpClient alloc] init] autorelease];
//    self.httpClient.delegate = self;
//    _status = ClassRequestOperator_GetAwsList;
//    
//    LoginManager* loginmanager = LoginManagerInstance();
//    if(loginmanager.sessionKey == nil)
//        return NO;
//    NSMutableDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:SESSION_KEY,loginmanager.sessionKey,
//                                      eventid,EventId,nil];
//    return [self sendSingleGet:GetAnswerList_Path paramDict:paramDict];
//}
////处理获取已发通告的反馈人列表返回
//-(void)handleGetAnswerList:(id)data
//{
//    return;
//}
#pragma mark 获取通告某反馈人回复内容
-(BOOL)getAnswerContent:(NSString *)eventid aswpubid:(NSString *)aswpubid lasttime:(NSInteger)lasttime
{
    [self cancel];
    _status = ClassRequestOperator_GetAwsContent;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:eventid forKey:@"eventid"];
    if(aswpubid.length > 0)
        [dict setObject:aswpubid forKey:@"aswpubid"];
    self.requestOperator.paramOperation = dict;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    NSString* nslasttime = [NSString stringWithFormat:@"%d",lasttime];
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sessionKey,SESSION_KEY,
                                      eventid,EventId,
                                      aswpubid,AswPubid,
                                      nslasttime,BeginTime,nil];
    return [self.requestOperator sendSingleGet:GetAnswerContent_Path paramDict:paramDict];
}
// 处理获取通告某反馈人回复内容返回
-(void)handleGetAnswerContent:(id)data
{
    NSDictionary *paramDict = self.requestOperator.paramOperation;
    NSString *eventid = [paramDict objectForKey:@"eventid"];
    NSString *aswpubid = [paramDict objectForKey:@"aswpubid"];
    
    id items = [data objectForKey:AwsListItems];
    
    if(items == nil || items == [NSNull null] || ![items isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:@"" requestType:ClassRequestOperator_GetAwsContent];
        });
    }
    else {
        for(NSDictionary *dict in (NSArray*)items)
        {
            [ClassDataManager anwserContentWithDict:dict anwserManId:aswpubid eventId:eventid];
        }
        [CoreDataManager saveData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFinish:[NSNumber numberWithInt:0] requestType:ClassRequestOperator_GetAwsContent];
        });
    }
}
#pragma mark 获取已发通告某反馈人回复内容
-(BOOL)getAnswerContentSent:(NSString *)eventid aswpubid:(NSString *)aswpubid lasttime:(NSInteger)lasttime
{
    [self cancel];
    _status = ClassRequestOperator_GetAwsContentSent;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:eventid forKey:@"eventid"];
    [dict setObject:aswpubid forKey:@"aswpubid"];
    self.requestOperator.paramOperation = dict;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    NSString* nslasttime = [NSString stringWithFormat:@"%d",lasttime];
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sessionKey,SESSION_KEY,
                                      eventid,EventId,
                                      aswpubid,AswPubid,
                                      nslasttime,BeginTime,nil];
    return [self.requestOperator sendSingleGet:GetAnswerContent_Path paramDict:paramDict];
}
// 处理获取已发通告某反馈人回复内容返回
-(void)handleGetAnswerContentSent:(id)data
{
    NSDictionary *paramDict = self.requestOperator.paramOperation;
    NSString *eventid = [paramDict objectForKey:@"eventid"];
    NSString *aswpubid = [paramDict objectForKey:@"aswpubid"];
    
    id items = [data objectForKey:AwsListItems];
    if(items == nil || items == [NSNull null] || ![items isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:@"" requestType:ClassRequestOperator_GetAwsContentSent];
        });
    }
    else {
        for(NSDictionary *dict in (NSArray*)items)
        {
            [ClassDataManager anwserContentWithDictSent:dict anwserManId:aswpubid eventId:eventid];
//            // TODO:如果存在跟已发一样ID的通告,更新该通告最后回复时间
//            if([ClassDataManager eventIsExist:eventid]) {
//                [ClassDataManager anwserContentWithDict:dict anwserManId:aswpubid eventId:eventid];
//            }
        }
        [CoreDataManager saveData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFinish:[NSNumber numberWithInt:0] requestType:ClassRequestOperator_GetAwsContentSent];
        });
    }
}
#pragma mark 反馈发送
-(BOOL)sentAnswer:(NSString *)eventid awspubid:(NSString*)awspubid body:(NSString *)body
{
    [self cancel];
    _status = ClassRequestOperator_SentAnswer;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    
    NSMutableArray *postArray = [NSMutableArray array];
    // sessionkey
    [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    // eventid
    [postArray addObject:[self.requestOperator buildPostParam:EventId content:eventid]];
    //awspubid
    [postArray addObject:[self.requestOperator buildPostParam:AwsPubId content:awspubid]];
    // body
    [postArray addObject:[self.requestOperator buildPostParam:SentAnswer_Body content:body]];

    return [self.requestOperator sendSinglePost:SentAnswer_Path paramArray:postArray];
}

-(void)handleSentAnswer:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate operateFinish:nil requestType:ClassRequestOperator_SentAnswer];
    });
    return;
}

#pragma mark 获取联系人列表
-(BOOL)getContactList:(NSArray*)items
{
    [self cancel];
    _status = ClassRequestOperator_GetContactList;
        
    
    NSMutableArray *postArray = [NSMutableArray array];
    // sessionkey
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0) {
        sessionKey = loginmanager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    
    NSInteger i = 0;
    NSMutableArray* communicateMans = [NSMutableArray array];
    for(CommunicateMan* item in items)
    {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        //联系人id
        [dict setObject:item.contact_id forKey:CommunicateId];
        //时间
        NSArray* commList = [CommunicateDataManager contentListWithManId:item.contact_id];
        if(commList && commList.count>0)
        {
            CommunicateList* commu = (CommunicateList*)[commList lastObject];
            
            NSNumber* time = [NSNumber numberWithInteger:[commu.lastupdate timeIntervalSince1970]];
            [dict setObject:time forKey:CommunicateLastUpdate];
        }
        else
            [dict setObject:[NSNumber numberWithInteger:0] forKey:CommunicateLastUpdate];
            
        [communicateMans addObject:dict];
        i++;
    }
    

    SBJSON* json = [[SBJSON alloc] init];
    [postArray addObject:[self.requestOperator buildPostParam:CommuList content:[json stringWithObject:communicateMans error:nil]]];
    [json release];
    return [self.requestOperator sendSinglePost:GetContactList_Path paramArray:postArray];

}
//处理获取联系人列表返回
-(void)handleGetContactList:(id)data
{
    if(data == nil || data == [NSNull null] || ![data isKindOfClass:[NSDictionary class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetContactList];
        });
    }
    
    id items = [data objectForKey:ContactListItem];
    if([items isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CommunicateDataManager delCommunicateManList];
            int i = 0;
            for(NSDictionary* dict in (NSArray*)items)
            {
                CommunicateMan* man = [CommunicateDataManager manWithDict:dict];
                man.user = LoginManagerInstance().accountName;
                i++;
            }
            [CoreDataManager saveData];
            [delegate operateFinish:[NSNumber numberWithInteger:i] requestType:ClassRequestOperator_GetContactList];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFinish:[NSNumber numberWithInteger:0] requestType:ClassRequestOperator_GetContactList];
        });

    }
    
    return;
}
#pragma mark 获取联系人交流内容
-(BOOL)getContactMsgs:(NSString *)contactid lastupdate:(NSInteger)lastupdate
{
    [self cancel];
    _status = ClassRequestOperator_GetContactMsgs;
    self.requestOperator.paramOperation = contactid;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    
    NSString* nslastupdate = [NSString stringWithFormat:@"%d",lastupdate];
    
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sessionKey,SESSION_KEY,
                                      contactid,Contact_Id,
                                      nslastupdate,GetContactMsgs_Lastupdate,
                                      nil];
    return [self.requestOperator sendSingleGet:GetContactMsgs_Path paramDict:paramDict];
    
}
//处理获取联系人交流内容返回
-(void)handleGetContactMsgs:(id)data
{
    if(data == nil || data == [NSNull null] || ![data isKindOfClass:[NSDictionary class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetContactMsgs];
        });
    }
    
    id items = [data objectForKey:MsgListItem];
    if([items isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            int i = 0;
            for(NSDictionary* dict in (NSArray*)items)
            {
                i++;
                [CommunicateDataManager contentWithDict:dict manId:self.requestOperator.paramOperation];
            }
            [CoreDataManager saveData];
            [delegate operateFinish:[NSNumber numberWithInt:i] requestType:ClassRequestOperator_GetContactMsgs];
        });

    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFinish:[NSNumber numberWithInt:0] requestType:ClassRequestOperator_GetContactMsgs];
        });
    }
    
    return;
}

#pragma mark 交流信息发送
-(BOOL)sentContactMsg:(NSString *)contactid body:(NSString *)body
{
    [self cancel];
    _status = Classrequestoperator_SendContactMsgs;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    NSMutableArray *postArray = [NSMutableArray array];
    // sessionkey
    [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    // contactid
    [postArray addObject:[self.requestOperator buildPostParam:Contact_Id content:contactid]];
    // body
    [postArray addObject:[self.requestOperator buildPostParam:SendContactmsg_Body content:body]];
    return [self.requestOperator sendSinglePost:SendContactMsgs_Path paramArray:postArray];
}
-(void)handleSentContctMsgs:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate operateFinish:nil requestType:Classrequestoperator_SendContactMsgs];
    });
    return;
}
#pragma mark 获取系统信息列表
-(BOOL)getSysMsgs:(NSInteger)lastupid
{
    [self cancel];
    _status = ClassRequestOperator_GetSysMsgs;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    NSString* nslastupid = [NSString stringWithFormat:@"%d",lastupid];
    
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sessionKey,SESSION_KEY,
                                      nslastupid,GetSysMsgs_LastupId,nil];
    return [self.requestOperator sendSingleGet:GetSysMsgs_Path paramDict:paramDict];
}
-(void)handleGetSysMsgs:(id)data
{
    if(data == nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetSysMsgs];
        });
    }
    
    //当前条数
    int curCount = [[data objectForKey:CurrentCount] intValue];
    //剩余条数
    int retCount = [[data objectForKey:RetCount] intValue];
    _lastupId = 0;
    id foundValue = [data objectForKey:SysMsgsItems];
    if(foundValue != nil && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSArray class]])
    {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            int i = 0;
            for(NSDictionary* dict in (NSArray*)foundValue)
            {
                NSInteger lastupId = [[SystemMessage idWithDict:dict] intValue];
                if(_lastupId<lastupId)
                    _lastupId = lastupId;
                //保存
               SystemMessage* sysmsg = [SystemMessageDataManager messageWithDict:dict];
               sysmsg.user = LoginManagerInstance().accountName;
                i++;
            }
            [CoreDataManager saveData];
            //[delegate operateFinish:[NSNumber numberWithInt:i] requestType:ClassRequestOperator_GetSysMsgs];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetSysMsgs];
        });
    }
    
    //补取或返回
    dispatch_async(dispatch_get_main_queue(), ^{
        if(retCount > 0)
        {
            [self getSysMsgs:_lastupId];
            [delegate updatedData:curCount requestType:ClassRequestOperator_GetSysMsgs];
        }
        else
            [delegate operateFinish:[NSNumber numberWithInteger:curCount] requestType:ClassRequestOperator_GetSysMsgs];
        
    });

    
    return;
}

#pragma mark  获取系统消息内容
-(BOOL)getSysMsgContent:(NSString*)sysmsgid
{
    [self cancel];
    _status = ClassRequestOperator_GetSysMsgContent;
    self.requestOperator.paramOperation = sysmsgid;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sessionKey,SESSION_KEY,
                                      sysmsgid,SysMsg_Id,
                                      nil];
    return [self.requestOperator sendSingleGet:GetSysMsgContent_Path paramDict:paramDict];
}
-(void)handleGetSysMsgContent:(id)data
{
    if(data != nil && [NSNull null] != data && [data isKindOfClass:[NSDictionary class]])
    {
         dispatch_async(dispatch_get_main_queue(), ^{
            //[SystemMessageDataManager messageWithId:self.requestOperator.paramOperation];
             [SystemMessageDataManager messageWithDict:data];
            [CoreDataManager saveData];
             [delegate operateFinish:nil requestType:ClassRequestOperator_GetSysMsgContent];
         });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:ClassRequestOperator_GetSysMsgContent];
        });
    }
    return;
}

#pragma mark  获取最新我的班级信息
-(BOOL)getEventModuleInfoList{
    [self cancel];
    _status = ClassRequestOperator_GetEventModuleInfoList;
    NSMutableDictionary* paramDict = [NSMutableDictionary  dictionary];
    LoginManager* loginmanager = LoginManagerInstance();
    if(loginmanager.loginStatus != LoginStatus_online)
        return NO;
    [paramDict setObject:loginmanager.sessionKey forKey:SESSION_KEY];
    
    return [self.requestOperator sendSingleGet:GetEventModuleInfoList paramDict:paramDict];
}
-(void)handleGetEventModuleInfoList:(id)data{
    // 清除本地
    [ClassDataManager removeAllCategoryLasUpdate];
    
    if([data isKindOfClass:[NSDictionary class]])
    {
        // 我的校园
        id eventModules = [data objectForKey:EventModuleItems];
        if([eventModules isKindOfClass:[NSArray class]])
        {
            for(NSDictionary* dict in(NSArray*)eventModules)
            {
                id type = [dict objectForKey:@"type"];
                id title = [dict objectForKey:@"title"];
                id lastupdate = [dict objectForKey:@"lastupdate"];
                id unreadcount = [dict objectForKey:@"unreadcount"];
                ClassEventCategory *category = [ClassDataManager queryCategaoryWithId:(NSString*)type];
                if(category)
                {
                    //title
                    if([title isKindOfClass:[NSString class]])
                        category.titleofLastEvent = title;
                    //lastupdate
                    double time = 0;
                    if([lastupdate isKindOfClass:[NSNumber class]]){
                        time = [lastupdate doubleValue];
                    }
                    //unreadcount
                    if([unreadcount isKindOfClass:[NSNumber class]]){
                        //count = [unreadcount intValue];
                        category.unreadcount = unreadcount;
                    }
                    
                    category.modulesname = EVENTMODULES;
                    category.lastUpdateChannel = [NSDate dateWithTimeIntervalSince1970:time];
                    [CoreDataManager saveData];
                }
            }
        }
        //已发模块
        id sendeventmodules = [data objectForKey:SentEventModule];
        if([sendeventmodules isKindOfClass:[NSDictionary class]])
        {
            id title = [sendeventmodules objectForKey:@"title"];
            id lastupdate = [sendeventmodules objectForKey:@"lastupdate"];
            id unreadcount = [sendeventmodules objectForKey:@"unreadcount"];
            ClassEventCategory *category = [ClassDataManager queryCategaoryWithId:SENTEVENTMODULE];
            if(category)
            {
                //titleofLastEvent
                if([title isKindOfClass:[NSString class]])
                    category.titleofLastEvent = title;
                //lastupdate
                double time = 0;
                if([lastupdate isKindOfClass:[NSNumber class]]){
                    time = [lastupdate doubleValue];
                }
                //unreadcount
                if([unreadcount isKindOfClass:[NSNumber class]]){
                    //count = [unreadcount intValue];
                    category.unreadcount = unreadcount;
                }
                
                //categoryTitle
                category.title = NSLocalizedString(@"ClassCategorySendTitle", nil);
                
                //logo
                ClassFile *file = [ClassDataManager fileWithUrl:ClassSentEventImage isLocal:YES];
                category.logoImage = file;
                
                category.modulesname = SENTEVENTMODULE;
                category.lastUpdateChannel = [NSDate dateWithTimeIntervalSince1970:time];
                [CoreDataManager saveData];
            }
        }
        
        //系统消息
        id sysmsgmodules = [data objectForKey:SysMsgModule];
        if([sysmsgmodules isKindOfClass:[NSDictionary class]])
        {
            id title = [sysmsgmodules objectForKey:@"title"];
            id lastupdate = [sysmsgmodules objectForKey:@"lastupdate"];
            id unreadcount = [sysmsgmodules objectForKey:@"unreadcount"];
            ClassEventCategory *category = [ClassDataManager queryCategaoryWithId:SYSMSGMODULE];
            if(category)
            {
                //titleofLastEvent
                if([title isKindOfClass:[NSString class]])
                    category.titleofLastEvent = title;
                //lastupdate
                double time = 0;
                if([lastupdate isKindOfClass:[NSNumber class]]){
                    time = [lastupdate doubleValue];
                }
                //unreadcount
                if([unreadcount isKindOfClass:[NSNumber class]]){
                    //count = [unreadcount intValue];
                    category.unreadcount = unreadcount;
                }
                
                //categoryTitle
                category.title = NSLocalizedString(@"ClassCategorySysinfoTitle", nil);
                
                ClassFile *file = [ClassDataManager fileWithUrl:ClassSystemImage isLocal:YES];
                category.logoImage = file;
                
                category.modulesname = SYSMSGMODULE;
                category.lastUpdateChannel = [NSDate dateWithTimeIntervalSince1970:time];
                [CoreDataManager saveData];
            }
        }
        
        //交流
        id contactmodules = [data objectForKey:ContactModule];
        if([contactmodules isKindOfClass:[NSDictionary class]])
        {
            id title = [contactmodules objectForKey:@"title"];
            id lastupdate = [contactmodules objectForKey:@"lastupdate"];
            id unreadcount = [contactmodules objectForKey:@"unreadcount"];
            ClassEventCategory *category = [ClassDataManager queryCategaoryWithId:FACE2FACEMOUDLE];
            if(category)
            {
                //titleofLastEvent
                if([title isKindOfClass:[NSString class]])
                    category.titleofLastEvent = title;
                //lastupdate
                double time = 0;
                if([lastupdate isKindOfClass:[NSNumber class]]){
                    time = [lastupdate doubleValue];
                }
                //unreadcount
                if([unreadcount isKindOfClass:[NSNumber class]]){
                    //count = [unreadcount intValue];
                    category.unreadcount = unreadcount;
                }

                category.lastUpdateChannel = [NSDate dateWithTimeIntervalSince1970:time];
                [CoreDataManager saveData];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
                   [delegate operateFinish:nil requestType:ClassRequestOperator_GetEventModuleInfoList];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:@"parse error" requestType:ClassRequestOperator_GetEventModuleInfoList];
        });
    }
    return;

}

#pragma mark 获取收藏班级信息
- (BOOL)getBookmarkEvent:(NSInteger)lastUpdate {
    [self cancel];
    _status = ClassRequestOperator_GetBookmarkEvent;
    
    NSString *paramString = @"";
    NSMutableDictionary* paramDict = [NSMutableDictionary  dictionary];
    LoginManager* loginmanager = LoginManagerInstance();
    if(loginmanager.sessionKey.length > 0) {
        [paramDict setObject:loginmanager.sessionKey forKey:SESSION_KEY];
    }
    
    paramString = [NSString stringWithFormat:@"%d", lastUpdate];
    [paramDict setObject:paramString forKey:LastUpdate];
    
    return [self.requestOperator sendSingleGet:GetClassFavorite paramDict:paramDict];
}
- (void)handleGetBookmarkEvent:(id)data {
    if(nil != data && [NSNull null] != data && [data isKindOfClass:[NSDictionary class]]) {
        id foundValue = [data objectForKey:FavoriteItems];
        if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSArray class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NSDictionary *dict in foundValue) {
                    [ClassDataManager eventWitdhFavourDict:dict];
                }
                [CoreDataManager saveData];
                [delegate operateFinish:nil requestType:ClassRequestOperator_GetBookmarkEvent];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate operateFinish:nil requestType:ClassRequestOperator_GetBookmarkEvent];
            });
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:PARSE_FAIL requestType:ClassRequestOperator_GetBookmarkEvent];
        });
    }
}
#pragma mark 提交收藏班级信息
- (BOOL)submitBookmarkEvent:(NSArray *)items {
    [self cancel];
    _status = ClassRequestOperator_SubmitBookmarkEvent;
    
    NSMutableArray *postArray = [NSMutableArray array];
    NSString *paramString = @"";
    
    // sessionkey
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0) {
        sessionKey = loginmanager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    
    // 收藏状态列表
    NSMutableArray *favourStatusArray = [NSMutableArray array];
    for(ClassEvent *item in items) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        // 通告id
        [dict setObject:item.event_id forKey:EventId];
        
        // 状态（新增：N，删除：C）
        if([item.bookmarked boolValue]) {
            paramString = FavourBookmark;
        }
        else {
            paramString = FavourUnBookmark;
        }
        
        [dict setObject:paramString forKey:SubmitClassFavourStatus];
        [favourStatusArray addObject:dict];
    }
    SBJSON *json = [[[SBJSON alloc] init] autorelease];
    [postArray addObject:[self.requestOperator buildPostParam:SubmitClassFavourListParam content:[json stringWithObject:favourStatusArray error:nil]]];
    
    return [self.requestOperator sendSinglePost:SubmitClassFavorite paramArray:postArray];
}
- (void)handleSubmitBookmarkEvent:(id)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate operateFinish:nil requestType:ClassRequestOperator_SubmitBookmarkEvent];
    });

}
#pragma mark 提交班级回评
- (BOOL)submitEventReview:(NSArray *)items eventID:(NSString *)eventID {
    [self cancel];
    _status = ClassRequestOperator_SubmitClassEventReview;
    
    NSMutableArray *postArray = [NSMutableArray array];
    
    // sessionkey
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0) {
        sessionKey = loginmanager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    
    if(eventID.length > 0) {
        [postArray addObject:[self.requestOperator buildPostParam:EventId content:eventID]];
    }
    
    // 回评列表
    NSMutableArray *favourStatusArray = [NSMutableArray array];
    for(ReviewDraft *item in items) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        // id
        if(item.itemID.length > 0) {
            [dict setObject:item.itemID forKey:SubmitClassReviewID];
        }
        // type（text：字符，count：数值）
        if(item.type.length > 0) {
            [dict setObject:item.type forKey:SubmitClassReviewType];
        }
        // value
        if(item.value.length > 0) {
            [dict setObject:item.value forKey:SubmitClassReviewValue];
        }

        [favourStatusArray addObject:dict];
    }
    
    
    SBJSON *json = [[[SBJSON alloc] init] autorelease];
    [postArray addObject:[self.requestOperator buildPostParam:SubmitClassReviewParm content:[json stringWithObject:favourStatusArray error:nil]]];
    
    return [self.requestOperator sendSinglePost:SubmitClassReview paramArray:postArray];
}
- (void)handleSubmitEventReview:(id)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate operateFinish:nil requestType:ClassRequestOperator_SubmitClassEventReview];
    });
}
#pragma mark - Http回调 (HttpClientDelegate)
- (void)requestFinish:(id)json
{
    ClassRequestOperatorStatus status = _status;
    _status = ClassRequestOperator_None;
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    switch (status) {
        case ClassRequestOperator_GetEventList:{
            [self handleGetEventList:json];
            break;
        }
        case ClassRequestOperator_GetEventDetail:{
            [self handleGetEventDetail:json];
            break;
        }
        case ClassRequestOperator_GetSentEventList:{
            [self handleGetSentEventList:json];
            break;
        }
        case ClassRequestOperator_GetSentEventDetail:{
            [self handleGetSentEventDetail:json];
            break;
        }
        case ClassRequestOperator_GetEventReadInfo:{
            [self handleGetEventReadInfo:json];
            break;
        }
        case ClassRequestOperator_SubmitClassEvent:{
            [self handleSubmitClass:json];
            break;
        }
        case ClassRequestOperator_DelSendEvent:
        {
            [self handleDelSendEvent:json];
            break;
        }
//        case ClassRequestOperator_GetOrgInfo: {
//            [self handleGetOrgInfo:json];
//            break;
//        }
//        case ClassRequestOperator_GetOrganization:{
//            [self handleGetOrgnization:json];
//            break;
//        }
//        case ClassRequestOperator_GetParentOrganization:{
//            [self handleGetParentOrgnization:json];
//            break;
//        }
//            case ClassRequestOperator_AutoAnswer:{
//                [self handleGetAnswerList:json];
//                break;
//            }
//            case ClassRequestOperator_BatAutoAnswer:{
//                [self handleGetAnswerContent:json];
//                break;
//            }
        case ClassRequestOperator_GetAwsContent:{
            [self handleGetAnswerContent:json];
            break;
        }
        case ClassRequestOperator_GetAwsContentSent:{
            [self handleGetAnswerContentSent:json];
            break;
        }
        case ClassRequestOperator_SentAnswer:{
            [self handleSentAnswer:json];
            break;
        }
        case ClassRequestOperator_GetContactList:{
            [self handleGetContactList:json];
            break;
        }
        case ClassRequestOperator_GetContactMsgs:{
            [self handleGetContactMsgs:json];
            break;
        }
        case Classrequestoperator_SendContactMsgs:{
            [self handleSentContctMsgs:json];
            break;
        }
        case ClassRequestOperator_GetSysMsgs:{
            [self handleGetSysMsgs:json];
            break;
        }
        case ClassRequestOperator_GetSysMsgContent:{
            [self handleGetSysMsgContent:json];
            break;
        }
        case ClassRequestOperator_GetEventModuleInfoList:{
            [self handleGetEventModuleInfoList:json];
            break;
        }
        case ClassRequestOperator_GetBookmarkEvent:{
            [self handleGetBookmarkEvent:json];
            break;
        }
        case ClassRequestOperator_SubmitBookmarkEvent:{
            [self handleSubmitBookmarkEvent:json];
            break;
        }
        case ClassRequestOperator_SubmitClassEventReview:{
            [self handleSubmitEventReview:json];
            break;
        }
        default:break;
    }
    [pool drain];
    
    
}
- (void)requestFail:(NSString*)error {
    // 网络请求失败
    dispatch_async(dispatch_get_main_queue(), ^{
        if(delegate) {
            if([delegate respondsToSelector:@selector(operateFail:requestType:)]){
                [delegate operateFail:error requestType:_status];
            }
        }
    });
}
@end
