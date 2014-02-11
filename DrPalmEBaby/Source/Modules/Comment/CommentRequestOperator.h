//
//  CommentRequestOperator.h
//  DrPalm
//
//  Created by JiangBo on 12-12-5.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
//#import "MITMobileWebAPI.h"
#import "RequestOperator.h"


typedef enum{
    CommentRequestOperator_None,
    CommentRequestOperator_GetTopic,
    CommentRequestOperator_GetComment,
    CommentRequestOperator_SendTopic,
    CommentRequestOperator_SendComment,
    
}CommentRequestOperatorStatus;

@protocol CommentRequestOperatorDelegate <NSObject>
-(void)operateSuccess:(id)data requestType:(CommentRequestOperatorStatus) status;
-(void)operateFail:(NSString*)error requestType:(CommentRequestOperatorStatus) status;
@end


@interface CommentRequestOperator : NSObject <RequestOperatorDelegate>
{
    CommentRequestOperatorStatus _status;
    RequestOperator *_requestOperator;
}

@property (nonatomic,assign) id<CommentRequestOperatorDelegate> delegate;
- (void)cancel;

//获取话题列表
-(BOOL)getTopic:(NSInteger) lasttopicId;
//获取私信列表
-(BOOL)getComment:(NSInteger)topicId lastcommentId:(NSInteger)lastCommentId;
//发起话题
-(BOOL)sendTopic:(NSString*)title body:(NSString*)body owner:(NSString*)owner ownerId:(NSString*)ownerId startTime:(long)start endTime:(long)end;
//发送私信
-(BOOL)sendComment:(NSInteger)topicId commentId:(NSInteger)commentId body:(NSString*)body;

@end
