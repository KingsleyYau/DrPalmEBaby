//
//  ClassSentVideoDetailViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassDetailSentInfoTableView.h"

@class ClassEventSent;
@interface ClassSentVideoDetailViewController : BaseViewController < ClassDetailSentInfoTableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet RequestImageView *requestImageView;
@property (nonatomic, weak) IBOutlet DynamicContainView *dynamicContainView;

@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;
@property (nonatomic, weak) IBOutlet UIButton *playButton;

@property (nonatomic, weak) IBOutlet UILabel *reportLabel;
@property (nonatomic, weak) IBOutlet UIButton *reportButton;

@property (nonatomic, strong) ClassDetailSentInfoTableView *tableView;

@property (nonatomic, retain) ClassEventSent *item;
@property (nonatomic, assign) BOOL needLoadAllDetail;

- (IBAction)commentAction:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)readerStatusAction:(id)sender;
- (IBAction)editAction:(id)sender;
@end
