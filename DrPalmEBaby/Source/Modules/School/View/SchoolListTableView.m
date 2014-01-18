//
//  SchoolListTableView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-5-2.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "SchoolListTableView.h"
#import "CommonListTableViewCell.h"
#import "CommonListTextTableViewCell.h"
#import "CenteralTextTableViewCell.h"

#import "SchoolDataManager.h"
@interface SchoolListTableView () <RequestImageViewDelegate> {
    
}
@end

@implementation SchoolListTableView
@synthesize tableViewDelegate;
@synthesize items;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
        
    }
    return self;
}
- (void)initialize {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.separatorColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.hasMore = NO;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        height = [self.tableViewDelegate tableView:self heightForHeaderInSection:section];
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        view = [self.tableViewDelegate tableView:self viewForHeaderInSection:section];
    }
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 1;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch(section) {
        case 0: {
            if(self.items.count > 0) {
                number = self.items.count;
                if(self.hasMore) {
                    // 需要显示更多按钮
                    number += 1;
                }
            }
            else {
                number = 0;
            }
        }
        default:break;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    if (indexPath.row < self.items.count) {
        height = [CommonListTableViewCell cellHeight];
    }
    else {
        height = [CenteralTextTableViewCell cellHeight];
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if (indexPath.row < self.items.count) {
        SchoolNews *item = (SchoolNews *)[self.items objectAtIndex:indexPath.row];
        SchoolNewsCategory *category = [[item.categories allObjects] lastObject];
        if([category.picture boolValue]) {
            // 有图
            CommonListTableViewCell *cell = [CommonListTableViewCell getUITableViewCell:tableView];

            cell.requestImageView.imageUrl = item.mainImage.fullImage.path;
            cell.requestImageView.imageData = item.mainImage.fullImage.data;
            cell.requestImageView.contentType = item.mainImage.fullImage.contenttype;
            cell.requestImageView.delegate = self;
            [cell.requestImageView loadImage];
            
            if([item.read boolValue]) {
                // 已读
                cell.titleLabel.textColor = ISREADTITLECOLOR;
                cell.timeLabel.textColor = ISREADTEXTCOLOR;
                cell.subLabel.textColor = ISREADTEXTCOLOR;
                cell.readImageView.hidden = YES;
            }
            else {
                // 未读
                cell.titleLabel.textColor = TITLETEXTCOLOR;
                cell.timeLabel.textColor = TIMETEXTCOLOR;
                cell.subLabel.textColor = DESCTEXTCOLOR;
                cell.readImageView.hidden = NO;
            }
            
            // 标题
            cell.titleLabel.text = item.title;
            
            //摘要
            cell.subLabel.text = item.abstract;
            
            // 收藏
            cell.bookmarkView.hidden = YES;
            if([item.bookmarked boolValue]) {
                cell.bookmarkView.hidden = NO;
            }
            
            // 时间

            cell.timeLabel.text = [item.postdate toStringToday];
            result = cell;
        }
        else {
            // 无图
            CommonListTextTableViewCell *cell = [CommonListTextTableViewCell getUITableViewCell:tableView];
            
            if([item.read boolValue]) {
                // 已读
                cell.titleLabel.textColor = ISREADTITLECOLOR;
                cell.timeLabel.textColor = ISREADTEXTCOLOR;
                cell.subLabel.textColor = ISREADTEXTCOLOR;
                cell.readImageView.hidden = YES;
            }
            else {
                // 未读
                cell.titleLabel.textColor = TITLETEXTCOLOR;
                cell.timeLabel.textColor = TIMETEXTCOLOR;
                cell.subLabel.textColor = DESCTEXTCOLOR;
                cell.readImageView.hidden = NO;
            }
            // 标题
            cell.titleLabel.text = item.title;
            
            //摘要
            cell.subLabel.text = item.abstract;
            
            // 收藏
            cell.bookmarkView.hidden = YES;
            if([item.bookmarked boolValue]) {
                cell.bookmarkView.hidden = NO;
            }
            
            // 时间
            cell.timeLabel.text = [item.postdate toStringToday];
            result = cell;
        }
    }
    else {
        // 更多
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        cell.titleLabel.text = @"更多";
        result = cell;
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    //self.itemSelected = [self.items objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.items.count) {
        if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectSchoolNews:)]) {
            [self.tableViewDelegate tableView:self didSelectSchoolNews:[self.items objectAtIndex:indexPath.row]];
        }
    }
    else {
        if([self.tableViewDelegate respondsToSelector:@selector(didSelectMore:)]) {
            [self.tableViewDelegate didSelectMore:self];
        }
    }
}

#pragma mark - 缩略图界面回调 (RequestImageViewDelegate)
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    SchoolFile *file = [SchoolDataManager fileWithUrl:imageView.imageUrl isLocal:NO];
    if(file) {
        file.data = imageView.imageData;
        file.contenttype = imageView.contentType;
        [CoreDataManager saveData];
        if ([self.tableViewDelegate respondsToSelector:@selector(needReloadData:)]) {
            [self.tableViewDelegate needReloadData:self];
        }
    }
}
#pragma mark - 滚动界面回调 (UIScrollViewDelegate)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.tableViewDelegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.tableViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
@end