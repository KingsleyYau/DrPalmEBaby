//
//  DrPalmCenterRequest.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    LocalAreaRequestStatus_None,
    LocalAreaRequestStatus_GetAgentList,
    LocalAreaRequestStatus_GetSchoolList,
    LocalAreaRequestStatus_SearchSchool,
}LocalAreaRequestStatus;

@protocol LocalAreaRequestOperatorDelegate <NSObject>

-(void)operateFinish:(id)data requestType:(LocalAreaRequestStatus)type;
-(void)operateFail:(NSString*)error requestType:(LocalAreaRequestStatus)type;
@end

@interface LocalAreaRequest : NSObject 
{
    NSURLConnection* _connection;
    LocalAreaRequestStatus  _status;
}

@property (nonatomic, copy)  NSString* nsparentid;
@property (nonatomic, copy)  NSString* nsSearchKey;
@property (nonatomic, assign) id<LocalAreaRequestOperatorDelegate> delegate;


- (void)cancel;
#pragma mark 获取(代理商/机构/幼儿园集合)列表
- (BOOL)getAgentList:(NSString *)appId;
#pragma mark 获取地区或学校列表
- (BOOL)getSchoolList:(NSString *)parentid;
#pragma mark 搜索学校
- (BOOL)searchSchool:(NSString *)keyword;
@end
