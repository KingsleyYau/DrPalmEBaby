//
//  ClassDataManager.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"

#import "CustomClassEventCategory.h"
#import "CustomClassEvent.h"
#import "CustomClassEventReviewTemp.h"
#import "CustomClassEventSent.h"
#import "CustomClassAnwserMan.h"
#import "CustomClassAnwserSender.h"
#import "CustomClassAnwserContent.h"
#import "CustomClassImage.h"
#import "CustomClassFile.h"
#import "CustomClassOrg.h"
#import "ClassEventDraft.h"
#import "ClassEventDraftAttachment.h"
#import "ClassUserTopOrg.h"
#import "ClassUnRead.h"
#import "ClassOrg.h"
typedef enum {
    EventStatusType_Cancel,
    EventStatusType_Add,
    EventStatusType_Normal
}EventStatusType;

typedef  enum{
    AccountType_Student = 1,
    AccountType_Teacher = 2
}AccountType;

@interface ClassDataManager : NSObject
#pragma mark - 通告分类模块 (ClassEventCategory)
#pragma mark 初始化本地分类
+ (NSArray *)staticCategory;
#pragma mark 获取我的班级分类
+ (NSArray *)categoryList;
#pragma mark 在最新界面显示的分类（参数,帐号类型）
+ (NSArray*)showInLatestArray:(AccountType)accType;
#pragma mark 获取所有分类（包括已发，系统消息）
+ (NSArray *)allcategoryList;
#pragma mark 获取可发送的分类
+ (NSArray *)canSendcategoryList;
#pragma mark 获取所有分类按最后更新排序
+ (NSArray *)categoryListByLastUpdate;
#pragma mark 获取所有可发送分类
+ (NSArray *)categoryListCanSend;
#pragma mark 查找和添加分类(查找不到则添加)
+ (ClassEventCategory *)categaoryWithId:(NSString *)newCategory;
#pragma mark 查找分类(只查找)
+ (ClassEventCategory *)queryCategaoryWithId:(NSString *)categoryId;

#pragma mark - 通告模块 -- (ClassEvent)
#pragma mark 获取最后更新的通告
+ (ClassEvent *)eventLastUpdate;
#pragma mark 获取最后阅读的通告
+ (ClassEvent *)eventLastRead;
#pragma mark 获取所有通告
+ (NSArray *)eventList;
#pragma mark 按分类查询通告
+ (NSArray *)eventListWithCatalog:(NSString *)catID;
#pragma mark 查询最后阅读通告时间
+(NSDate*)lastReadTimeWithCatalog:(NSString *)catID;
#pragma mark 查询最后更新通告时间 
+(NSDate*)lastupdateWithCatalog:(NSString *)catID;
#pragma mark (收藏/取消收藏)指定通告
+ (void)bookmarkEvent:(NSString *)itemID bookmark:(BOOL)bookmark;
#pragma mark 按分类查询已经收藏通告
+ (NSArray *)eventWithBookmark;
+ (NSArray *)eventWithBookmark:(NSString *)catID;
#pragma mark 查询需要向服务器同步的已改变收藏状态通告
+ (NSArray *)eventListWithBookmarkSynchronize;
#pragma mark 取消收藏状态
+ (void)cancelEventListWithBookmarkSynchronize;
#pragma mark 查询最后同步的收藏通告
+ (ClassEvent *)eventLastSynchronize;
#pragma mark 按分类自定义查询通告
+ (NSArray *)eventWithSearchString:(NSString *)query;
#pragma mark 按分类和起始结束日期查询通告
+ (NSArray *)eventsWithStartEndDate:(NSDate *)startDate end:(NSDate *)endDate catID:(NSString *)catID;
#pragma mark 通告是否存在
+ (BOOL)eventIsExist:(NSString *)eventId;
#pragma mark 查询指定通告
+ (ClassEvent *)eventWithId:(NSString *)eventId;
#pragma mark 添加一条通告 
+ (ClassEvent *)eventInsertWithId:(NSString *)eventId;
+ (ClassEvent *)eventWitdhDict:(NSDictionary *)dict;
+ (ClassEvent *)eventWitdhFavourDict:(NSDictionary *)dict;


#pragma mark 查找是否有通告是通过取收藏列表刷下来的
+(BOOL)hasEventGetByBookMark;

#pragma mark - 已发通告模块 (ClassEventSent)
#pragma mark 获取已发通告lastupdate
+ (NSDate*)getSentListLastupdate;
#pragma mark 查询已发通告
+ (NSArray *)eventSentList;
#pragma mark 已发通告是否存在
+ (BOOL)eventSentIsExist:(NSString *)eventId;
#pragma mark 查询指定已发通告
+ (ClassEventSent *)eventSentWithId:(NSString *)eventId;
#pragma mark 添加一已发条通告
+ (ClassEventSent *)eventSentWitdhDict:(NSDictionary *)dict;
#pragma mark 按发送日期查询已发通告
+ (NSArray*)eventSentListWithPostDate:(NSDate*)startPostDate endPostDate:(NSDate*)endPostDate;

#pragma mark 删除已发通告
+ (void)delSentEventById:(NSString*)eventId;


#pragma mark 获取通告回评模板
+ (ClassEventReviewTemp *)reviewTempWithIdEventId:(NSString *)itemID eventId:(NSString *)eventId;
+ (ClassEventReviewTemp *)reviewTempInsertWithIdEventId:(NSString *)itemID eventId:(NSString *)eventId;
+ (ClassEventReviewTemp *)reviewTempInsertWithDictEventId:(NSDictionary *)dict eventId:(NSString *)eventId;
+ (NSArray *)reviewTempWithEventID:(NSString *)eventID;

#pragma mark - 反馈模块 (ClassAnwserMan/ClassAnwserContent)
#pragma mark 按通告查反馈人列表
+ (NSArray *)anwserListWithEventId:(NSString *)eventId;
#pragma mark 按已发通告查反馈人列表
+ (NSArray *)anwserListWithEventSentId:(NSString *)eventId;
#pragma mark 查询自己与指定反馈人指定通告对话内容
+ (NSArray *)anwserContentListWithEventId:(NSString *)anwserManId eventId:(NSString *)eventId;
#pragma mark 查询自己与指定反馈人指定已发通告对话内容
+ (NSArray *)anwserContentListWithEventSentId:(NSString *)anwserManId eventId:(NSString *)eventId;
#pragma mark 查询自己与指定反馈人所有对话内容
+ (NSArray *)anwserContentListAll:(NSString *)anwserManId;

#pragma mark 查询指定通告是否有新反馈
+ (BOOL)hasAnwserWithEventId:(NSString *)eventId;
#pragma mark 查询自己与指定反馈人指定通告对话内容的最后时间
+ (NSDate *)lastAnwsWithEventId:(NSString *)anwserManId eventId:(NSString *)eventId;
#pragma mark 查询指定已发通告是否有新反馈
+ (BOOL)hasAnwserWithEventSentId:(NSString *)eventSentId;
#pragma mark 查询已发通告自己与指定反馈人否有新反馈
+ (BOOL)hasAnwserWithAnwserManIdEventSentId:(NSString *)anwserManId eventSentId:(NSString *)eventSentId;
#pragma mark 查询自己与指定讨论组指定已发通告对话内容的最后时间
+ (NSDate *)lastAnwsWithEventSentId:(NSString *)anwserManId eventId:(NSString *)eventId;

#pragma mark 按通告添加一个讨论组
+ (ClassAnwserMan *)anwserManWithIdEventId:(NSString *)anwserManId eventId:(NSString *)eventId;
+ (ClassAnwserMan *)anwserManWithDictEventId:(NSDictionary *)dict eventId:(NSString *)eventId;
#pragma mark 讨论组成员
+ (ClassAnwserSender *)anwserSenderWithId:(NSString *)itemID;
+ (ClassAnwserSender *)anwserSenderInsertWithId:(NSString *)itemID;
+ (ClassAnwserSender *)anwserSenderWithDict:(NSDictionary *)dict;

#pragma mark 按已发通告添加一个讨论组
+ (ClassAnwserMan *)anwserManWithIdEventSentId:(NSString *)anwserManId eventId:(NSString *)eventId;
+ (ClassAnwserMan *)anwserManWithDictEventSentId:(NSDictionary *)dict eventId:(NSString *)eventId;
#pragma mark 添加一条通告讨论组内容
+ (ClassAnwserContent *)anwserContentWithDict:(NSDictionary *)dict anwserManId:(NSString *)anwserManId eventId:(NSString *)eventId;
#pragma mark 添加一条已发通告讨论组内容
+ (ClassAnwserContent *)anwserContentWithDictSent:(NSDictionary *)dict anwserManId:(NSString *)anwserManId eventId:(NSString *)eventId;


#pragma mark 获取附件
+ (NSArray *)filesWithClassEventId:(NSString *)eventId;
+ (NSArray *)filesWithClassEventSentId:(NSString *)eventId;

#pragma mark - 文件与图片模块 (ClassFile/ClassImage)
#pragma mark 插入文件
+ (ClassFile *)fileWithUrl:(NSString *)url isLocal:(Boolean)isLocal;
#pragma mark 插入图片
+ (ClassImage *)imageWithImageFullUrl:(NSString *)url isLocal:(Boolean)isLocal;
+ (ClassImage *)imageWithImageDict:(NSDictionary *)dict isLocal:(Boolean)isLocal;

#pragma mark - 组织架构(ClassOrg, ClassUserTopOrg)
#define OrgTopDefaultValue  @"0" // 组织结构顶层默认id
+ (ClassUserTopOrg*)getUserTopOrg;
+ (void)updateUserTopOrgWithOrgIDs:(NSArray*)orgIDs;
+ (NSArray *)topLevelOrgs;
+ (NSArray *)suborgsWithParentOrgID:(NSString*)orgID;
+ (ClassOrg *)orgWithDict:(NSDictionary *)dict;
+ (ClassOrg *)orgWithDict:(NSDictionary*)dict parentId:(NSString *)parentId;
//+ (ClassOrg *)orgWithDict:(NSDictionary*)dict subId:(NSString *)subId;
+ (ClassOrg *)orgWithID:(NSString *)orgID;
+ (NSDate *)getOrgLastupdate;
+ (void)removeAllOrg;
+ (void)createOrgPath;
+ (void)countLeafOrg;
+ (NSInteger)getLeafOrgNumberWithOrg:(ClassOrg*)org;
+ (NSArray*)getLeafOrgWithOrg:(ClassOrg*)org;

#pragma mark - 草稿(ClassEventDraft)
+ (void)insertEventDraft;
+ (ClassEventDraft *)lastEventDraft;
+ (NSArray*)getEventDrafts;
+ (void)removeEventDraft:(ClassEventDraft*)draft;
+ (void)removeEventDraftAttachment:(ClassEventDraft*)eventDraft;

#pragma mark - 草稿附件(ClassEventDraftAttachment)
+ (ClassEventDraftAttachment*)draftAttachmentWithDraftAndUrl:(ClassEventDraft*)eventDraft url:(NSString*)url;
+ (void)removeDraftAttachment:(ClassEventDraftAttachment*)draftAttachment;

#pragma mark - Event状态转换
+ (EventStatusType)eventStatusTypeWithStatusString:(NSString*)eventStatus;
+ (NSString*)StatausStringWithEventStatusType:(EventStatusType)eventStatus;

#pragma mark 未读通告
+ (void)setUnReadCount:(NSInteger)count;
+ (NSInteger)getUnReadCount;

//删除
+ (void)removeAllEvents:(BOOL)withoutBookMark;
#pragma mark 清除所有分类最后更新时间
+ (void)removeAllCategoryLasUpdate;
@end
