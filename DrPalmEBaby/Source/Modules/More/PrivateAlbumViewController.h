//
//  PrivateAlbumViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareDetailViewController.h"
@class SchoolNews;
@interface PrivateAlbumViewController : ShareDetailViewController <ShareItemDelegate, PZPagingScrollViewDelegate>

@property (nonatomic, weak) IBOutlet PZPagingScrollView *pzPagingScrollView;
@property (nonatomic, weak) IBOutlet DynamicContainView *dynamicContainView;
@property (nonatomic, weak) IBOutlet UIView *buttonBar;
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIButton *batDownloadButton;

@property (nonatomic, strong) LoadingView *loadingView;

- (IBAction)downloadAction:(id)sender;
- (IBAction)downloadBatAction:(id)sender;
@end
