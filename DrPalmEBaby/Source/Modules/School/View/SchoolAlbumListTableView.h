//
//  SchoolAlbumListTableView.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SchoolAlbumListTableView;
@class SchoolNews;
@protocol SchoolAlbumListTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(SchoolAlbumListTableView *)tableView;
- (void)tableView:(SchoolAlbumListTableView *)tableView didSelectSchoolNews:(SchoolNews *)item;
- (void)didSelectMore:(SchoolAlbumListTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end

@interface SchoolAlbumListTableView : UITableView <UITableViewDataSource, UITableViewDelegate, RequestImageViewDelegate>
@property (nonatomic, weak) IBOutlet id <SchoolAlbumListTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@end
