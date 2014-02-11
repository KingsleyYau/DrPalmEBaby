//
//  ClassCreateOrgHandler.h
//  DrPalm
//
//  Created by fgx_lion on 13-02-17.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestOperator.h"
#import "DownloadManager.h"

@class ZipArchive;
@class ClassCreateOrgHandler;
@protocol ClassCreateOrgHandlerDelegate <NSObject>
@optional
- (void)startRequest:(ClassCreateOrgHandler*)handler;
- (void)createOrgFinish:(ClassCreateOrgHandler*)handler;
- (void)createOrgFail:(ClassCreateOrgHandler*)handler error:(NSString*)error;
- (void)downloadStart:(ClassCreateOrgHandler*)handler;
- (void)downloadProcess:(ClassCreateOrgHandler*)handler processed:(NSInteger)processed total:(NSInteger)total;
- (void)downloadFinish:(ClassCreateOrgHandler*)handler;
- (void)downloadFail:(ClassCreateOrgHandler*)handler error:(NSError*)error;
@end

@interface ClassCreateOrgHandler : NSObject <RequestOperatorDelegate, DownloadManagerDelegate>
{
    id<ClassCreateOrgHandlerDelegate>  _delegate;
    RequestOperator     *_requestOperator;
    DownloadManager     *_downloadManager;
    NSString*   _zipUrl;
    NSString*   _zipChecksum;
    NSUInteger  _lastupdate;
    NSString*   _zipFileName;
    NSArray*    _topOrgs;
    NSString*   _selfOrgId;
}
@property (nonatomic, assign) id<ClassCreateOrgHandlerDelegate>    delegate;
@property (nonatomic, retain) NSString* selfOrgId;
- (BOOL)start;
- (BOOL)stop;
@end
