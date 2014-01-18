//
//  ClassDetailViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareDetailViewController.h"
#import "ClassDetailInfoTableView.h"

@class ClassEvent;
@interface ClassDetailViewController : ShareDetailViewController <ShareItemDelegate, ClassDetailInfoTableViewDelegate>

@property (nonatomic, weak) IBOutlet DynamicContainView *dynamicContainView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIButton *reviewButton;
@property (nonatomic, weak) IBOutlet BadgeButton *attachmentButton;
@property (nonatomic, strong) ClassDetailInfoTableView *tableView;

@property (nonatomic, strong) ClassEvent *item;
@property (nonatomic, assign) BOOL needLoadAllDetail;
@property (nonatomic, assign) BOOL isLoadFromServer;

- (IBAction)attachmentAction:(id)sender;
- (IBAction)bookmarkAction:(id)sender;
- (IBAction)commentAction:(id)sender;
- (IBAction)reviewAction:(id)sender;
@end
