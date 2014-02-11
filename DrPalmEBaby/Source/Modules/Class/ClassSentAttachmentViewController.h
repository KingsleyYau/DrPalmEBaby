//
//  ClassSentAttachmentViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareDetailViewController.h"
#import "ClassDetailSentInfoTableView.h"

@class ClassEventSent;
@interface ClassSentAttachmentViewController : ShareDetailViewController <ShareItemDelegate, ClassDetailSentInfoTableViewDelegate, PZPagingScrollViewDelegate>

@property (nonatomic, weak) IBOutlet PZPagingScrollView *pzPagingScrollView;
@property (nonatomic, weak) IBOutlet DynamicContainView *dynamicContainView;
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIButton *batDownloadButton;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;

@property (nonatomic, strong) ClassDetailSentInfoTableView *tableView;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, retain) ClassEventSent *item;
@property (nonatomic, assign) BOOL needLoadAllDetail;

- (IBAction)downloadAction:(id)sender;
- (IBAction)downloadBatAction:(id)sender;
@end
