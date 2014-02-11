//
//  ClassRequestOperator.h
//  DrPalm
//
//  Created by JiangBo on 13-1-14.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "RequestOperator.h"
#import "ClassEventDraft.h"

@interface ReviewDraft : NSObject
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *value;
@end

typedef enum{
    ClassRequestOperator_None,
    ClassRequestOperator_GetEventList,
    ClassRequestOperator_GetEventDetail,
    ClassRequestOperator_GetSentEventList,
    ClassRequestOperator_GetSentEventDetail,
    ClassRequestOperator_GetEventReadInfo,
    ClassRequestOperator_SubmitClassEvent,
    ClassRequestOperator_SubmitClassEventReview,
    ClassRequestOperator_DelSendEvent,
//    ClassRequestOperator_GetOrgInfo,
//    ClassRequestOperator_GetOrganization,
//    ClassRequestOperator_GetParentOrganization,
   // ClassRequestOperator_AutoAnswer,
   // ClassRequestOperator_BatAutoAnswer,
    //ClassRequestOperator_GetAwsList,
    ClassRequestOperator_GetAwsContent,
    ClassRequestOperator_GetAwsContentSent,
    ClassRequestOperator_SentAnswer,
    ClassRequestOperator_GetContactList,
    ClassRequestOperator_GetContactMsgs,
    Classrequestoperator_SendContactMsgs,
    ClassRequestOperator_GetSysMsgs,
    ClassRequestOperator_GetSysMsgContent,
    ClassRequestOperator_GetEventModuleInfoList,
    
    ClassRequestOperator_GetBookmarkEvent,
    ClassRequestOperator_SubmitBookmarkEvent,
}ClassRequestOperatorStatus;

@protocol ClassRequestOperatorDelegate <NSObject>

-(void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type;
-(void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type;
@optional
-(void)updatedData:(NSInteger)total requestType:(ClassRequestOperatorStatus)type;
@end

@interface ClassRequestOperator : NSObject <RequestOperatorDelegate> {
    ClassRequestOperatorStatus _status;
    RequestOperator *_requestOperator;
    double   _lastupdatetime;
    double   _lastreadtime;
    NSInteger   _lastupId;
}
@property (nonatomic, assign) id<ClassRequestOperatorDelegate> delegate;
- (void)cancel;
#pragma mark 获取通告列表
-(BOOL)getEventList:(NSString *)type lastupdate:(NSInteger)lastupdate lastReadTime:(NSInteger)lastReadTime;
#pragma mark 获取通告详细
-(BOOL)getEventDetail:(NSString *)eventid isAllField:(BOOL)isAllField;
#pragma mark 获取已发通告列表
-(BOOL)getSentEventList:(NSInteger)lastupdae;
#pragma mark 获取已发通告详细
-(BOOL)getSentEventDetail:(NSString *)eventid;
#pragma mark 获取已读明细信息
-(BOOL)getEventReadInfo:(NSString*)eventid;
#pragma mark 发布通告
-(BOOL)submitClass:(ClassEventDraft*)draft;

#pragma mark 删除已发通告
-(BOOL)delSendEvent:(NSString*)eventId;

#pragma mark 组织结构获取
//- (BOOL)getOrgInfo;
//-(BOOL)getOrganization:(NSString *)orgid start:(NSString*)start;
////上级节点组织结构获取
//-(BOOL)getParentOrganization:(NSArray *)orgids;


//自动回复
//-(BOOL)autoAnswer:(NSString *)eventid;
//批量自动回复
//-(BOOL)batAutoAnswer:(NSString *)eventids;
//获取已发通告的反馈人列表
//-(BOOL)getAnswerList:(NSString *)eventid;
#pragma mark 获取通告某反馈人回复内容
-(BOOL)getAnswerContent:(NSString *)eventid aswpubid:(NSString *)aswpubid lasttime:(NSInteger)lasttime;
#pragma mark 获取已发通告某反馈人回复内容
-(BOOL)getAnswerContentSent:(NSString *)eventid aswpubid:(NSString *)aswpubid lasttime:(NSInteger)lasttime;
#pragma mark 反馈发送
-(BOOL)sentAnswer:(NSString *)eventid awspubid:(NSString*)awspubid body:(NSString *)body;

#pragma mark 获取联系人列表
-(BOOL)getContactList:(NSArray*)items;
#pragma mark 获取联系人交流内容
-(BOOL)getContactMsgs:(NSString *)contactid lastupdate:(NSInteger)lastupdate;
#pragma mark 交流信息发送
-(BOOL)sentContactMsg:(NSString *)contactid body:(NSString *)body;
#pragma mark 获取系统信息列表
-(BOOL)getSysMsgs:(NSInteger)lastupid;
#pragma mark 获取系统消息内容
-(BOOL)getSysMsgContent:(NSString*)sysmsgid;
#pragma mark 获取最新我的班级信息
-(BOOL)getEventModuleInfoList;

#pragma mark 获取收藏班级信息
- (BOOL)getBookmarkEvent:(NSInteger)lastUpdate;
#pragma mark 提交收藏班级信息
- (BOOL)submitBookmarkEvent:(NSArray *)items;
#pragma mark 提交班级回评
- (BOOL)submitEventReview:(NSArray *)items eventID:(NSString *)eventID;
@end
