//
//  ClassCommentManListViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@class ClassEventSent;
@interface ClassCommentManListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property (nonatomic, strong) ClassEventSent *item;
@end
