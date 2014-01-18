//
//  ClassAlbumListViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassAlbumListTableView.h"
@class ClassEventCategory;
@interface ClassAlbumListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet ClassAlbumListTableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;

@property (nonatomic, retain) ClassEventCategory *category;
@end
