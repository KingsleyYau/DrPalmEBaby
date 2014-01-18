//
//  CommentRequestOperator.m
//  DrPalm
//
//  Created by JiangBo on 12-12-5.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#define MARKETID_PARAM        @"market_id"
#define SESSIONKEY_PARAM      @"sessionkey"


//getTopic
#define GetTopicPath               @"gettopic"
#define TopicIdParam               @"topic_id"

//getComment
#define GetCommentPath        @"getcomment"
#define CommentIdParam        @"comment_id"   

//sendtopic
#define SendTopicPath         @"sendtopic"
#define TitleParam            @"title"
#define BodyParam             @"body"
#define OwnerParam            @"owner"
#define OwnerIdParam          @"ownerid"
#define StartTimeParam        @"start"
#define EndTimeParam          @"end"



//
#define   ItemsParam          @"items"


#define ReturnString    @"\r\n"



#import "CommentRequestOperator.h"
#import "LoginManager.h"
#import "MITMobileServerConfiguration.h"


@interface CommentRequestOperator ()
@property (nonatomic, retain) RequestOperator *requestOperator;
// 处理获取私信话题列表返回
-(void)handleGetTopic:(id)data;
// 处理获取私信列表返回
-(void)handleGetComment:(id)data;
// 处理发起话题返回
-(void)handleSendTopic:(id)data;
// 处理发送私信返回
-(void)handleSendComment:(id)data;

@end

@implementation CommentRequestOperator

@synthesize delegate = _delegate;
@synthesize requestOperator = _requestOperator;

#pragma mark - PrivateFunction
-(id)init
{
    if (self = [super init])
    {
        _requestOperator = [[RequestOperator alloc] init];
        _requestOperator.delegate = self;
        [self cancel];
    }
    return self;
}
- (void)dealloc {
    [self cancel];
    self.delegate = nil;
    self.requestOperator = nil;
    [super dealloc];
}
- (void)cancel {
    _status = CommentRequestOperator_None;
    [self.requestOperator cancel];
}


//获取话题列表
-(BOOL)getTopic:(NSInteger) lasttopicId
{
    [self cancel];
    _status = CommentRequestOperator_GetTopic;
    
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:[MITMobileWebGetCurrentServerURL() absoluteString]];
    [urlString appendString:GetTopicPath];

    LoginManager *loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    
    // base param
    NSMutableDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  sessionKey, SESSIONKEY_PARAM,nil];
    // load more 
    if (0 != lasttopicId){
        NSString * nslasttopicId = [NSString stringWithFormat:@"%d", lasttopicId];
        [param setObject:nslasttopicId forKey:TopicIdParam];
    }
    
    return [self.requestOperator sendSingleGet:urlString paramDict:param];
}
//处理获取话题列表返回
-(void)handleGetTopic:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        // parsing event list
        id foundValue = [data objectForKey:ItemsParam];
        if( nil == foundValue || foundValue == [NSNull null] ){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate operateSuccess:[NSNumber numberWithInteger:0] requestType:CommentRequestOperator_GetTopic];
            });
            return;
        }
        if ([[data objectForKey:ItemsParam] isKindOfClass:[NSArray class]]
            && [[(NSArray*)[data objectForKey:ItemsParam] lastObject] isKindOfClass:[NSDictionary class]])
        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSInteger i = 0;
//                for (NSDictionary* newsDic in (NSArray*)[data objectForKey:NewsTagItem])
//                {
//                    if(![NewsDataManager newsSentIsExist:[[NewsSentStory idWithDict:newsDic] intValue]])
//                        i++;
//                    [NewsDataManager newsSentWitdhDict:newsDic];
//                }
//                [CoreDataManager saveData];
//                [_delegate operateFinish:[NSNumber numberWithInteger:i] requestType:NewsRequestOperator_UpdateSentNews];
//            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate operateFail:@"parsing fail!" requestType:CommentRequestOperator_GetTopic];
            });
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate operateFail:@"parsing fail!" requestType:CommentRequestOperator_GetTopic];
        });
        
    }
}

//获取私信列表
-(BOOL)getComment:(NSInteger)topicId lastcommentId:(NSInteger)lastCommentId
{
    [self cancel];
    _status = CommentRequestOperator_GetComment;
    
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:[MITMobileWebGetCurrentServerURL() absoluteString]];
    [urlString appendString:GetCommentPath];

    LoginManager *loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    
    NSString* nstopicId = [NSString stringWithFormat:@"%d",topicId];
    
    // base param
    NSMutableDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  sessionKey, SESSIONKEY_PARAM,
                                  nstopicId,TopicIdParam,nil];
    
    if(0!=lastCommentId)
    {
        NSString* nslastCommentId = [NSString stringWithFormat:@"%d",lastCommentId];
        [param setObject:nslastCommentId forKey:CommentIdParam];
    }
   
    return [self.requestOperator sendSingleGet:urlString paramDict:param];
    
}

//处理获取私信列表返回
-(void)handleGetComment:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        // parsing event list
        id foundValue = [data objectForKey:ItemsParam];
        if( nil == foundValue || foundValue == [NSNull null] ){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate operateSuccess:[NSNumber numberWithInteger:0] requestType:CommentRequestOperator_GetComment];
            });
            return;
        }
        if ([[data objectForKey:ItemsParam] isKindOfClass:[NSArray class]]
            && [[(NSArray*)[data objectForKey:ItemsParam] lastObject] isKindOfClass:[NSDictionary class]])
        {
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                NSInteger i = 0;
            //                for (NSDictionary* newsDic in (NSArray*)[data objectForKey:NewsTagItem])
            //                {
            //                    if(![NewsDataManager newsSentIsExist:[[NewsSentStory idWithDict:newsDic] intValue]])
            //                        i++;
            //                    [NewsDataManager newsSentWitdhDict:newsDic];
            //                }
            //                [CoreDataManager saveData];
            //                [_delegate operateFinish:[NSNumber numberWithInteger:i] requestType:NewsRequestOperator_UpdateSentNews];
            //            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate operateFail:@"parsing fail!" requestType:CommentRequestOperator_GetComment];
            });
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate operateFail:@"parsing fail!" requestType:CommentRequestOperator_GetComment];
        });
        
    }
}
//发起话题
-(BOOL)sendTopic:(NSString*)title body:(NSString*)body owner:(NSString*)owner ownerId:(NSString*)ownerId startTime:(long)start endTime:(long)end
{
    [self cancel];
    _status = CommentRequestOperator_SendTopic;
    
    NSMutableArray *postArray = [NSMutableArray array];
    //sessionkey
    LoginManager *loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    // sessionkey
    [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    // title
    [postArray addObject:[self.requestOperator buildPostParam:TitleParam  content:title]];
    //body
    [postArray addObject:[self.requestOperator buildPostParam:BodyParam  content:body]];
    //owner
    [postArray addObject:[self.requestOperator buildPostParam:OwnerParam  content:owner]];
    //ownerid
    [postArray addObject:[self.requestOperator buildPostParam:OwnerIdParam  content:ownerId]];
    //start
    NSString* startTime = [NSString stringWithFormat:@"%ld",start];
    [postArray addObject:[self.requestOperator buildPostParam:StartTimeParam  content:startTime]];
    //end
    NSString* endTime = [NSString stringWithFormat:@"%ld",end];
    [postArray addObject:[self.requestOperator buildPostParam:EndTimeParam  content:endTime]];
    
    return [self.requestOperator sendSinglePost:SendTopicPath paramArray:postArray];
}

//处理发起话题返回
-(void)handleSendTopic:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate operateSuccess:nil requestType:CommentRequestOperator_SendTopic];
    });
}

//发送私信
-(BOOL)sendComment:(NSInteger)topicId commentId:(NSInteger)commentId body:(NSString*)body
{
    [self cancel];
    _status = CommentRequestOperator_SendComment;

    NSMutableArray *postArray = [NSMutableArray array];
    //sessionkey
    LoginManager *loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0)
        sessionKey = loginmanager.sessionKey;
    // sessionkey
    [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    // topicid
    NSString* nstopicid = [NSString stringWithFormat:@"%d",topicId];
    [postArray addObject:[self.requestOperator buildPostParam:TopicIdParam  content:nstopicid]];
    //commentid
    NSString* nscommentid = [NSString stringWithFormat:@"%d",commentId];
    [postArray addObject:[self.requestOperator buildPostParam:CommentIdParam  content:nscommentid]];
    //body
    [postArray addObject:[self.requestOperator buildPostParam:BodyParam  content:body]];

    return [self.requestOperator sendSinglePost:SendTopicPath paramArray:postArray];
}

//处理发送私信返回
-(void)handleSendComment:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        // parsing event list
        id foundValue = [data objectForKey:ItemsParam];
        if( nil == foundValue || foundValue == [NSNull null] ){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate operateSuccess:[NSNumber numberWithInteger:0] requestType:CommentRequestOperator_GetComment];
            });
            return;
        }
        if ([[data objectForKey:ItemsParam] isKindOfClass:[NSArray class]]
            && [[(NSArray*)[data objectForKey:ItemsParam] lastObject] isKindOfClass:[NSDictionary class]])
        {
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                NSInteger i = 0;
            //                for (NSDictionary* newsDic in (NSArray*)[data objectForKey:NewsTagItem])
            //                {
            //                    if(![NewsDataManager newsSentIsExist:[[NewsSentStory idWithDict:newsDic] intValue]])
            //                        i++;
            //                    [NewsDataManager newsSentWitdhDict:newsDic];
            //                }
            //                [CoreDataManager saveData];
            //                [_delegate operateFinish:[NSNumber numberWithInteger:i] requestType:NewsRequestOperator_UpdateSentNews];
            //            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate operateFail:@"parsing fail!" requestType:CommentRequestOperator_GetComment];
            });
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate operateFail:@"parsing fail!" requestType:CommentRequestOperator_GetComment];
        });
        
    }

}

#pragma mark - HttpClientDelegate
- (void)requestFinish:(id)json {
    CommentRequestOperatorStatus status = _status;
    _status = CommentRequestOperator_None;
    
    // 把临时变量(autorelease)释放
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    // 根据当前请求类型进行解析回调
    switch(status) {
        case CommentRequestOperator_GetTopic:{
            [self handleGetTopic:json];
            break;
        }
        case CommentRequestOperator_GetComment:{
            [self handleGetComment:json];
            break;
        }
        case CommentRequestOperator_SendTopic:{
            [self handleSendTopic:json];
            break;
        }
        case CommentRequestOperator_SendComment:{
            [self handleSendComment:json];
            break;
        }
        default:break;
    }
    [pool drain];
}
- (void)requestFail:(NSString*)error {
    // 网络请求失败
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_delegate) {
            if([_delegate respondsToSelector:@selector(operateFail:requestType:)]){
                [_delegate operateFail:error requestType:_status];
            }
        }
    });
}


@end
