//
//  CommonRequestOperator.h
//  DrPalm
//
//  Created by JiangBo on 13-1-14.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//
#import "RequestOperator.h"
//#import "GrowDiary.h"
//#import "PrivateAlbum.h"
//#import "PrivateAlbumForSent.h"
#import "CommonRequestDefine.h"

typedef enum{
    CommonRequestOperatorStatus_None,
    CommonRequestOperatorStatus_GetCliPkg,
    CommonRequestOperatorStatus_Login,
    CommonRequestOperatorStatus_Logout,
    CommonRequestOperatorStatus_SetUserMail,
    CommonRequestOperatorStatus_SetPushInfo,
    CommonRequestOperatorStatus_SubmitProblem,
    CommonRequestOperatorStatus_GetNewInfoList,
    CommonRequestOperatorStatus_GetLastUpdate,
    CommonRequestOperatorStatus_GetAccountInfo,
    CommonRequestOperatorStatus_SubmitAccountInfo,
    CommonRequestOperatorStatus_GetGrowDiary,
    CommonRequestOperatorStatus_SubmitGrowDiary,
    CommonRequestOperatorStatus_GetUserAlbum,
    CommonRequestOperatorStatus_SubmitUserAlbum,
}CommonRequestOperatorStatus;

@protocol CommonRequestOperatorDelegate <NSObject>
-(void)requestFinish:(id)data requestType:(CommonRequestOperatorStatus)type;
-(void)requestFail:(NSString*)error requestType:(CommonRequestOperatorStatus)type;
@end

@interface CommonRequestOperator : NSObject <RequestOperatorDelegate> {
    CommonRequestOperatorStatus _status;
    RequestOperator *_requestOperator;
}

@property (nonatomic, assign) id<CommonRequestOperatorDelegate> delegate;
// 取消请求
-(void)cancel;

//获取资源包
-(BOOL)getClientPkg:(NSString*)timestamp;
//登录
-(BOOL)login:(NSString*)user pwd:(NSString*)pwd token:(NSString*)token;
//注销
-(BOOL)logout;
//设置用户邮箱
-(BOOL)setUserMail:(NSString*)mail;
//Push设置
-(BOOL)setPushInfo:(BOOL)ifPush isVibrate:(BOOL)isVibrate isSound:(BOOL)isSound
          fromTime:(NSString*)fromTime toTime:(NSString*)toTime;
//报Bug
-(BOOL)submitProblem:(NSString*)problem suggestion:(NSString*)suggestion;
//获取最新信息
-(BOOL)getNewInfoList;
//获取各模块最后更新时间
-(BOOL)getLastUpdate;


//获取基本资料
-(BOOL)getAccountInfo:(NSString*)lastupdate;
//提交基本资料
-(BOOL)submitAccountInfo:(NSData*)data;

//获取成长点滴
-(BOOL)getGrowDiary:(NSString*)lastupdate;
//提交成长点滴
-(BOOL)submitGrowDiary:(NSArray*)items;

//获取个人相册
-(BOOL)getUserAlbum:(NSString*)lastupdate;
//提交个人相册
-(BOOL)submitUserAlbum:(NSArray*)items;
@end

