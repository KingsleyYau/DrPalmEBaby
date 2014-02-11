//
//  ClassVideoDetailViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassDetailInfoTableView.h"

@class ClassEvent;
@interface ClassVideoDetailViewController : BaseViewController < ClassDetailInfoTableViewDelegate>

@property (nonatomic, weak) IBOutlet RequestImageView *requestImageView;
@property (nonatomic, weak) IBOutlet DynamicContainView *dynamicContainView;

@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;
@property (nonatomic, weak) IBOutlet UIButton *playButton;

@property (nonatomic, strong) ClassDetailInfoTableView *tableView;

@property (nonatomic, retain) ClassEvent *item;
@property (nonatomic, assign) BOOL needLoadAllDetail;
@property (nonatomic, assign) BOOL isLoadFromServer;

- (IBAction)bookmarkAction:(id)sender;
- (IBAction)commentAction:(id)sender;
- (IBAction)playAction:(id)sender;
@end
