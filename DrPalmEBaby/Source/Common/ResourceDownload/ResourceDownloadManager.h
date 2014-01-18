//
//  ResourceDownloadManager.h
//  DrPalm
//
//  Created by fgx_lion on 12-5-15.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadManager.h"
#import "CommonRequestOperator.h"

#define ResourcePacketPath  [ResourceManager resourceFilePath:@"packet"]

@interface ResourcePacket : NSObject {
@private
    NSString*   _resname;
    NSString*   _url;
    NSString*   _verifyCode;
    NSString*   _path;
}
@property (nonatomic, retain) NSString* resname;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* verifyCode;
@property (nonatomic, retain) NSString* path;
@end

@class ResourceDownloadManager;
@protocol ResourceDownloadManagerDelegate <NSObject>
@optional
- (void)checkFinish:(ResourceDownloadManager*)resourceDownloadManager hasNewPacket:(BOOL)hasNewPacket;
- (void)checkFail:(ResourceDownloadManager*)resourceDownloadManager error:(NSString*)error;
- (void)downloadFinish:(ResourceDownloadManager*)resourceDownloadManager packet:(ResourcePacket*)packet left:(NSInteger)left;
- (void)downloadFail:(ResourceDownloadManager*)resourceDownloadManager packet:(ResourcePacket*)packet error:(NSString*)error;
- (void)downloadProcess:(ResourceDownloadManager*)resourceDownloadManager packet:(ResourcePacket*)packet processed:(NSInteger)processed total:(NSInteger)total;
- (void)nopackDownLoad;
@end

@interface ResourceDownloadManager : NSObject<DownloadManagerDelegate,CommonRequestOperatorDelegate>
{
    NSMutableArray*     _delegates;
    DownloadManager*    _downloadManager;
    NSArray*    _resourcePackets;
    NSInteger   _currResourcePacketIndex;
    NSString*   _resourceTimestamp;
    CommonRequestOperator* _requestOperator;
    NSLock*     _lock;
}

@property (nonatomic, retain) NSArray*  resourcePackets;
@property (nonatomic, retain) NSString* resourceTimestamp;

- (void)addDelegate:(id<ResourceDownloadManagerDelegate>)delegate;
- (void)removeDelegate:(id<ResourceDownloadManagerDelegate>)delegate;

- (BOOL)checkResourcePacket:(NSString*)timestamp;
//- (BOOL)checkResourcePacket:(NSInteger)timestamp;
- (void)cancelCheck;
- (BOOL)startDownload;
- (void)stopDownload;

+ (NSString*)resourceDownLoadTempName:(NSString*)name;
+ (NSString*)resourcePacketWithName:(NSString*)name;
+ (NSString*)resourcePacketPathWithFileName:(NSString*)filename;

+ (NSString*)toursPath;
+ (NSString*)tempPath;
+ (NSString*)toursPathWithSchoolKey;
@end
