//
//  ClassAlbumnDetailViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareDetailViewController.h"
#import "ClassDetailInfoTableView.h"

@class ClassEvent;
@interface ClassAlbumnDetailViewController : ShareDetailViewController <ShareItemDelegate, ClassDetailInfoTableViewDelegate, PZPagingScrollViewDelegate>

@property (nonatomic, weak) IBOutlet PZPagingScrollView *pzPagingScrollView;
@property (nonatomic, weak) IBOutlet DynamicContainView *dynamicContainView;
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIButton *batDownloadButton;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;

@property (nonatomic, strong) ClassDetailInfoTableView *tableView;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, retain) ClassEvent *item;
@property (nonatomic, assign) BOOL needLoadAllDetail;
@property (nonatomic, assign) BOOL isLoadFromServer;

- (IBAction)downloadAction:(id)sender;
- (IBAction)downloadBatAction:(id)sender;
- (IBAction)bookmarkAction:(id)sender;
- (IBAction)commentAction:(id)sender;
@end
