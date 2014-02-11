//
//  ClassModuleDefine.h
//  DrPalm
//
//  Created by drcom on 13-1-14.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#ifndef DrPalm_ClassModuleDefine_h
#define DrPalm_ClassModuleDefine_h

#define EventId                @"eventid"
#define EventIds               @"eventids"

#define AllField               @"allfield"
#pragma mark GetEventList
#define GetEventList_Path       @"geteventlist"
#define GetEventList_Type       @"type"
#define LastUpdate              @"lastupdate"
#define LastReadTime            @"lastreadtime"
#define CurrentCount            @"curcount"    //当前条数
#define RetCount                @"retcount"    //剩余条数
#define EventListItems          @"eventlist"
#define AllSentEvent_Type       @"0"           // 所有已发通告类型id

#define Events_Type             @"type"
#define Events_OriEventsId      @"orieventid"
#define Events_OriStatus        @"oristatus"
#define Events_PubId            @"pubid"
#define Events_PubName          @"pubname"
#define Events_PostDate         @"post"
#define Events_Start            @"start"
#define Events_End              @"end"
#define Events_Status           @"status"
#define Events_Ifeshow          @"ifeshow"
#define Events_IsReadforServer  @"isread"
#define Events_Title            @"title"
#define Events_Location         @"location"
#define Events_Locationurl      @"locationurl"
#define Events_Cancelled        @"cancelled"
#define Events_Thumburl         @"thumburl"
#define Events_Lastawstime      @"lastawstime"
#define Events_AwsCount         @"awscount"
#define Events_LastawsId        @"lastawsuserid"
#define Events_Lastupdate       @"lastupdate"
#define Events_LastReadTime     @"lastreadtime"
#define Events_Hasatt           @"hasatt"
#define Events_OwnerId          @"ownerid"
#define Events_Owner            @"owner"
#define Events_AwsOrgList       @"awsorglist"
#define Events_Attachs          @"atts"
#define Events_AttachDes        @"attdes"
#define Events_AttachId         @"attid"
#define Events_Body             @"body"
#define Events_CleanBody        @"cleanbody"
#define Events_Summary          @"summary"
#define Events_AttSize          @"attsize"
#define Events_NeedReview       @"needreview"
#define Events_ReviewTemp       @"reviewtemp"

#define Events_ReadCount          @"readcount"
#define Events_ReadTotal          @"readtotal"
#define Events_RecvTotal          @"recvtotal"
#define Events_SentTotal          @"senttotal"

#pragma mark GetEventDetail
#define GetEventsDetail_Path    @"geteventcontent"

#define GetSentEventsList_Path  @"getsenteventlist"
#define GetSentEventsDetail_Path @"getsenteventcontent"

#pragma mark GetEventReadInfo
#define GetEventReadInfo_Path   @"geteventreadinfo"
#define GetEventReadInfo_ReadList    @"readlist"
#define GetEventReadInfo_UnreadList  @"unreadlist"
#define GetEventReadInfo_Name        @"name"

#pragma mark submitevent
#define SubmitClassEvent_Path   @"submitevent/"
#define SubmitEvent_OwnerId     @"ownerid"
#define SubmitEvent_Owner       @"owner"
#define SubmitEvent_Title       @"title"
#define SubmitEvent_Body        @"body"
#define SubmitEvent_Ifeshow     @"ifeshow"
#define SubmitEvent_Location    @"location"
#define SubmitEvent_LocUrl      @"locationurl"
#define SubmitEvent_Type        @"type"
#define SubmitEvent_Start       @"start"
#define SubmitEvent_End         @"end"
#define SubmitEvent_OriEventsId @"id"
#define SubmitEvent_Oristatus   @"oristatus"
#define SubmitEvent_Thumbname   @"thumbname"
#define SubmitEvent_Attachment  @"filedes"
#define SubmitEvent_Item        @"item"
#define SubmitEvent_FileTitle   @"filetitle"
#define SubmitEvent_FileFrom    @"filefrom"
#define SubmitEvent_AttachType  @"type"
#define SubmitEvent_FileType    @"file"
#define SubmitEvent_IdType      @"id"

#define DelSendEvent_Path   @"delevent"



#pragma mark GetOrgnization
#define GetOrgInfo_Path         @"getorginfo"
#define GetOrgInfo_Lastupdate   @"lastupdate"
#define GetOrgInfo_SelfOrgid    @"selforgid"
#define GetOrgInfo_OrgList      @"orglist"
#define GetOrgInfo_ID           @"id"
#define GetOrgInfo_Name         @"name"
#define GetOrgInfo_Type         @"type"
#define GetOrgInfo_Status       @"status"
#define GetOrgInfo_PID          @"pid"
#define GetOrgInfo_URL          @"url"
#define GetOrgInfo_CheckSum     @"checksum"
#define GetOrgInfo_TopOrgs      @"toporgs"
#define GetOrgInfo_TopOrgID     @"orgid"
#define GetOrgInfo_OrgMemberType        @"member"
#define GetOrgInfo_OrgGroupType         @"group"

#pragma mark GetParentOrgnization
#define GetParentOrgnization_Path @"userownorgsinfo"

#pragma mark AutoAnawer
#define AutoAnswer_Path         @"autoaws"
#define BatAutoAnswer_Path      @"bataws"

#pragma mark GetAnswerList
#define GetAnswerList_Path      @"getawslist"

#define GetAnswerContent_Path   @"getaws"
#define AswPubid                @"aswpubid"
#define BeginTime               @"begintime"

#define AwsListItems            @"awslist"

#pragma mark SentAnswer
#define SentAnswer_Path         @"aws/"
#define AwsPubId                @"aswpubid"
#define SentAnswer_Body         @"body"

#pragma mark GetContactList
#define GetContactList_Path     @"getcontactlist"
#define ContactListItem         @"contacts"
#define CommuList               @"clist"
#define CommunicateId           @"cid"
#define CommunicateLastUpdate   @"lastupdate"

#pragma mark GetContactMsgs
#define GetContactMsgs_Path     @"getcontactmsgs"
#define Contact_Id              @"cid"
#define GetContactMsgs_Lastupdate @"lastupdate"

#define MsgListItem             @"msglist"

#pragma mark SendContactMsgs
#define SendContactMsgs_Path    @"sendmsg"
#define SendContactmsg_Body     @"body"


#pragma mark GetSysMsgs
#define GetSysMsgs_Path         @"getsysmsgs" 
#define GetSysMsgs_LastupId     @"lastupid"

#define SysMsgsItems            @"sysmsgs"

#pragma mark GetSysMsgContent
#define GetSysMsgContent_Path   @"getsysmsgcontent"
#define SysMsg_Id               @"sysmsgid"

#pragma mark GetEventModuleInfoList
#define GetEventModuleInfoList @"geteventmodulesinfolist"
#define EventModuleItems       @"eventmodules"
#define SentEventModule        @"senteventmodules"
#define SysMsgModule           @"sysmsgmodules"
#define ContactModule          @"contactmodules"

#pragma mark 获取收藏班级信息
#define GetClassFavorite       @"getclassfavorite"
#define FavoriteItems          @"favoritelist"
#define FavourStatus           @"favoritestatus"
#define FavourLastUpdate       @"lastupdate"


#pragma mark 提交收藏班级信息
#define SubmitClassFavorite         @"submitclassfavorite"
#define SubmitClassFavourStatus     @"status"
#define SubmitClassFavourListParam  @"param"

#pragma mark 提交班级回评
#define SubmitClassReview           @"submitclassreview"
#define SubmitClassReviewParm       @"param"
#define SubmitClassReviewID         @"id"
#define SubmitClassReviewType       @"type"
#define SubmitClassReviewValue      @"value"

#endif
