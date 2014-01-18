//
//  CommonRequestOperator.m
//  DrPalm
//
//  Created by JiangBo on 13-1-14.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CommonRequestOperator.h"
#import "LoginManager.h"
#import "LastUpdateDataManager.h"
#import "SchoolDataManager.h"
#import "ClassDataManager.h"
#import "CommonDataManager.h"

#import "UserInfoManager.h"

@interface CommonRequestOperator ()
@property (nonatomic, retain) RequestOperator *requestOperator;
//处理获取资源包返回
-(void)handleGetCliPkg:(id)data;
//处理登录返回
-(void)handleLogin:(id)data;
//处理注销返回
-(void)handleLogout:(id)data;
//处理设置用户邮箱返回
-(void)handleSetUsrMail:(id)data;
//处理Push设置返回
-(void)handleSetPushInfo:(id)data;
//处理报bug返回
-(void)handleSubmitProblem:(id)data;
//处理获取最新信息返回
-(void)handleGetNewsInfoList:(id)data;
//处理获取各模块最后更新时间返回
-(void)handleGetLastUpdate:(id)data;

//处理获取基本资料返回
-(void)handleGetAccountInfo:(id)data;
//处理提交基本资料返回
-(void)handleSubmitAccountInfo:(id)data;

//处理获取成长点滴返回
-(void)handleGetGrowDiary:(id)data;
//处理提交成长点滴返回
-(void)handleSubmitGrowDiary:(id)data;

//处理获取个人相册返回
-(void)handleGetUserAlbum:(id)data;
//处理提交个人相册返回
-(void)handleSubmitUserAlbum:(id)data;

- (BOOL)isParsingOpretSuccess:(id)data errorCode:(NSMutableString *)errorCode;
@end

@implementation CommonRequestOperator

@synthesize delegate;
@synthesize requestOperator = _requestOperator;

-(id)init{
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
    _status = CommonRequestOperatorStatus_None;
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

//获取资源包
-(BOOL)getClientPkg:(NSString *)timestamp
{
    [self cancel];
    _status = CommonRequestOperatorStatus_GetCliPkg;
    
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:timestamp forKey:GetCliPkg_LastMDate];
    [paramDict setObject:NumNoType_Iphone forKey:GetCliPkg_NumNo];
    
    return [self.requestOperator sendSingleGet:GetCliPkg_Path paramDict:paramDict];
}

//处理获取资源包返回
-(void)handleGetCliPkg:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [delegate requestFinish:data requestType:_status];
        }
    });
    return;
}

//登录
-(BOOL)login:(NSString*)user pwd:(NSString*)pwd token:(NSString*)token
{
    [self cancel];
    _status = CommonRequestOperatorStatus_Login;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    if(user.length > 0) {
        [paramDict setObject:user forKey:Login_UserName];
    }
    if(pwd.length > 0) {
        [paramDict setObject:pwd forKey:Login_Pwd];
    }
    [paramDict setObject:DeviceType_IPhone forKey:Login_DeviceType];
    if(token.length > 0)
        [paramDict setObject:token forKey:Login_DeviceToken];
    
    return [self.requestOperator sendSingleGet:Login_Path paramDict:paramDict];
}
//处理登录返回
-(void)handleLogin:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [delegate requestFinish:data requestType:_status];
        }
    });
    return;
}
//注销
-(BOOL)logout
{
    [self cancel];
    _status = CommonRequestOperatorStatus_Logout;
    
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    LoginManager* loginmanage = LoginManagerInstance();
    if(loginmanage.sessionKey.length > 0)
        [paramDict setObject:SESSION_KEY forKey:loginmanage.sessionKey];
    return [self.requestOperator sendSingleGet:Logout_Path paramDict:paramDict];
}
//处理注销返回
-(void)handleLogout:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [delegate requestFinish:nil requestType:_status];
        }
    });
    return;
}

//设置用户邮箱
-(BOOL)setUserMail:(NSString*)mail
{
    [self cancel];
    _status = CommonRequestOperatorStatus_SetUserMail;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    LoginManager* loginmanager = LoginManagerInstance();
    [paramDict setObject:SESSION_KEY forKey:loginmanager.sessionKey];
    [paramDict setObject:mail forKey:SetUserMail_Mail];
    
    return [self.requestOperator sendSingleGet:SetUserMail_Path paramDict:paramDict];
    
}

-(void)handleSetUsrMail:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [delegate requestFinish:nil requestType:_status];
        }
    });
    return;
}
//Push设置
-(BOOL)setPushInfo:(BOOL)ifPush isVibrate:(BOOL)isVibrate isSound:(BOOL)isSound
          fromTime:(NSString*)fromTime toTime:(NSString*)toTime
{
    [self cancel];
    _status = CommonRequestOperatorStatus_SetPushInfo;
    
    NSMutableArray *postArray = [NSMutableArray array];
    
    // sessionkey
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    //ifPush
    [postArray addObject:[self.requestOperator buildPostParam:IfPush content:ifPush?@"1":@"0"]];
    //ifShake
    [postArray addObject:[self.requestOperator buildPostParam:IfShake content:isVibrate?@"1":@"0"]];
    //ifSound
    [postArray addObject:[self.requestOperator buildPostParam:IfSound content:isSound?@"1":@"0"]];
    //PushTime
     NSString *pushtime = [NSString stringWithFormat:@"[{\"%@\":\"%@\",\"%@\":\"%@\"}]", Start, fromTime, End, toTime];
    [postArray addObject:[self.requestOperator buildPostParam:PushTime content:pushtime]];

    return [self.requestOperator sendSinglePost:SetPushInfo_Path paramArray:postArray];
}
//处理Push设置返回
-(void)handleSetPushInfo:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [delegate requestFinish:nil requestType:_status];
        }
    });
    return;
}


//报Bug
-(BOOL)submitProblem:(NSString*)problem suggestion:(NSString*)suggestion
{
    [self cancel];
    _status = CommonRequestOperatorStatus_SubmitProblem;

    NSMutableArray *postArray = [NSMutableArray array];
    
    // sessionkey
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    //problem
    [postArray addObject:[self.requestOperator buildPostParam:SubmitProblem_Problem content:problem]];
    //suggestion
    [postArray addObject:[self.requestOperator buildPostParam:SubmitProblem_Suggestion content:suggestion]];

    return [self.requestOperator sendSinglePost:SubmitProblem_Path paramArray:postArray];
}

//处理报Bug返回
-(void)handleSubmitProblem:(id)data
{
    if(nil != delegate)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate requestFinish:nil requestType:_status];
        });
    }
    return;

}
//获取最新信息
-(BOOL)getNewInfoList
{
    [self cancel];
//    self.httpClient = [[[HttpClient alloc] init] autorelease];
//    self.httpClient.delegate = self;
    _status = CommonRequestOperatorStatus_GetNewInfoList;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    
    LoginManager* loginmanager = LoginManagerInstance();
    if (loginmanager.sessionKey.length > 0) {
        [paramDict setObject:loginmanager.sessionKey forKey:SESSION_KEY];
    }
    return [self.requestOperator sendSingleGet:GetNewInfoList_Path paramDict:paramDict];
}
//处理获取最新信息返回
-(void)handleGetNewsInfoList:(id)data
{
    if([data isKindOfClass:[NSDictionary class]])
    {
        //清本地数据
        [CommonDataManager removeAll];
        
        BOOL bSuccess = NO;
        //storys
        id items = [data objectForKey:StoryItems];
        if([items isKindOfClass:[NSArray class]])
        {
            bSuccess = YES;
            for (NSDictionary* newsDic in (NSArray*)[data objectForKey:StoryItems])
            {
                [CommonDataManager newsWitdhDict:newsDic];
            }
            [CoreDataManager saveData];
        }
        
        //Events
        items = [data objectForKey:EventsItems];
        if([items isKindOfClass:[NSArray class]])
        {
            bSuccess = YES;
            for (NSDictionary* eventsDic in (NSArray*)[data objectForKey:EventsItems])
            {
                [CommonDataManager eventWitdhDict:eventsDic];
            }
            [CoreDataManager saveData];
        }
        if(bSuccess)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                    [delegate requestFinish:nil requestType:CommonRequestOperatorStatus_GetNewInfoList];
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if([delegate respondsToSelector:@selector(requestFail:requestType:)]){
                    [delegate requestFail:CommonRequestUpdateFailed requestType:_status];
                }
            });
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if([delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [delegate requestFail:CommonRequestUpdateFailed requestType:_status];
            }
        });
    }
}
//获取各模块最后更新时间
-(BOOL)getLastUpdate
{
    [self cancel];
    _status = CommonRequestOperatorStatus_GetLastUpdate;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    LoginManager* loginmanager = LoginManagerInstance();
    if(loginmanager.sessionKey != nil)
        [paramDict setObject:loginmanager.sessionKey forKey:SESSION_KEY];
    
    //token
    NSString *deviceToken = nil;
    if (nil != AppDelegate().deviceToken){
        deviceToken = [[NSString stringWithFormat:@"%@", AppDelegate().deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
        deviceToken = [deviceToken substringWithRange:NSMakeRange(1, [deviceToken length]-2)];
        [paramDict setObject:deviceToken forKey:TOKENID];
    }
    
    return [self.requestOperator sendSingleGet:GetLastUpdate_Path paramDict:paramDict];
}
//处理模块最后更新时间返回
-(void)handleGetLastUpdate:(id)data
{
    if([data isKindOfClass:[NSDictionary class]])
    {
        
        // 我的校园
        [SchoolDataManager removeAllCategoryLastUpdate];
        
        id arrayNews = [data objectForKey:LastUpdate_News];
        if([arrayNews isKindOfClass:[NSArray class]])
        {
            for(NSDictionary* dict in(NSArray*)arrayNews)
            {
                id channelId = [dict objectForKey:@"channel"];
                id lastupdate = [dict objectForKey:@"lastupdate"];
                if(channelId!=nil && channelId != [NSNull null] && [channelId isKindOfClass:[NSString class]])
                {
                    SchoolNewsCategory *category = [SchoolDataManager queryCategaoryWithId:(NSString*)channelId];
                    if(category)
                    {
                        double time = 0;
                        if([lastupdate isKindOfClass:[NSNumber class]]){
                            time = [lastupdate doubleValue];
                        }
                        category.lastUpdateChannel = [NSDate dateWithTimeIntervalSince1970:time];
                    }
                }
            }
            [CoreDataManager saveData];
        }
        
        // 我的班级
        // 清除本地
        [ClassDataManager removeAllCategoryLasUpdate];
        
        id arrayEvents = [data objectForKey:LastUpdate_Event];
        if([arrayEvents isKindOfClass:[NSArray class]])
        {
            for(NSDictionary* dict in(NSArray*)arrayEvents)
            {
                id categoryId  = [dict objectForKey:@"type"];
                id unreadcount = [dict objectForKey:@"unreadcount"];
                if(categoryId!=nil && categoryId != [NSNull null] && [categoryId isKindOfClass:[NSString class]])
                {
                    ClassEventCategory* category = [ClassDataManager queryCategaoryWithId:(NSString*)categoryId];
                    if(category)
                    {
                        if([unreadcount isKindOfClass:[NSNumber class]]){
                            category.unreadcount = [NSNumber numberWithInteger:[unreadcount intValue]];
                        }
                    }
                }
            }
            [CoreDataManager saveData];
        }
        
        // 已发
        id foundValue = nil;
        foundValue = [data objectForKey:UnReadCount_SentEvent];
        if([foundValue isKindOfClass:[NSDictionary class]]) {
            id unReadCount = [foundValue objectForKey:UnReadCount];
            if([unReadCount isKindOfClass:[NSNumber class]]) {
                ClassEventCategory *category = [ClassDataManager queryCategaoryWithId:SENTEVENTMODULE];
                category.unreadcount = unReadCount;
            }
        }
        // 系统消息
        foundValue = [data objectForKey:UnReadCount_Sysmsg];
        if([foundValue isKindOfClass:[NSDictionary class]]) {
            id unReadCount = [foundValue objectForKey:UnReadCount];
            if([unReadCount isKindOfClass:[NSNumber class]]) {
                ClassEventCategory *category = [ClassDataManager queryCategaoryWithId:SYSMSGMODULE];
                category.unreadcount = unReadCount;
            }
        }
        // 家园桥
        foundValue = [data objectForKey:UnReadCount_Contact];
        if([foundValue isKindOfClass:[NSDictionary class]]) {
            id unReadCount = [foundValue objectForKey:UnReadCount];
            if([unReadCount isKindOfClass:[NSNumber class]]) {
                ClassEventCategory *category = [ClassDataManager queryCategaoryWithId:FACE2FACEMOUDLE];
                if(category) {
                    category.unreadcount = unReadCount;
                }
            }
        }
        // ebabychannel
        foundValue = [data objectForKey:UnReadCount_Ebabychannel];
        if([foundValue isKindOfClass:[NSDictionary class]]) {
            id unReadCount = [foundValue objectForKey:UnReadCount];
            if([unReadCount isKindOfClass:[NSNumber class]]) {
                [LastUpdateDataManager updateUnReadCountWithCategory:Category_EBabyChanel unReadCount:unReadCount hasUser:NO];
            }
        }
        [CoreDataManager saveData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [delegate requestFinish:nil requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(delegate) {
                if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                    [delegate requestFail:CommonRequestUpdateFailed requestType:_status];
                }
            }
        });
    }
}

//获取基本资料
-(BOOL)getAccountInfo:(NSString*)lastupdate
{
    [self cancel];
    _status = CommonRequestOperatorStatus_GetAccountInfo;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:lastupdate forKey:LastUpdate_Param];
    
    LoginManager* loginmanager = LoginManagerInstance();
    if(loginmanager.sessionKey != nil)
        [paramDict setObject:loginmanager.sessionKey forKey:SESSION_KEY];
    
    return [self.requestOperator sendSingleGet:GetAccountInfo_Path paramDict:paramDict];
}

//处理获取基本资料返回
-(void)handleGetAccountInfo:(id)data
{
    if([data isKindOfClass:[NSDictionary class]])
    {
        //level
        id value = [data objectForKey:@"level"];
        if(value != nil && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
        {
            UserInfoManagerInstance().userInfo.level = value;
        }
        
        //curscore
        value = [data objectForKey:@"curscore"];
        if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
        {
            UserInfoManagerInstance().userInfo.curscore = value;
        }
        
        //levelupscore
        value = [data objectForKey:@"levelupscore"];
        if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
        {
            UserInfoManagerInstance().userInfo.levelupscore = value;
        }
        
        
        //headurl
        value = [data objectForKey:@"headurl"];
        if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSString class]])
        {
            HeadImage* img = [HeadImage imgWithUrl:value];
            UserInfoManagerInstance().userInfo.headimage = img;            
        }
        
        //headlastupdate
        value = [data objectForKey:@"headlastupdate"];
        if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
        {
            double time = [value doubleValue];
            UserInfoManagerInstance().userInfo.headlastupdate = [NSDate dateWithTimeIntervalSince1970:time];
        }
        
        //lastupdate
        value = [data objectForKey:@"lastupdate"];
        if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
        {
            double time = [value doubleValue];
            UserInfoManagerInstance().userInfo.lastupdate = [NSDate dateWithTimeIntervalSince1970:time];
        }
        
        //serviceenddate
        value = [data objectForKey:@"serviceenddate"];
        if(value != NULL && value != [NSNull null] && [value isKindOfClass:[NSNumber class]])
        {
            double time = [value doubleValue];
            UserInfoManagerInstance().userInfo.serviceenddate = [NSDate dateWithTimeIntervalSince1970:time];
        }
        
        [UserInfoManagerInstance() saveUserInfo];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [delegate requestFinish:nil requestType:_status];
            }
        });
       
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(delegate) {
                if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                    [delegate requestFail:@"parse error" requestType:_status];
                }
            }
        });
    }
}

//提交基本资料
-(BOOL)submitAccountInfo:(NSData*)data
{
    [self cancel];
    _status = CommonRequestOperatorStatus_SubmitAccountInfo;
    
    NSMutableArray *postArray = [NSMutableArray array];
    // sessionkey
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0) {
        sessionKey = loginmanager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    
    //headimage
    [postArray addObject:[self.requestOperator buildFilePostParam:@"headimg" contentType:@"image/jpg" data:data fileName:@"head"]];
    return [self.requestOperator sendSinglePost:SubmitAccountInfo_Path paramArray:postArray];
}

//处理提交基本资料返回
-(void)handleSubmitAccountInfo:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [delegate requestFinish:nil requestType:_status];
        }
    });
}

//获取成长点滴
-(BOOL)getGrowDiary:(NSString*)lastupdate
{
    [self cancel];
    _status = CommonRequestOperatorStatus_GetGrowDiary;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:lastupdate forKey:LastUpdate_Param];
    
    LoginManager* loginmanager = LoginManagerInstance();
    if(loginmanager.sessionKey != nil)
        [paramDict setObject:loginmanager.sessionKey forKey:SESSION_KEY];
    
    return [self.requestOperator sendSingleGet:GetGrowDiary_Path paramDict:paramDict];
}
//处理获取成长点滴返回
-(void)handleGetGrowDiary:(id)data
{
    if([data isKindOfClass:[NSDictionary class]])
    {
        id diaryarray = [data objectForKey:GrowDiaryList];
        if(diaryarray != nil && diaryarray != [NSNull null] && [diaryarray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dict in diaryarray){
                [UserInfoManager growDiaryWithDict:dict];
            }
            [CoreDataManager saveData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [delegate requestFinish:nil requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(delegate) {
                if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                    [delegate requestFail:@"parse error" requestType:_status];
                }
            }
        });
    }
}

-(BOOL)submitGrowDiary:(NSArray*)items
{
    [self cancel];
    _status = CommonRequestOperatorStatus_SubmitGrowDiary;
    
    NSMutableArray *postArray = [NSMutableArray array];
    // sessionkey
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0) {
        sessionKey = loginmanager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    
    NSMutableArray* growDiarys = [NSMutableArray array];
    for (GrowDiaryForSent* item in items){
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        
        if(item.title)
            [dict setObject:item.title forKey:Title];
        if(item.content)
            [dict setObject:item.content forKey:Content];
        if(item.status)
            [dict setObject:item.status forKey:Status];
        if(item.diaryid)
            [dict setObject:item.diaryid forKey:DiaryId];
        [growDiarys addObject:dict];
    }
    
    if ([growDiarys count] > 0) {
        SBJSON* json = [[SBJSON alloc] init];
        [postArray addObject:[self.requestOperator buildPostParam:Param content:[json stringWithObject:growDiarys error:nil]]];
        [json release];
    }
    return [self.requestOperator sendSinglePost:SubmitGrowDiary_Path paramArray:postArray];
}
//处理提交成长点滴返回
-(void)handleSubmitGrowDiary:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [UserInfoManager delGrowDiaryForSent];
            [delegate requestFinish:nil requestType:_status];
        }
    });
}

//获取个人相册
-(BOOL)getUserAlbum:(NSString*)lastupdate
{
    [self cancel];
    _status = CommonRequestOperatorStatus_GetUserAlbum;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:lastupdate forKey:LastUpdate_Param];
    
    LoginManager* loginmanager = LoginManagerInstance();
    if(loginmanager.sessionKey != nil)
        [paramDict setObject:loginmanager.sessionKey forKey:SESSION_KEY];
    
    return [self.requestOperator sendSingleGet:GetUserAlbum_Path paramDict:paramDict];
}

//处理获取个人相册返回
-(void)handleGetUserAlbum:(id)data
{
    if([data isKindOfClass:[NSDictionary class]])
    {
        id diaryarray = [data objectForKey:AlbumList];
        if(diaryarray != nil && diaryarray != [NSNull null] && [diaryarray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dict in diaryarray){
                [UserInfoManager albumWithDict:dict];
            }
        }
        
        id lastupdate = [data objectForKey:LastUpdate_Param];
        if(lastupdate != nil && lastupdate != [NSNull null] && [lastupdate isKindOfClass:[NSNumber class]])
        {
            [UserInfoManager updateAlbumLastupdate:lastupdate];
        }
        [CoreDataManager saveData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [delegate requestFinish:nil requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(delegate) {
                if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                    [delegate requestFail:@"parse error" requestType:_status];
                }
            }
        });
    }

    
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
//            [delegate requestFinish:nil requestType:_status];
//        }
//    });
    
   
}

//提交个人相册
-(BOOL)submitUserAlbum:(NSArray*)items
{
    [self cancel];
    _status = CommonRequestOperatorStatus_SubmitUserAlbum;
    
    NSMutableArray *postArray = [NSMutableArray array];
    // sessionkey
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0) {
        sessionKey = loginmanager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }    
    
    NSInteger i = 1;
    NSMutableArray* imgitems = [NSMutableArray array];
    for(PrivateAlbumForSent* item in items)
    {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        
        [dict setObject:item.status forKey:Status];
        
        //新增
        if([item.status isEqualToString:OperateStatus_New])
        {            
            NSString* param = [NSString stringWithFormat:@"%d",i];
            NSString* fileName = [NSString stringWithFormat:@"file%d",i];
            [postArray addObject:[self.requestOperator buildFilePostParam:param contentType:@"image/jpg" data:item.data fileName:fileName]];
            //filename
            [dict setObject:fileName forKey:FileName];
            [dict setObject:item.desc forKey:Description];
        }
        else if([item.status isEqualToString:OperateStatus_Modify])
        {
            [dict setObject:item.desc forKey:Description];
            [dict setObject:item.imageId forKey:ImageId];
        }
        else if([item.status isEqualToString:OperateStatus_Del])
        {
            [dict setObject:item.imageId forKey:ImageId];
        }
        
        [imgitems addObject:dict];        
        i++;
    }
    
    //
    if ([imgitems count] > 0) {
        SBJSON* json = [[SBJSON alloc] init];
        [postArray addObject:[self.requestOperator buildPostParam:Param content:[json stringWithObject:imgitems error:nil]]];
        [json release];
    }
    
    return [self.requestOperator sendSinglePost:SubmitUserAlbum_Path paramArray:postArray];
}

//处理提交个人相册返回
-(void)handleSubmitUserAlbum:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [delegate requestFinish:nil requestType:_status];
        }
    });
}

-(void)requestFinish:(id)json
{   
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    switch (_status) {
        case CommonRequestOperatorStatus_GetCliPkg:{
            [self handleGetCliPkg:json];
            break;
        }
        case CommonRequestOperatorStatus_Login:{
            [self handleLogin:json];
            break;
        }
        case CommonRequestOperatorStatus_Logout:{
            [self handleLogout:json];
            break;
        }
        case CommonRequestOperatorStatus_SetUserMail:{
            [self handleSetUsrMail:json];
            break;
        }
        case CommonRequestOperatorStatus_SetPushInfo:{
            [self handleSetPushInfo:json];
            break;
        }
        case CommonRequestOperatorStatus_SubmitProblem:{
            [self handleSubmitProblem:json];
            break;
        }
        case CommonRequestOperatorStatus_GetNewInfoList:{
            [self handleGetNewsInfoList:json];
            break;
        }
        case CommonRequestOperatorStatus_GetLastUpdate:{
            [self handleGetLastUpdate:json];
            break;
        }
        case CommonRequestOperatorStatus_GetAccountInfo:{
            [self handleGetAccountInfo:json];
            break;
        }
        case CommonRequestOperatorStatus_SubmitAccountInfo:{
            [self handleSubmitAccountInfo:json];
            break;
        }
        case CommonRequestOperatorStatus_GetGrowDiary:{
            [self handleGetGrowDiary:json];
            break;
        }
        case CommonRequestOperatorStatus_SubmitGrowDiary:{
            [self handleSubmitGrowDiary:json];
            break;
        }
        case CommonRequestOperatorStatus_GetUserAlbum:{
            [self handleGetUserAlbum:json];
            break;
        }
        case CommonRequestOperatorStatus_SubmitUserAlbum:{
            [self handleSubmitUserAlbum:json];
            break;
        }
        default:break;
    }

    [pool drain];
    
}

- (void)requestFail:(NSString*)error
{
    // 网络请求失败
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [delegate requestFail:error requestType:_status];
        }
    });
}


- (BOOL)isParsingOpretSuccess:(id)data errorCode:(NSMutableString *)errorCode {
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
                [errorCode setString:opCode];
            }
        }
    }
    return success;
}


@end
