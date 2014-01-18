//
//  ResourceDownloadManager.m
//  DrPalm
//
//  Created by fgx_lion on 12-5-15.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "ResourceDownloadManager.h"
#import "DownloadManager.h"
#import "ResourceManager.h"
#import "ResourceManagerLanguageDef.h"
#import "UpdateResourceManager.h"
#import "ResourcePacketManager.h"

#pragma mark Path
#define CHECKPACKET_PATH    @"getclipkg"

#pragma mark Prarm

#define SCHOOLID_PARAM      @"schoolid"
#define TIMESTAMP_PARAM     @"lastmdate"
#define CLIENTTYPE_PARAM    @"numno"
#define IPHONE_TYPE @"10"
#define IPAD_TYPE   @"20"

#define PACKETDATA       @"packet"
#define GETPWDDATA       @"getpwd"
#define GETPWDURL        @"url"

#pragma mark Protocol
#define RESLIST      @"reslist"
#define RESNAME     @"resname"
#define URL         @"url"
#define VERIFYCODE  @"verifycode"
#define OPCODE      @"code"
#define OPRET       @"opret"            
#define OPFLAG      @"opflag"
#define OPSUCCESS   @"1"
#define OPFAIL      @"0"

#define TempPath            [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp"]
#define ToursPath           [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Tours"]

@implementation ResourcePacket
@synthesize resname = _resname;
@synthesize url = _url;
@synthesize verifyCode = _verifyCode;
@synthesize path = _path;
- (id)init
{
    self = [super init];
    if (nil != self){
        self.resname = nil;
        self.url = nil;
        self.verifyCode = nil;
        self.path = nil;

    }
    return self;
}

- (void)dealloc
{
    self.resname = nil;
    self.url = nil;
    self.verifyCode = nil;
    self.path = nil;
    [super dealloc];
}
@end

@interface ResourceDownloadManager()
@property (nonatomic, retain) DownloadManager*  downloadManager;
@property (nonatomic, retain) NSMutableArray*   delegates;

- (BOOL)isParsingOpretSuccess:(id)data error:(NSMutableString*)error;
- (void)handleCheckResourcePacket:(id)data;
- (NSArray*)parsingReslist:(id)data;
- (BOOL)downloadWithIndex:(NSInteger)index;
@end

@implementation ResourceDownloadManager
@synthesize delegates = _delegates;
@synthesize downloadManager = _downloadManager;
@synthesize resourcePackets = _resourcePackets;
@synthesize resourceTimestamp = _resourceTimestamp;
- (id)init
{
    self = [super init];
    if (nil != self){
        self.delegates = [NSMutableArray array];
        self.downloadManager = nil;
        self.resourcePackets = nil;
        self.resourceTimestamp = nil;
        _currResourcePacketIndex = 0;

        _requestOperator = [[CommonRequestOperator alloc] init];
        _requestOperator.delegate = self;
        
        
        
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self cancelCheck];
    [self stopDownload];

    self.downloadManager = nil;
    self.resourcePackets = nil;
    self.resourceTimestamp = nil;
    
    if(_requestOperator)
    {
        [_requestOperator cancel];
        [_requestOperator release];
        _requestOperator = nil;
    }
    
    [_lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    [self.delegates removeAllObjects];
    [_lock unlock];
    self.delegates = nil;
    
    if(_lock != nil)
    {
        [_lock release];
        _lock = nil;
    }
    [super dealloc];
}

#define ResourceDownLoadTempPath  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrPalm/packet"]
+ (NSString*)resourceDownLoadTempName:(NSString*)name
{
   // if([ResourceManager pathi ])
    if(![[NSFileManager defaultManager] fileExistsAtPath:ResourceDownLoadTempPath])
    {
        [ResourceManager createDir:ResourceDownLoadTempPath];
    }
    return [NSString stringWithFormat:@"%@/%@.%@", ResourceDownLoadTempPath, name, @"zip"];
}

+ (NSString*)resourcePacketWithName:(NSString*)name
{
    return [NSString stringWithFormat:@"%@/%@.%@", ResourcePacketPath, name, @"zip"];
}

+ (NSString*)resourcePacketPathWithFileName:(NSString*)filename
{
    return [NSString stringWithFormat:@"%@/%@", ResourcePacketPath, filename];
}

#pragma mark - delegates
- (void)addDelegate:(id<ResourceDownloadManagerDelegate>)delegate
{
    [_lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    [self.delegates addObject:delegate];
    [_lock unlock];
}

- (void)removeDelegate:(id<ResourceDownloadManagerDelegate>)delegate
{
    [_lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    [self.delegates removeObject:delegate];
    [_lock unlock];
}

#pragma mark - Check new resource packet
- (BOOL)checkResourcePacket:(NSString*)timestamp;
{
    [self stopDownload];
    [self cancelCheck];

    return [_requestOperator getClientPkg:timestamp];

}


- (void)handleCheckResourcePacket:(id)data
{
    DrPalmGateWayManager* gatewayManager = DrPalmGateWayManagerInstance();
    gatewayManager.getPwdUrl = @"";
    NSMutableString *error = [NSMutableString string];
    if ([data isKindOfClass:[NSDictionary class]]){
        if (![self isParsingOpretSuccess:data error:error]){
            // 服务器返回失败
            for (id<ResourceDownloadManagerDelegate> delegate in self.delegates) {
                if ([delegate respondsToSelector:@selector(checkFail:error:)]){
                    [delegate checkFail:self error:error];
                }
            }
        }
        else{
            // 成功
            //解析资源包数据
            id packetdata = [data objectForKey:PACKETDATA];
            if([packetdata isKindOfClass:[NSDictionary class]])
            {
                if([self isParsingOpretSuccess:packetdata error:error])
                {
                    id timestampdata = [packetdata objectForKey:TIMESTAMP_PARAM];
                    if([timestampdata isKindOfClass:[NSNumber class]])
                    {
                        self.resourceTimestamp = [timestampdata stringValue];
                    }
                    else if([timestampdata isKindOfClass:[NSString class]])
                        self.resourceTimestamp = timestampdata;

                    self.resourcePackets = [self parsingReslist:[packetdata objectForKey:RESLIST]];
//                    for (id<ResourceDownloadManagerDelegate> delegate in self.delegates) {
//                        if ([delegate respondsToSelector:@selector(checkFinish:hasNewPacket:)]){
//                            [delegate checkFinish:self hasNewPacket:([self.resourcePackets count] > 0)];
//                        }
//                    }
                    [self startDownload];

                }
                else{
                    //无资源包更新
                    for (id<ResourceDownloadManagerDelegate> delegate in self.delegates) {
                        if ([delegate respondsToSelector:@selector(checkFinish:hasNewPacket:)]){
                            [delegate nopackDownLoad];
                        }
                    }
                }
            }
            
            //getPwdUrl
            
            id getpwddata = [data objectForKey:GETPWDDATA];
            if([getpwddata isKindOfClass:[NSDictionary class]])
            {
                if([self isParsingOpretSuccess:getpwddata error:error])
                {
                    id url = [getpwddata objectForKey:GETPWDURL];
                    if([url isKindOfClass:[NSString class]])
                    {
                        gatewayManager.getPwdUrl = url;
                    }
                }

            }

        }
    }
}

- (NSArray*)parsingReslist:(id)data
{
    NSMutableArray *reslist = [NSMutableArray array];
    if ([data isKindOfClass:[NSArray class]]){
        for (NSDictionary* resDict in data) {
            ResourcePacket *packet = [[[ResourcePacket alloc] init] autorelease];
            id value = [resDict objectForKey:RESNAME];
            if ([value isKindOfClass:[NSString class]]){
                packet.resname = value;
            }
            
            value = [resDict objectForKey:URL];
            if ([value isKindOfClass:[NSString class]]){
                packet.url = value;
            }
            
            value = [resDict objectForKey:VERIFYCODE];
            if ([value isKindOfClass:[NSString class]]){
                packet.verifyCode = value;
            }

            [reslist addObject:packet];
        }
    }
    return reslist;
}

- (void)cancelCheck
{
    self.resourcePackets = nil;
    self.resourceTimestamp = nil;
}

#pragma mark - Download resource packet

- (BOOL)startDownload
{
    BOOL result = NO;
    if (nil == self.downloadManager && [self.resourcePackets count] > 0){
        [self downloadWithIndex:0];
        result = YES;
    }
    return result;
}

- (BOOL)downloadWithIndex:(NSInteger)index
{
    _currResourcePacketIndex = index;
    ResourcePacket* packet = [self.resourcePackets objectAtIndex:_currResourcePacketIndex];
    self.downloadManager = [[[DownloadManager alloc] init] autorelease];
    return [self.downloadManager startDownload:packet.url delegate:self];
}

- (void)stopDownload
{
    //self.downloadManager = nil;
    [self.downloadManager stopDownload];
    _currResourcePacketIndex = 0;
}

-(BOOL)isParsingOpretSuccess:(id)data error:(NSMutableString*)error
{
    BOOL success = NO;
    if ([data isKindOfClass:[NSDictionary class]]){
        NSDictionary *opretDict = [data objectForKey:OPRET];
        if(nil != opretDict){
            NSString *opflagStr = [opretDict objectForKey:OPFLAG];
            int flag = [opflagStr integerValue];
            if(nil == opflagStr || flag == 1){
                success = YES;
            }
            else{
                NSString *opCode = [opretDict objectForKey:OPCODE];
                if ([opCode isEqualToString:InvalidSessionKey]){
                    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"LoginSessionTimeOut", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil, nil] autorelease];
                    [alertView show];
                    [LoginManagerInstance() logout];
                }
                else if (nil != opCode){
                    [error setString:ErrorCodeToString(opCode)];
                }
            }
        }
    }
    return success;
}

//#pragma mark - JSONLoadedDelegate
//- (void)request:(MITMobileWebAPI *)request jsonLoaded:(id)result
//{
//    self.apiRequest = nil;
//    [self handleCheckResourcePacket:result];
//}
//
//- (BOOL)request:(MITMobileWebAPI *)request shouldDisplayStandardAlertForError: (NSError *)error
//{
//    return NO;
//}
//
//- (void)handleConnectionFailureForRequest:(MITMobileWebAPI *)request
//{
//    self.apiRequest = nil;
//    for (id<ResourceDownloadManagerDelegate> delegate in self.delegates) {
//        if ([delegate respondsToSelector:@selector(checkFail:error:)]){
//            [delegate checkFail:self error:@"parsing fail!"];
//        }
//    }
//}

#pragma mark - DownloadManagerDelegate
- (void)downloadManager:(DownloadManager*)downloadManager downloadFinish:(NSData*)data contentType:(NSString*)contentType
{
    // 校验是否完整
    ResourcePacket *packet = [self.resourcePackets objectAtIndex:_currResourcePacketIndex];
    if (![[data toMD5String] isEqualToString:[packet.verifyCode lowercaseString]])
    {
        // 包不完整
        for (id<ResourceDownloadManagerDelegate> delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(downloadFail:packet:error:)]){
                [delegate downloadFail:self packet:packet error:ResourceManagerVerifyFail];
            }
        }
        return;
    }
    
    // 写入文件
    packet.path = [ResourceDownloadManager resourceDownLoadTempName:packet.resname];
    [data writeToFile:packet.path atomically:YES];
    
    //解压
    ZipArchive* zip = [[ZipArchive alloc] init];
    
    DrPalmGateWayManager* gateWayManager = DrPalmGateWayManagerInstance();
    //NSString* schoolid = gateWayManager.schoolId;
    NSString* schoolkey = gateWayManager.schoolKey;
    
    NSString* toursPath = [ResourceDownloadManager toursPath];
    NSString* zipPath = [NSString stringWithFormat:@"%@/%@",toursPath,schoolkey];
    
    BOOL success = NO;
    if ([zip UnzipOpenFile:packet.path]){
       success = [zip UnzipFileTo:zipPath overWrite:YES];
        [zip UnzipCloseFile];
    }
    [zip release];
    //解压成功，纪录资源包信息
    if(success)
    {
        // 删除旧包
        [[NSFileManager defaultManager] removeItemAtPath:packet.path error:nil];
        
        ResourcePacketManager* resPacketManager = ResourcePacketManagerInstance() ;
        ResourcePacketInfo *resPacketInfo = [[[ResourcePacketInfo alloc] init] autorelease];
        resPacketInfo.schoolkey = schoolkey;
//        resPacketInfo.resourcepath = zipPath;
        resPacketInfo.timestamp = self.resourceTimestamp;
        resPacketManager.resPacketInfo = resPacketInfo;
    }
    

    //BOOL bResult = [UpdateResourceManager updateResourceWithPacket:packet.path resourcePacket:[ResourceManager resourcePath]];
    
    ++_currResourcePacketIndex;
    
    // 回调downloadFinish
    for (id<ResourceDownloadManagerDelegate> delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(downloadFinish:packet:left:)]){
            [delegate downloadFinish:self packet:packet left:[self.resourcePackets count] - _currResourcePacketIndex];
        }
    }
    
    if (_currResourcePacketIndex < [self.resourcePackets count]){
        // 下载下一个包
        [self downloadWithIndex:_currResourcePacketIndex];
        
    }
}

- (void)downloadManager:(DownloadManager *)downloadManager downloadFail:(NSError*)error
{
    ResourcePacket *packet = [self.resourcePackets objectAtIndex:_currResourcePacketIndex];
    for (id<ResourceDownloadManagerDelegate> delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(downloadFail:packet:error:)]){
            [delegate downloadFail:self packet:packet error:[error description]];
        }
    }
}

- (void)downloadManager:(DownloadManager*)downloadManager downloadProcess:(NSInteger)processed total:(NSInteger)total
{
    ResourcePacket *packet = [self.resourcePackets objectAtIndex:_currResourcePacketIndex];
    for (id<ResourceDownloadManagerDelegate> delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(downloadProcess:packet:processed:total:)]){
            [delegate downloadProcess:self packet:packet processed:processed total:total];
        }
    }
}

#pragma mark - 协议回调 (CommonRequestOperatorDelegate)
-(void)requestFinish:(id)data requestType:(CommonRequestOperatorStatus)type
{
    [self handleCheckResourcePacket:data];
    return ;
}
-(void)requestFail:(NSString*)error requestType:(CommonRequestOperatorStatus)type
{
    if(type == CommonRequestOperatorStatus_GetCliPkg)
    {
        for (id<ResourceDownloadManagerDelegate> delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(checkFinish:hasNewPacket:)]){
                [delegate nopackDownLoad];
            }
        }
    }
    return;
}

+ (NSString*)toursPath {
    return ToursPath;
}

+ (NSString*)tempPath {
    if ([ResourceManager createDir:TempPath]) {
        return TempPath;
    }
    return nil;
}
+ (NSString*)toursPathWithSchoolKey
{
    NSString* path = @"";
    DrPalmGateWayManager* gateWayManager = DrPalmGateWayManagerInstance();
    NSString* schoolkey = gateWayManager.schoolKey;
    
    NSString* toursPath = [ResourceDownloadManager toursPath];
    path = [NSString stringWithFormat:@"%@/%@",toursPath,schoolkey];
    return path;
}
@end
