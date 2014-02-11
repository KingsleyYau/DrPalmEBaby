//
//  SchoolSearchListViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "SchoolListTableView.h"
@interface SchoolSearchListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet SchoolListTableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property (nonatomic, weak) IBOutlet KKSearchBar *theSearchBar;
@end
