//
//  SchoolDetailViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareDetailViewController.h"
@class SchoolNews;
@interface SchoolDetailViewController : ShareDetailViewController <ShareItemDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;
@property (nonatomic, weak) IBOutlet BadgeButton *attachmentButton;

@property (nonatomic, retain) SchoolNews *item;
@property (nonatomic, assign) BOOL needLoadAllDetail;

- (IBAction)attachmentAction:(id)sender;
- (IBAction)bookmarkAction:(id)sender;
@end
