//
//  ClassSentAlbumnDetailViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassDetailSentInfoTableView.h"

@class ClassEventSent;
@interface ClassSentAlbumnDetailViewController : BaseViewController <ClassDetailSentInfoTableViewDelegate, PZPagingScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet PZPagingScrollView *pzPagingScrollView;
@property (nonatomic, weak) IBOutlet DynamicContainView *dynamicContainView;
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIButton *batDownloadButton;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;

@property (nonatomic, weak) IBOutlet UIView *reportView;
@property (nonatomic, weak) IBOutlet UILabel *reportLabel;
@property (nonatomic, weak) IBOutlet UIButton *reportButton;

@property (nonatomic, strong) ClassDetailSentInfoTableView *tableView;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, retain) ClassEventSent *item;
@property (nonatomic, assign) BOOL needLoadAllDetail;

- (IBAction)downloadAction:(id)sender;
- (IBAction)downloadBatAction:(id)sender;
- (IBAction)commentAction:(id)sender;
- (IBAction)readerStatusAction:(id)sender;
- (IBAction)editAction:(id)sender;
@end
