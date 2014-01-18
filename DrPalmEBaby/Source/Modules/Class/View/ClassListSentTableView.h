//
//  ClassListSentTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-5-2.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassListSentTableView;
@class ClassEventSent;

@protocol ClassListSentTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(ClassListSentTableView *)tableView;
- (void)tableView:(ClassListSentTableView *)tableView didSelectClassEventSent:(ClassEventSent *)item;
- (void)didSelectMore:(ClassListSentTableView *)tableView;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end

@interface ClassListSentTableView : UITableView <UITableViewDataSource, UITableViewDelegate, RequestImageViewDelegate>
@property (nonatomic, weak) IBOutlet id <ClassListSentTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@end
