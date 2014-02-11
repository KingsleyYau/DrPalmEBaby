//
//  SchoolAlbumListViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "SchoolAlbumListTableView.h"
@class SchoolNewsCategory;
@interface SchoolAlbumListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet SchoolAlbumListTableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;

@property (nonatomic, retain) SchoolNewsCategory *category;
@end
