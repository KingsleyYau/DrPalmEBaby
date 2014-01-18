//
//  DrPalmCenterRequest.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "LocalAreaRequest.h"
#import "LocalAreaDefine.h"
#import "LocalAreaDataManager.h"
// 公共协议
#import "CommonRequestDefine.h"
#import "ErrorCodeDef.h"
// Http发送类
#import "HttpClient.h"
// Json解析类
#import "MITJSON.h"
#import "AppEnviroment.h"

#define CENTERURL  @"http://%@/netapp/"

@interface LocalAreaRequest()  <HttpClientDelegate> {
    
}
@property (nonatomic, retain) HttpClient *httpClient;
- (BOOL)isParsingOpretSuccess:(id)data error:(NSMutableString*)error;

// 处理 获取(代理商/机构/幼儿园集合)列表返回
- (void)handleGetAgentList:(id)data;
// 处理获取地区或学校列表返回
- (void)handleGetSchoolList:(id)data;
// 处理搜索学校返回
-(void)handleSearchSchool:(id)data;
@end

@implementation LocalAreaRequest
@synthesize httpClient;
@synthesize delegate;
@synthesize nsparentid;
@synthesize nsSearchKey;
#pragma mark 公共
- (id)init {
    self = [super init];
    if(self)
    {
        self.httpClient = [[[HttpClient alloc] init] autorelease];
        self.httpClient.delegate = self;
        [self.httpClient cancel];
    }
    return self;
}

- (void)cancel {
    _status = LocalAreaRequestStatus_None;
    [self.httpClient cancel];
}

- (void)dealloc {
    _status = LocalAreaRequestStatus_None;
    self.delegate = nil;
    self.httpClient = nil;
    [super dealloc];
}
#pragma mark 获取(代理商/机构/幼儿园集合)列表
- (BOOL)getAgentList:(NSString *)appId {
    [self cancel];
    _status = LocalAreaRequestStatus_GetAgentList;
    NSMutableString *urlString = [NSMutableString string];
//    [urlString appendString:[NSString stringWithFormat:CENTERURL, AppEnviromentInstance().clientEntitlement.centerDomain, nil]];
//    [urlString appendString:GetAgentList_Path];
    
//    NSMutableDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      appId, AppId,
//                                      nil];
    
    //test
    [urlString appendString:[NSString stringWithFormat:CENTERURL, AppEnviromentInstance().clientEntitlement.centerDomain, nil]];
    [urlString appendString:GetNavigation_Path];
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      appId, AppId,
                                      nil];
    
    return [self.httpClient sendSingleGet:urlString paramDict:paramDict];
}
// 处理 获取(代理商/机构/幼儿园集合)列表返回
- (void)handleGetAgentList:(id)data {
    if(nil != data && [NSNull null] != data && [data isKindOfClass:[NSDictionary class]]) {
        id items = [data objectForKey:AgentList_Items];
        if(nil != items && [NSNull null] != items  && [items isKindOfClass:[NSArray class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 清除旧数据
                [LocalAreaDataManager clearDataBae];
                //
                for (NSDictionary* dict in items) {
                    [LocalAreaDataManager agentWithDict:dict];
                }
                [LocalCoreDataManager saveData];
                [delegate operateFinish:nil requestType:LocalAreaRequestStatus_GetSchoolList];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate operateFail:PARSE_FAIL requestType:LocalAreaRequestStatus_GetSchoolList];
            });
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:PARSE_FAIL requestType:LocalAreaRequestStatus_GetSchoolList];
        });
    }
}
#pragma mark 获取地区或学校列表
- (BOOL)getSchoolList:(NSString *)parentid  {
    [self cancel];
    _status = LocalAreaRequestStatus_GetSchoolList;
    self.nsparentid = parentid;
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:[NSString stringWithFormat:CENTERURL, AppEnviromentInstance().clientEntitlement.centerDomain, nil]];
    
    [urlString appendString:GetSchoolList_Path];
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      parentid, Local_Id,
                                      nil];
    return [self.httpClient sendSingleGet:urlString paramDict:paramDict];
}

- (void)handleGetSchoolList:(id)data {
    if(nil == data || [NSNull null] == data )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFinish:[NSNumber numberWithInt:0] requestType:LocalAreaRequestStatus_GetSchoolList];
        });
    }
    
    if([data isKindOfClass:[NSDictionary class]])
    {
        id items = [data objectForKey:SchoolList_Items];
        if(nil != items && [NSNull null] != items  && [items isKindOfClass:[NSArray class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //收藏的幼儿园列表
                NSMutableArray* arraybookmarkLocalId = [NSMutableArray array];
                BOOL hasBookMark = NO;
                NSArray* array = [LocalAreaDataManager areaBookmark];
                if(array && array.count>0)
                {
                    hasBookMark = YES;
                    for(LocalArea* localarea in array)
                    {
                        [arraybookmarkLocalId addObject:[localarea.local_id copy]];
                    }
                }

                //删除自身及子节点
                [LocalAreaDataManager delWithParentId:self.nsparentid];
                for (NSDictionary* dict in (NSArray*)[data objectForKey:SchoolList_Items])
                {
                    LocalArea*  localArea = [LocalAreaDataManager areaWithDict:dict parentId:self.nsparentid];
                    if(hasBookMark)
                    {
                        for(NSString* localid in arraybookmarkLocalId)
                        {
                            if([localid isEqualToString:localArea.local_id])
                            {
                                localArea.bookmark = [NSNumber numberWithBool:YES];
                            }
                        }
                    }
                }
                [LocalCoreDataManager saveData];
                [delegate operateFinish:nil requestType:LocalAreaRequestStatus_GetSchoolList];
            });
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:PARSE_FAIL requestType:LocalAreaRequestStatus_GetSchoolList];
        });
    }
    
    return;
}
#pragma mark 搜索学校
- (BOOL)searchSchool:(NSString*)keyword {
    [self cancel];
    _status = LocalAreaRequestStatus_SearchSchool;
    self.nsSearchKey = keyword;

    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:[NSString stringWithFormat:CENTERURL, AppEnviromentInstance().clientEntitlement.centerDomain, nil]];
    [urlString appendString:SearchSchool_Path];
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      keyword, SearchSchool_KeyWord,
                                      nil];
    return [self.httpClient sendSingleGet:urlString paramDict:paramDict];
}
// 处理搜索学校返回
-(void)handleSearchSchool:(id)data
{
    if(nil == data || [NSNull null] == data )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFinish:[NSNumber numberWithInt:0] requestType:LocalAreaRequestStatus_SearchSchool];
        });
    }
    
    if([data isKindOfClass:[NSDictionary class]])
    {
        id items = [data objectForKey:SchoolList_Items];
        if(nil != items && [NSNull null] != items  && [items isKindOfClass:[NSArray class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //收藏的幼儿园列表
                NSMutableArray* arraybookmarkLocalId = [NSMutableArray array];
                BOOL hasBookMark = NO;
                NSArray* array = [LocalAreaDataManager areaBookmark];
                if(array && array.count>0)
                {
                    hasBookMark = YES;
                    for(LocalArea* localarea in array)
                    {
                        [arraybookmarkLocalId addObject:[localarea.local_id copy]];                                                                          
                    }
                }

                //delete
                [LocalAreaDataManager deleWithSearchString:self.nsSearchKey];
                for (NSDictionary* dict in (NSArray*)[data objectForKey:SchoolList_Items])
                {
                    [LocalArea idWithDict:dict];
                    LocalArea*  localArea = [LocalAreaDataManager areaWithDict:dict parentId:self.nsparentid];
                    
                    if(hasBookMark)
                    {
                        for(NSString* localid in arraybookmarkLocalId)
                        {
                            if([localid isEqualToString:localArea.local_id])
                            {
                                localArea.bookmark = [NSNumber numberWithBool:YES];
                            }
                        }
                    }

                }
                [LocalCoreDataManager saveData];
                [delegate operateFinish:nil requestType:LocalAreaRequestStatus_SearchSchool];
            });
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:PARSE_FAIL requestType:LocalAreaRequestStatus_SearchSchool];
        });
    }
    
    return;
}
#pragma mark - (Http回调 HttpClientDelegate)
- (void)requestFinish:(id)data {
    id json = [MITJSON objectWithJSONData:data];
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSMutableString *error= [NSMutableString string];
    if(![self isParsingOpretSuccess:json error:error]) {
        [self requestFail:error];
    }else {
        switch (_status) {
            case LocalAreaRequestStatus_GetAgentList:{
                [self handleGetAgentList:json];
                break;
            }
            case LocalAreaRequestStatus_GetSchoolList:{
                [self handleGetSchoolList:json];
                break;
            }
            case LocalAreaRequestStatus_SearchSchool :{
                [self handleSearchSchool:json];
                break;
            }
            default:break;
        }
    }

    [pool drain];
}
- (void)requestFail:(NSString *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(operateFail:requestType:)]){
            [delegate operateFail:error requestType:_status];
        }
    });
}
#pragma mark - (错误处理)
- (BOOL)isParsingOpretSuccess:(id)data error:(NSMutableString*)error {
    BOOL success = NO;
    if(nil == data)
        return success;
    if (nil != data && [NSNull null] != data && [data isKindOfClass:[NSDictionary class]]){
        NSDictionary *opretDict = [data objectForKey:OPRET];
        if(nil != opretDict){
            NSString *opflagStr = [opretDict objectForKey:OPFLAG];
            int flag = [opflagStr integerValue];
            if(nil == opflagStr || flag == 1){
                success = YES;
            }
            else{
                NSString *opCode = [opretDict objectForKey:OPCODE];
                NSString *errorString = ErrorCodeToString(opCode);
                [error setString:errorString];
            }
        }
    }
    return success;
}
@end
