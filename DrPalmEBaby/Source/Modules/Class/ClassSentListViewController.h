//
//  ClassSentListViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassListSentTableView.h"
@interface ClassSentListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet ClassListSentTableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
@end
