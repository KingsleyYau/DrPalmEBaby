//
//  SchoolListTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-5-2.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SchoolNews;
@class SchoolListTableView;

@protocol SchoolListTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(SchoolListTableView *)tableView;
- (void)tableView:(SchoolListTableView *)tableView didSelectSchoolNews:(SchoolNews *)item;
- (void)didSelectMore:(SchoolListTableView *)tableView;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end

@interface SchoolListTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet id <SchoolListTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@end
