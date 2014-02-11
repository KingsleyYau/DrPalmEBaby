//
//  ClassSentDetailViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassDetailSentInfoTableView.h"

@class ClassEventSent;
@interface ClassSentDetailViewController : BaseViewController <ClassDetailSentInfoTableViewDelegate, UIActionSheetDelegate>
@property (nonatomic, weak) IBOutlet UILabel *reportLabel;
@property (nonatomic, weak) IBOutlet UIButton *reportButton;
@property (nonatomic, weak) IBOutlet DynamicContainView *dynamicContainView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIButton *attachmentButton;
@property (nonatomic, strong) ClassDetailSentInfoTableView *tableView;

@property (nonatomic, strong) ClassEventSent *item;
@property (nonatomic, assign) BOOL needLoadAllDetail;

- (IBAction)attachmentAction:(id)sender;
- (IBAction)commentAction:(id)sender;
- (IBAction)readerStatusAction:(id)sender;
- (IBAction)editAction:(id)sender;
@end
