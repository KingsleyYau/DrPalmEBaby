//
//  SchoolRequestOperator.m
//  DrPalm
//
//  Created by JiangBo on 13-1-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "SchoolRequestOperator.h"
#import "SchoolModuleDefine.h"
#import "LoginManager.h"
#import "SchoolNewsCategory.h"
#import "SchoolDataManager.h"


@interface SchoolRequestOperator() {
    
}
@property (nonatomic, retain) RequestOperator *requestOperator;

//处理获取新闻列表返回
-(void)handleGetNewsList:(id)data;
//处理获取新闻详细返回
-(void)handleGetNewsDetail:(id)data;
//处理新闻搜索返回
-(void)handleSearchNews:(id)data;
//处理入托咨询返回
-(void)handleSubmitConsult:(id)data;
//处理获取最新我的校园信息返回
-(void)handleGetNewsModuleInfoList:(id)data;

@end

@implementation SchoolRequestOperator

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
    _status = SchoolRequestOperator_None;
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


//获取新闻列表
-(BOOL)getNewsList:(NSString *)channelid lastupdate:(NSInteger)lastupdate
{
    [self cancel];
    self.requestOperator.paramOperation = channelid;//[NSNumber numberWithInt:channelid];
    _status = SchoolRequestOperator_GetNewsList;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];

    // channel
    NSString * chanel = channelid;//[NSString stringWithFormat:@"%d",channelid];
    [paramDict setObject:chanel forKey:GetNewsList_ChannelParam];
    // load more Activity
    if(0 <= lastupdate) {
        NSString *lastUpdateString = [NSString stringWithFormat:@"%d", lastupdate, nil];
        [paramDict setObject:lastUpdateString forKey:GetNewsList_LastUpdate];
    }
    return [self.requestOperator sendSingleGet:GetNewsList_Path paramDict:paramDict];
}
//处理获取新闻列表返回
-(void)handleGetNewsList:(id)data
{
    id foundvalue = [data objectForKey:NewsTagItem];
    if(nil == foundvalue  || [NSNull null] == foundvalue)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFinish:[NSNumber numberWithInteger:0] requestType:SchoolRequestOperator_GetNewsList];
        });
        return;
    }
    
    if([data isKindOfClass:[NSDictionary class]])
    {
        foundvalue = [data objectForKey:NewsTagItem];
        if( nil == foundvalue || [NSNull null] ==  foundvalue ){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                SchoolNewsCategory *category = [SchoolDataManager queryCategaoryWithId:self.requestOperator.paramOperation];
                if(category)
                {
                    category.lastUpdated = [NSDate date];
                    category.expectedCount = [NSNumber numberWithInt:0];
                    [CoreDataManager saveData];
                }
                [delegate operateFinish:[NSNumber numberWithInteger:0] requestType:SchoolRequestOperator_GetNewsList];
            });
            return;
        }
        
        if([foundvalue isKindOfClass:[NSArray class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger i = 0;
                double maxlastupdate = 0;
                for (NSDictionary* newsDic in (NSArray*)[data objectForKey:NewsTagItem])
                {
                    if(![SchoolDataManager newsIsExist:[SchoolNews idWithDict:newsDic]])
                        i++;
                    [SchoolDataManager newsWitdhDict:newsDic];
                    
                    //lastupdate
                    double lastupdate = [[newsDic objectForKey:LastUpdate] doubleValue];
                    if (maxlastupdate<lastupdate) {
                        maxlastupdate = lastupdate;
                    }
                }
                // 新增新闻
                SchoolNewsCategory *category = [SchoolDataManager queryCategaoryWithId:self.requestOperator.paramOperation];
                if(category)
                {
                    category.lastUpdated = [NSDate date];
                     if(maxlastupdate != 0)
                         category.lastUpdateChannelList = [NSDate dateWithTimeIntervalSince1970:maxlastupdate];
                    category.expectedCount = [NSNumber numberWithInt:i];
                    [CoreDataManager saveData];
                }
                [delegate operateFinish:[NSNumber numberWithInteger:i] requestType:SchoolRequestOperator_GetNewsList];
            });

        }

    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:SchoolRequestOperator_GetNewsList];
        });
    }

    return;
}

//获取新闻详细
-(BOOL)getNewsDetail:(NSString *)storyid isAllField:(BOOL)isAllField
{
    [self cancel];
    _status = SchoolRequestOperator_GetNewsDetail;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary  dictionary];
    
    NSString* nsstoryid = storyid;//[NSString stringWithFormat:@"%d",storyid];
    NSString *allField = [NSString stringWithFormat:@"%d", isAllField];
    
    [paramDict setObject:nsstoryid forKey:Story_Id];
    [paramDict setObject:allField forKey:AllField];
    return [self.requestOperator sendSingleGet:GetNewsDetail_Path paramDict:paramDict];
}
//处理获取新闻详细返回
-(void)handleGetNewsDetail:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:data];
            SchoolNews* schoolNews =  [SchoolDataManager newsWitdhDict:dict];
            schoolNews.read = [NSNumber numberWithBool:YES]; //已读
            [CoreDataManager saveData];
            [delegate operateFinish:nil requestType:SchoolRequestOperator_GetNewsDetail];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:SchoolRequestOperator_GetNewsDetail];
        });
    }
    return;
}

//新闻搜索
-(BOOL)searchNews:(NSString*)keyword  start:(NSInteger)start
{
    [self cancel];
    _status = SchoolRequestOperator_SearchNews;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary  dictionary];
    
    NSString* nsstart = [NSString stringWithFormat:@"%d",start];

    [paramDict setObject:keyword forKey:SearchNews_Keyword];
    [paramDict setObject:nsstart forKey:SearchNews_Start];
    
    return [self.requestOperator sendSingleGet:SearchNews_Path paramDict:paramDict];
}

// 处理新闻搜索返回
-(void)handleSearchNews:(id)data
{
    id foundvalue = [data objectForKey:NewsTagItem];
    if(nil == foundvalue  || [NSNull null] == foundvalue)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFinish:[NSNumber numberWithInteger:0] requestType:SchoolRequestOperator_SearchNews];
        });
        return;
    }
    
    if([data isKindOfClass:[NSDictionary class]])
    {
        foundvalue = [data objectForKey:NewsTagItem];
    
        if([foundvalue isKindOfClass:[NSArray class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger i = 0;
                for (NSDictionary* newsDic in (NSArray*)foundvalue)
                {
                    if(![SchoolDataManager newsIsExist:[SchoolNews idWithDict:newsDic]])
                        i++;
                    [SchoolDataManager newsWitdhDict:newsDic];
                }
                [delegate operateFinish:[NSNumber numberWithInteger:i] requestType:SchoolRequestOperator_SearchNews];
            });
            
        }
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:CommonRequestPotocolError requestType:SchoolRequestOperator_SearchNews];
        });
    }
    
    return;

}

//入托咨询
-(BOOL)submitConsult:(NSString *)username email:(NSString*)email phone:(NSString*)phone title:(NSString*)title content:(NSString*)content type:(NSString*)type;
{
    [self cancel];
    _status = SchoolRequestOperator_SubmitConsult;  

    NSMutableArray *postArray = [NSMutableArray array];
    
    //type
    [postArray addObject:[self.requestOperator buildPostParam:SubmitConsult_Type content:type]];
    // username
    [postArray addObject:[self.requestOperator buildPostParam:SubmitConsult_Username content:username]];
    // email
    [postArray addObject:[self.requestOperator buildPostParam:SubmitConsult_Email content:email]];
    // phone
    [postArray addObject:[self.requestOperator buildPostParam:SubmitConsult_Phone content:phone]];
    // title
    [postArray addObject:[self.requestOperator buildPostParam:SubmitConsult_Title content:title]];
    // content
    [postArray addObject:[self.requestOperator buildPostParam:SubmitConsult_Content content:content]];
    

    return [self.requestOperator sendSinglePost:SubmitConsult_Path paramArray:postArray];
}
//处理
-(void)handleSubmitConsult:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate operateFinish:nil requestType:SchoolRequestOperator_SubmitConsult];
    });
    return;
}

//获取最新我的校园信息
-(BOOL)getNewsModuleInfoList
{
    [self cancel];
    _status = SchoolRequestOperator_GetNewsModuleInfoList;
    NSMutableDictionary* paramDict = [NSMutableDictionary  dictionary];
    return [self.requestOperator sendSingleGet:GetNewsModuleInfoList_Path paramDict:paramDict];
}

//处理获取最新我的校园信息返回
-(void)handleGetNewsModuleInfoList:(id)data{
    [SchoolDataManager removeAllCategoryLastUpdate];
    if([data isKindOfClass:[NSDictionary class]])
    {
        // 我的校园
        id storyModules = [data objectForKey:NewsModuleItems];
        if([storyModules isKindOfClass:[NSArray class]])
        {
            for(NSDictionary* dict in(NSArray*)storyModules)
            {
                id channelId = [dict objectForKey:@"channel"];
                id title = [dict objectForKey:@"title"];
                id lastupdate = [dict objectForKey:@"lastupdate"];
                SchoolNewsCategory *category = [SchoolDataManager queryCategaoryWithId:(NSString*)channelId];
                if(category)
                {
                    //title
                    if([title isKindOfClass:[NSString class]])
                        category.titleofLastNews = title;
                    //lastupdate
                    double time = 0;
                    if([lastupdate isKindOfClass:[NSNumber class]]){
                        time = [lastupdate doubleValue];
                    }
                    category.lastUpdateChannel = [NSDate dateWithTimeIntervalSince1970:time];
                }
            }
            [CoreDataManager saveData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate operateFinish:nil requestType:SchoolRequestOperator_GetNewsModuleInfoList];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate operateFail:@"parse error" requestType:SchoolRequestOperator_GetNewsModuleInfoList];
            });
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate operateFail:@"parse error" requestType:SchoolRequestOperator_GetNewsModuleInfoList];
        });
    }
    return;
}

#pragma mark - Http回调 (HttpClientDelegate)
- (void)requestFinish:(id)json
{
    SchoolRequestOperatorStatus status = _status;
    _status = SchoolRequestOperator_None;
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    switch (status) {
        case SchoolRequestOperator_GetNewsList:{
            [self handleGetNewsList:json];
            break;
        }
        case SchoolRequestOperator_GetNewsDetail:{
            [self handleGetNewsDetail:json];
            break;
        }
        case SchoolRequestOperator_SearchNews:{
            [self handleSearchNews:json];
            break;
        }
        case SchoolRequestOperator_SubmitConsult:{
            [self handleSubmitConsult:json];
            break;
        }break;
        case SchoolRequestOperator_GetNewsModuleInfoList:{
            [self handleGetNewsModuleInfoList:json];
        }break;
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
