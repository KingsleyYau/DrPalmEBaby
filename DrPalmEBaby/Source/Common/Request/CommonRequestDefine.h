//
//  CommonRequestDefine.h
//  DrPalm
//
//  Created by KingsleyYau on 12-11-20.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#ifndef DrPalm_CommonRequestDefine_h
#define DrPalm_CommonRequestDefine_h

#pragma mark - 协议
#define MARKET_ID       @"market_id"
#define SCHOOLID        @"schoolid"
#define SESSION_KEY     @"sessionkey"
#define TOKENID         @"tokenid"

#define OPCODE          @"code"
#define OPRET           @"opret"
#define OPFLAG          @"opflag"
#define OPSUCCESS       @"1"
#define OPFAIL          @"0"

#pragma mark － 错误提示
#define PARSE_FAIL      @"0" // 解析错误

//getCliPkg
#define GetCliPkg_Path         @"getclipkg"
#define GetCliPkg_LastMDate    @"lastmdate"
#define GetCliPkg_NumNo        @"numno"
#define NumNoType_Iphone       @"10"

#define PACKETDATA       @"packet"
#define TIMESTAMPPARAM   @"lastmdate"


#define GETPWDDATA       @"getpwd"
#define GETPWDURL        @"url"
#define RESLIST          @"reslist"


//login
#define Login_Path             @"login"
#define Login_UserName         @"userid"
#define Login_Pwd              @"pwd"
#define Login_DeviceToken      @"devicetoken"
#define Login_DeviceType       @"devicetype"
#define DeviceType_IPhone      @"10"

#define Logout_Path            @"logout"

//SetUserMail
#define SetUserMail_Path       @"setusermail"
#define SetUserMail_Mail       @"mail"

//SetPushInfo
#define SetPushInfo_Path       @"pushinfo/"
#define IfPush                 @"ifpush"
#define IfSound                @"ifsound"
#define IfShake                @"ifshake"
#define PushTime               @"pushtime"
#define Start                  @"start"
#define End                    @"end"


//SubmitProblem
#define SubmitProblem_Path     @"submitproblem.php"
#define SubmitProblem_Problem  @"problem"
#define SubmitProblem_Suggestion  @"suggestion"

//GetNewInfoList
#define GetNewInfoList_Path     @"getnewinfolist"
#define StoryItems              @"stories"
#define EventsItems             @"events"

//GetLastUpdate
#define GetLastUpdate_Path          @"getlastupdate"
#define LastUpdate_News             @"news"
#define LastUpdate_Event            @"event"
#define UnReadCount                 @"unreadcount"
#define UnReadCount_SentEvent       @"sentevent"
#define UnReadCount_Sysmsg          @"sysmsg"
#define UnReadCount_Contact         @"contact"
#define UnReadCount_Ebabychannel    @"ebabychannel"

//GetAccountInfo
#define GetAccountInfo_Path         @"getaccountinfo"
#define LastUpdate_Param            @"lastupdate"

//SubmitAccountInfo
#define SubmitAccountInfo_Path      @"submitaccountinfo"


//GetGrowDiary
#define GetGrowDiary_Path           @"getgrowdiary"
#define GrowDiaryList               @"diarylist"

//SubmitGrowDiary
#define SubmitGrowDiary_Path        @"submitgrowdiary"
#define DiaryId                     @"diaryid"
#define Title                       @"title"
#define Content                     @"contect"
#define Status                      @"status"
#define Param                       @"param"

#define OperateStatus_New  @"N"
#define OperateStatus_Del  @"C"
#define OperateStatus_Modify  @"M"

//GetUserAlbum
#define GetUserAlbum_Path           @"getuseralbum"
#define AlbumList                   @"albumlist"

//SubmitUserAlbum
#define SubmitUserAlbum_Path        @"submituseralbum"
#define ImageId                     @"imgid"
#define FileName                    @"filename"
#define Description                 @"des"


#endif
