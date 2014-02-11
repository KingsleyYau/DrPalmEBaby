//
//  ResourceDownloadController.m
//  DrPalm
//
//  Created by fgx_lion on 12-5-18.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "ResourceDownloadController.h"
#import "ResourceManager.h"
#import "UpdateResourceManager.h"
#import "ResourceManagerLanguageDef.h"

#define ResetAlertViewTag   100010

@interface ResourceDownloadController()
@property (nonatomic, retain) UIWindow*     statusWindow;
@property (nonatomic, retain) UIProgressView*   progressView;
@property (nonatomic, retain) LoadingView*  loadingView;
@property (nonatomic, retain) UIButton*     cancelButton;

- (void)resetApplication;
- (void)cancelAction:(id)sender;
@end

@implementation ResourceDownloadController
@synthesize resourceDownloadManager = _resourceDownloadManager;
@synthesize delegate = _delegate;
@synthesize statusWindow = _statusWindow;
@synthesize progressView = _progressView;
@synthesize loadingView = _loadingView;
@synthesize cancelButton = _cancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.resourceDownloadManager = nil;
        self.delegate = nil;
        
        // 状态栏
        UIApplication *application = [UIApplication sharedApplication];
        self.statusWindow = [[[UIWindow alloc] initWithFrame:application.statusBarFrame] autorelease];
        self.statusWindow.windowLevel = UIWindowLevelStatusBar;
        self.statusWindow.backgroundColor = [UIColor blackColor];
        self.statusWindow.hidden = YES;
        
        CGFloat step = 5;
        // 进度条
        CGFloat progressWidth = self.statusWindow.bounds.size.width - self.statusWindow.bounds.size.height - step*2;
        self.progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
        self.progressView.frame = CGRectMake(0, 0, progressWidth, self.progressView.bounds.size.height);
        self.progressView.center = CGPointMake(self.progressView.center.x, self.statusWindow.bounds.size.height/2);
        [self.statusWindow addSubview:self.progressView];
        
        // 取消button
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [UIImage imageNamedWithData:[ResourceManager resourceFilePath:@"global/icon-delete.png"]];
        self.cancelButton.frame = CGRectMake(progressWidth + step, 0, self.statusWindow.bounds.size.height, self.statusWindow.bounds.size.height);
        [self.cancelButton setImage:buttonImage forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.statusWindow addSubview:self.cancelButton];
        
        // 默认不重启
       // _reset = NO;
    }
    return self;
}

- (void)dealloc
{
    self.resourceDownloadManager = nil;
    self.statusWindow = nil;
    self.cancelButton = nil;
    self.loadingView = nil;
    self.delegate = nil;
    [super dealloc];
}

- (BOOL)showAndStartDownload:(BOOL)reset
{
    BOOL result = [_resourceDownloadManager startDownload];
    if (result){
        _reset = reset;
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        self.statusWindow.hidden = NO;
        self.loadingView = [[[LoadingView alloc] init] autorelease];
//        [self.loadingView showLoading:MITAppDelegate().tabBarController.view animated:NO];
    }
    else {
        [self dismissAndStopDownload];
    }
    return result;
}

- (void)dismissAndStopDownload
{
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    self.statusWindow.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [self.resourceDownloadManager stopDownload];
    self.resourceDownloadManager = nil;
}

#pragma mark -
- (void)setResourceDownloadManager:(ResourceDownloadManager *)resourceDownloadManager
{
    [_resourceDownloadManager removeDelegate:self];
    [_resourceDownloadManager release];
    _resourceDownloadManager = [resourceDownloadManager retain];
    [_resourceDownloadManager addDelegate:self];
}

- (void)resetApplication
{
    UILocalNotification *localNotification = [[[UILocalNotification alloc] init] autorelease];
    
    // Current date
    NSDate *date = [NSDate date]; 
    
    // Add one second to the current time
    NSDate *dateToFire = [date dateByAddingTimeInterval:1];
    
    // Set the fire date/time
    [localNotification setFireDate:dateToFire];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];    
    
    // Setup alert notification
    [localNotification setAlertBody:ResourceManagerUpdateSuccess];
    [localNotification setAlertAction:ResourceManagerReset];
    [localNotification setHasAction:YES];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    exit(0);
}

#pragma mark - Action
- (void)cancelAction:(id)sender
{
    [self dismissAndStopDownload];
    [self.delegate handleFinish:self success:YES];
}

#pragma mark - ResourceDownloadManagerDelegate

- (void)checkFinish:(ResourceDownloadManager*)resourceDownloadManager hasNewPacket:(BOOL)hasNewPacket
{
    if ([self.delegate respondsToSelector:@selector(checkFinish:hasNewPacket:)]){
        [self.delegate checkFinish:resourceDownloadManager hasNewPacket:hasNewPacket];
    }
    return;
}
- (void)nopackDownLoad
{
    [self.loadingView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(handleFinish:success:)]){
        [self.delegate handleFinish:self success:YES];
    }
    return;
}

- (void)downloadFinish:(ResourceDownloadManager *)resourceDownloadManager packet:(ResourcePacket *)packet left:(NSInteger)left
{
    if (0 != left){
        // 没下载完
        return;
    }
    //完成
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    self.statusWindow.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    if ([self.delegate respondsToSelector:@selector(handleFinish:success:)]){
        [self.delegate handleFinish:self success:YES];
    }
    
    // 下载完
    //self.resourceDownloadManager = nil;    
}

- (void)downloadFail:(ResourceDownloadManager*)resourceDownloadManager packet:(ResourcePacket*)packet error:(NSString*)error
{
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                     message:ResourceManagerUpdateFail
                                                    delegate:nil cancelButtonTitle:ResourceManagerOK
                                           otherButtonTitles:nil] autorelease];
    [alert show];
    [self dismissAndStopDownload];
    
    if ([self.delegate respondsToSelector:@selector(handleFinish:success:)]){
        [self.delegate handleFinish:self success:NO];
    }
}

- (void)downloadProcess:(ResourceDownloadManager*)resourceDownloadManager packet:(ResourcePacket*)packet processed:(NSInteger)processed total:(NSInteger)total
{
    [self.progressView setProgress:(CGFloat)processed/(CGFloat)total];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 重启程序
    if (ResetAlertViewTag == alertView.tag){
        [self resetApplication];
    }
}

@end
