//
//  SchoolMainListViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "SchoolListTableView.h"
@class SchoolNewsCategory;
@interface SchoolMainListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet SchoolListTableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;

@property (nonatomic, retain) SchoolNewsCategory *category;
@end
