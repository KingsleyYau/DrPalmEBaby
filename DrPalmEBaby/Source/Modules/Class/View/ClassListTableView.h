//
//  SchoolListTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-5-2.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassListTableView;
@class ClassEvent;

@protocol ClassListTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(ClassListTableView *)tableView;
- (void)tableView:(ClassListTableView *)tableView didSelectClassEvent:(ClassEvent *)item;
- (void)didSelectMore:(ClassListTableView *)tableView;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end

@interface ClassListTableView : UITableView <UITableViewDataSource, UITableViewDelegate, RequestImageViewDelegate>
@property (nonatomic, weak) IBOutlet id <ClassListTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@end
