//
//  SchoolRequestOperator.h
//  DrPalm
//
//  Created by JiangBo on 13-1-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "RequestOperator.h"

typedef enum{
    SchoolRequestOperator_None,
    SchoolRequestOperator_GetNewsList,
    SchoolRequestOperator_GetNewsDetail,
    SchoolRequestOperator_SearchNews,
    SchoolRequestOperator_SubmitConsult,
    SchoolRequestOperator_GetNewsModuleInfoList,
}SchoolRequestOperatorStatus;

#define SUBMITCONSULT_TYPE_CONSULT   @"consult"
#define SUBMITCONSULT_TYPE_FEEDBACK  @"feedback"

@protocol SchoolRequestOperatorDelegete <NSObject>

-(void)operateFinish:(id)data requestType:(SchoolRequestOperatorStatus)type;
-(void)operateFail:(NSString*)error requestType:(SchoolRequestOperatorStatus)type;
@end

@interface SchoolRequestOperator : NSObject <RequestOperatorDelegate> {
    SchoolRequestOperatorStatus  _status;
    RequestOperator *_requestOperator;
}

@property (nonatomic,assign)  id<SchoolRequestOperatorDelegete> delegate;
// 取消请求
-(void)cancel;
//获取新闻列表
-(BOOL)getNewsList:(NSString *)channelid lastupdate:(NSInteger)lastupdate;
//获取新闻详细
-(BOOL)getNewsDetail:(NSString *)storyid isAllField:(BOOL)isAllField;
//新闻搜索
-(BOOL)searchNews:(NSString*)keyword  start:(NSInteger)start;
//入托咨询
-(BOOL)submitConsult:(NSString *)username email:(NSString*)email phone:(NSString*)phone title:(NSString*)title content:(NSString*)content type:(NSString*)type;
//获取最新我的校园信息
-(BOOL)getNewsModuleInfoList;

@end
