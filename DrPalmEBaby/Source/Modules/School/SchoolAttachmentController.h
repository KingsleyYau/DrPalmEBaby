//
//  SchoolAlbumnDetailViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
@class SchoolNews;
@interface SchoolAttachmentController : BaseViewController <PZPagingScrollViewDelegate>

@property (nonatomic, weak) IBOutlet PZPagingScrollView *pzPagingScrollView;
@property (nonatomic, weak) IBOutlet DynamicContainView *dynamicContainView;
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIButton *batDownloadButton;

@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, retain) SchoolNews *item;
@property (nonatomic, assign) BOOL needLoadAllDetail;

- (IBAction)downloadAction:(id)sender;
- (IBAction)downloadBatAction:(id)sender;
@end
