//
//  SchoolMainViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-15.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
@class ClassEventCategory;
@interface ClassMainViewController : BaseViewController <IconGridDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet IconGrid *iconGridView;
@property (nonatomic, strong) IBOutlet IconGrid *iconGridView2;

@property (nonatomic, assign) BOOL needGetUnreadCount;

- (IBAction)latestAction:(id)sender;
- (IBAction)searchAction:(id)sender;    // 点击搜索班级通告
- (IBAction)bookmarkAction:(id)sender;  // 点击收藏班级通告
- (IBAction)moduleFace2FaceAction:(id)sender;       // 点击交流
- (IBAction)moduleSystemMessageAction:(id)sender;   // 点击系统信息
- (IBAction)moduleInAndOutAction:(id)sender;        // 点击入院离院

- (IBAction)newEventAction:(id)sender;              // 点击新建通告
- (IBAction)moduleSentEventAction:(id)sender;       // 点击已发通告
- (IBAction)moduleDraftAction:(id)sender;           // 点击草稿

- (void)reloadTabbarItem;
@end
