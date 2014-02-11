//
//  ClassAlbumListTableView.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassAlbumListTableView;
@class ClassEvent;
@protocol ClassAlbumListTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(ClassAlbumListTableView *)tableView;
- (void)tableView:(ClassAlbumListTableView *)tableView didSelectClassEvent:(ClassEvent *)item;
- (void)didSelectMore:(ClassAlbumListTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end

@interface ClassAlbumListTableView : UITableView <UITableViewDataSource, UITableViewDelegate, RequestImageViewDelegate>
@property (nonatomic, weak) IBOutlet id <ClassAlbumListTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@end
