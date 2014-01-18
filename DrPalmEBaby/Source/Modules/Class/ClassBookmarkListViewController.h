//
//  ClassBookmarkListViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassListTableView.h"
@class ClassEventCategory;
@interface ClassBookmarkListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet ClassListTableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;

@end
