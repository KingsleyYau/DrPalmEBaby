//
//  ClassCreateOrgHandler.m
//  DrPalm
//
//  Created by fgx_lion on 13-02-17.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "ClassCreateOrgHandler.h"
#import "ClassDataManager.h"
#import "ClassModuleDefine.h"
#import "LoginManager.h"
#import "MITJSON.h"
#import "ResourceDownloadManager.h"

@interface ClassCreateOrgHandler()
@property (nonatomic, retain) RequestOperator   *requestOperator;
@property (nonatomic, retain) DownloadManager   *downloadManager;
@property (nonatomic, retain) NSString* zipUrl;
@property (nonatomic, retain) NSString* zipChecksum;
@property (nonatomic, retain) NSString* zipFileName;
@property (nonatomic ,retain) NSArray*  topOrgs;

- (BOOL)getOrgInfo;
- (void)handleGetOrgInfo:(id)data;
- (void)cancelRequest;
- (void)parsingOrgJson:(id)data;
@end

@implementation ClassCreateOrgHandler
@synthesize delegate = _delegate;
@synthesize requestOperator = _requestOperator;
@synthesize downloadManager = _downloadManager;
@synthesize zipUrl = _zipUrl;
@synthesize zipChecksum = _zipChecksum;
@synthesize zipFileName = _zipFileName;
@synthesize selfOrgId = _selfOrgId;

- (id)init
{
    self = [super init];
    if (nil != self){
        self.delegate = nil;
        self.requestOperator = nil;
        self.downloadManager = nil;
        self.zipUrl = nil;
        self.zipChecksum = nil;
        self.zipFileName = nil;
        self.topOrgs = nil;
        _lastupdate = 0;
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    
    [self stop];
    [super dealloc];
}

- (BOOL)start
{
    BOOL result = NO;
    
    [self stop];
    
    // 初始化变量
    self.zipUrl = nil;
    self.zipChecksum = nil;
    _lastupdate = 0;
    self.zipFileName = nil;
    
    // 开始请求
    if ([self.delegate respondsToSelector:@selector(startRequest:)]) {
        [self.delegate startRequest:self];
    }
    
    [self getOrgInfo];
    return result;
}

- (BOOL)stop
{
    [self cancelRequest];
    [self.downloadManager stopDownload];
    self.downloadManager = nil;
    self.zipUrl = nil;
    self.zipChecksum = nil;
    self.zipFileName = nil;
    self.topOrgs = nil;
    return YES;
}

- (void)cancelRequest
{
    [self.requestOperator cancel];
    self.requestOperator = nil;
}

#pragma mark - Http回调 (HttpClientDelegate)
- (void)requestFinish:(id)json
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    [self handleGetOrgInfo:json];
    [pool drain];
}

- (void)requestFail:(NSString*)error {
    // 网络请求失败
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.delegate) {
            if([self.delegate respondsToSelector:@selector(createOrgFail:error:)]){
                [self.delegate createOrgFail:self error:error];
            }
        }
    });
}

#pragma mark - DownloadManagerDelegate
- (void)downloadManager:(DownloadManager*)downloadManager downloadFinish:(NSData*)data contentType:(NSString*)contentType
{
    if ([self.delegate respondsToSelector:@selector(downloadFinish:)]) {
        [self.delegate downloadFinish:self];
    }

    BOOL success = NO;
    
    // 判断校验下载文件是否完整
    if ([[data toMD5String] isEqualToString:[self.zipChecksum lowercaseString]]) {
        // 创建临时目录
        NSString* orgDirPath = [NSString stringWithFormat:@"%@%@", [ResourceDownloadManager tempPath], @"/org"];
        [ResourceManager createDir:orgDirPath];
        
        // 保存zip文件
        NSString* orgZipFilePath = [NSString stringWithFormat:@"%@/%@", orgDirPath, self.zipFileName];
        success = [data writeToFile:orgZipFilePath atomically:YES];

        // 解压文件
        NSString* orgUnzipFilePath = [NSString stringWithFormat:@"%@/unzip_%d", orgDirPath, _lastupdate];
        if (success) {
            ZipArchive* zip = [[ZipArchive alloc] init];
            if ([zip UnzipOpenFile:orgZipFilePath]){
                success = [zip UnzipFileTo:orgUnzipFilePath overWrite:YES];
                [zip UnzipCloseFile];
            }
            [zip release];
        }
        
        // 读取解压文件并解析json
        if (success) {
            NSString* fileName = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:orgUnzipFilePath error:nil] lastObject];
            NSString* filePath = [NSString stringWithFormat:@"%@/%@", orgUnzipFilePath, fileName];
            NSData* jsonData = [NSData dataWithContentsOfFile:filePath];
            id json = [MITJSON objectWithJSONData:jsonData];
            if (nil != json) {
                // 解析json
                [self parsingOrgJson:json];
                
                // 更新用户可显示的顶点组织入库
                [ClassDataManager updateUserTopOrgWithOrgIDs:self.topOrgs];
            }
            else {
                success = NO;
            }
        }
        
        // 删除临时目录
        [ResourceManager removeDir:orgDirPath];
    }
    
    // 不成功
    if (!success) {
        if ([self.delegate respondsToSelector:@selector(createOrgFail:error:)]) {
            [self.delegate createOrgFail:self error:nil];
        }
    }
}

- (void)downloadManager:(DownloadManager *)downloadManager downloadFail:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(downloadFail:error:)]) {
        [self.delegate downloadFail:self error:error];
    }
    
    if ([self.delegate respondsToSelector:@selector(createOrgFail:error:)]) {
        [self.delegate createOrgFail:self error:nil];
    }
}

- (void)downloadManager:(DownloadManager*)downloadManager downloadProcess:(NSInteger)processed total:(NSInteger)total
{
    if ([self.delegate respondsToSelector:@selector(downloadProcess:packet:processed:total:)]) {
        [self.delegate downloadProcess:self processed:processed total:total];
    }
}

#pragma mark - 组织结构
//组织结构获取
- (BOOL)getOrgInfo
{
    [self cancelRequest];
    
    self.requestOperator = [[[RequestOperator alloc] init] autorelease];
    self.requestOperator.delegate = self;
    
    LoginManager* loginmanager = LoginManagerInstance();
    NSString *sessionKey = @"";
    if(loginmanager.sessionKey.length > 0) {
        sessionKey = loginmanager.sessionKey;
    }
    
    NSString *lastupdate = @"0";
    NSDate* lastupdateDate = [ClassDataManager getOrgLastupdate];
    if (nil != lastupdateDate) {
        lastupdate = [NSString stringWithFormat:@"%d", (NSInteger)[lastupdateDate timeIntervalSince1970]];
    }
    
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sessionKey, SESSION_KEY,
                                      lastupdate, GetOrgInfo_Lastupdate,
                                      nil];
    
    return [self.requestOperator sendSingleGet:GetOrgInfo_Path paramDict:paramDict];
}

// 处理获取组织结构返回
- (void)handleGetOrgInfo:(id)data
{
    BOOL isDownload = NO;
    if ([data isKindOfClass:[NSDictionary class]]) {
        isDownload = YES;
        id value = nil;
        
        // 解析url
        value = [data objectForKey:GetOrgInfo_URL];
        if ([value isKindOfClass:[NSString class]]) {
            self.zipUrl = value;
        }
        else {
            isDownload = NO;
        }
        
        // 解析checksum
        value = [data objectForKey:GetOrgInfo_CheckSum];
        if ([value isKindOfClass:[NSString class]]) {
            self.zipChecksum = value;
        }
        else {
            isDownload = NO;
        }
        
        // 解析lastupdate
        value = [data objectForKey:GetOrgInfo_Lastupdate];
        if ([value isKindOfClass:[NSNumber class]]) {
            _lastupdate = [value integerValue];
        }
        else  {
            isDownload = NO;
        }
        
        //解析selforgid
        value = [data objectForKey:GetOrgInfo_SelfOrgid];
        if([value isKindOfClass:[NSString class]]){
            self.selfOrgId = value;
        }else{
            isDownload = NO;
        }
        
        // 解析toporgs
        value = [data objectForKey:GetOrgInfo_TopOrgs];
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray* orgIDs = [NSMutableArray array];
            for (NSDictionary* orgidDict in value) {
                value = [orgidDict objectForKey:GetOrgInfo_TopOrgID];
                if ([value isKindOfClass:[NSString class]]) {
                    [orgIDs addObject:value];
                }
            }
            self.topOrgs = [NSArray arrayWithArray:orgIDs];
        }
    }
    
    // 找出zip文件名
    NSRange range = [self.zipUrl rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        self.zipFileName = [self.zipUrl substringFromIndex:range.location+1];
    }
    
    // 需要下载
    if (isDownload) {
        self.downloadManager = [[[DownloadManager alloc] init] autorelease];
        [self.downloadManager startDownload:self.zipUrl delegate:self];
        
        if ([self.delegate respondsToSelector:@selector(downloadStart:)]) {
            [self.delegate downloadStart:self];
        }
    }
    else {
        // 更新用户可显示的顶点组织入库
        [ClassDataManager updateUserTopOrgWithOrgIDs:self.topOrgs];
        
        if ([self.delegate respondsToSelector:@selector(downloadFinish:)]) {
            [self.delegate createOrgFinish:self];
        }
    }
}

// 解析组织架构json
- (void)parsingOrgJson:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
        id orglist = [data objectForKey:GetOrgInfo_OrgList];
        if ([orglist isKindOfClass:[NSArray class]]) {
            // 解析成功，清空数据库中的所有组织节点
            [ClassDataManager removeAllOrg];
            
            // 创建根节点
            ClassOrg* topOrg = [ClassDataManager orgWithID:OrgTopDefaultValue];
            topOrg.lastupdate = [NSDate dateWithTimeIntervalSince1970:_lastupdate];
            
            // 组织节点入库
            for (NSDictionary* orgItem in orglist) {
                [ClassDataManager orgWithDict:orgItem];
            }
            
            // 构建路径
            [ClassDataManager createOrgPath];
            
            // 计算所有叶子节点数
            [ClassDataManager countLeafOrg];
            
            // 保存数据
            [CoreDataManager saveData];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate createOrgFinish:self];
    });
}

@end
