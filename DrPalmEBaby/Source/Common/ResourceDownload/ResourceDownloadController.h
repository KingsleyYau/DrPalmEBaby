//
//  ResourceDownloadController.h
//  DrPalm
//
//  Created by fgx_lion on 12-5-18.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceDownloadManager.h"

@class LoadingView;
@class ResourceDownloadController;
@protocol ResourceDownloadControllerDelegate <NSObject> 
- (void)handleFinish:(ResourceDownloadController*)controller success:(BOOL)success;

- (void)checkFinish:(ResourceDownloadManager*)resourceDownloadManager hasNewPacket:(BOOL)hasNewPacket;
@end

@interface ResourceDownloadController : UIViewController<ResourceDownloadManagerDelegate, UIAlertViewDelegate>
{
    UIWindow*   _statusWindow;
    UIProgressView* _progressView;
    LoadingView *_loadingView;
    UIButton    *_cancelButton;
    BOOL    _reset;
    
    ResourceDownloadManager*    _resourceDownloadManager;
    id<ResourceDownloadControllerDelegate>  _delegate;
}
@property (nonatomic, retain) ResourceDownloadManager*  resourceDownloadManager;
@property (nonatomic, assign) id<ResourceDownloadControllerDelegate>   delegate;
- (BOOL)showAndStartDownload:(BOOL)reset;
- (void)dismissAndStopDownload;
@end
