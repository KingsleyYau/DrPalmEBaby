//
//  ClassListTableView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-5-2.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "ClassListTableView.h"
#import "CommonListTableViewCell.h"
#import "CommonListTextTableViewCell.h"
#import "CenteralTextTableViewCell.h"

#import "ClassDataManager.h"

@interface ClassListTableView () {
    
}
@end

@implementation ClassListTableView
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
        ClassEvent *item = (ClassEvent *)[self.items objectAtIndex:indexPath.row];
        ClassEventCategory *category = [[item.categories allObjects] lastObject];
        if([category.picture boolValue]) {
            // 有图
            CommonListTableViewCell *cell = [CommonListTableViewCell getUITableViewCell:tableView];

            if([item.isReadforServer boolValue]) {
                // 已读
                cell.timeLabel1.textColor = ISREADTEXTCOLOR;
                cell.timeLabel2.textColor = ISREADTEXTCOLOR;
                cell.titleLabel.textColor = ISREADTITLECOLOR;
                cell.subLabel.textColor = ISREADTEXTCOLOR;
                cell.readImageView.hidden = YES;
            }
            else {
                // 未读
                cell.timeLabel1.textColor = TIMETEXTCOLOR;
                cell.timeLabel2.textColor = TIMETEXTCOLOR;
                cell.titleLabel.textColor = TITLETEXTCOLOR;
                cell.subLabel.textColor = DESCTEXTCOLOR;
                cell.readImageView.hidden = NO;
            }
            
            cell.requestImageView.imageUrl = item.mainImage.fullImage.path;
            cell.requestImageView.imageData = item.mainImage.fullImage.data;
            cell.requestImageView.contentType = item.mainImage.fullImage.contenttype;
            cell.requestImageView.delegate = self;
            [cell.requestImageView loadImage];
            
            // 标题
            cell.titleLabel.text = item.title;
            cell.titleLabel.linkAttributes = nil;
            EventStatusType statusType = [ClassDataManager eventStatusTypeWithStatusString:item.status];
            if(EventStatusType_Cancel == statusType) {
                // 已经被删除的
                cell.titleLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kTTTStrikeOutAttributeName];
                [cell.titleLabel addLinkToURL:nil withRange:NSMakeRange(0, [item.title length])];
            }
            
            // 摘要
            cell.subLabel.text = item.summary;
            
            // 收藏
            cell.bookmarkView.hidden = YES;
            if([item.bookmarked boolValue]) {
                cell.bookmarkView.hidden = NO;
            }
            // 附件
            cell.attachmenttView.hidden = YES;
            if([item.hasAtt boolValue]) {
                cell.attachmenttView.hidden = NO;
            }
            // 评论
            cell.commentView.hidden = YES;
            if(![item.pub_id isEqualToString:LoginManagerInstance().accountName])
            {
                if([item.lastAwsTime timeIntervalSince1970] > 0) {
                    cell.commentView.hidden = NO;
                    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[ClassDataManager hasAnwserWithEventId:item.event_id] ? TableViewCommentUnReadIcon:TableViewCommentIcon ofType:@"png"]];
                    cell.commentView.image = image;
                }
            }
            // 紧急
            cell.emergentView.hidden = YES;
            if([item.ifshow boolValue]) {
                cell.emergentView.hidden = NO;
            }
            // 回评
            cell.reviewView.hidden = YES;
            if([item.needreview boolValue]) {
                cell.reviewView.hidden = NO;
            }
            
            // 时间
            cell.timeLabel2.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"Post", nil), [item.postDate toStringToday]];
            
            if([item.lastAwsTime timeIntervalSince1970] > 0) {
                cell.timeLabel1.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"Anwser", nil), [item.lastAwsTime toStringToday]];
            }
            else {
                cell.timeLabel1.text = @"";
            }
            
            result = cell;
        }
        else {
            // 无图
            CommonListTextTableViewCell *cell = [CommonListTextTableViewCell getUITableViewCell:tableView];
            
            if([item.isReadforServer boolValue]) {
                // 已读
                cell.timeLabel1.textColor = ISREADTEXTCOLOR;
                cell.timeLabel2.textColor = ISREADTEXTCOLOR;
                cell.titleLabel.textColor = ISREADTITLECOLOR;
                cell.subLabel.textColor = ISREADTEXTCOLOR;
                cell.readImageView.hidden = YES;
            }
            else {
                // 未读
                cell.timeLabel1.textColor = TIMETEXTCOLOR;
                cell.timeLabel2.textColor = TIMETEXTCOLOR;
                cell.titleLabel.textColor = TITLETEXTCOLOR;
                cell.subLabel.textColor = DESCTEXTCOLOR;
                cell.readImageView.hidden = NO;
            }
            
            // 标题
            cell.titleLabel.text = item.title;
            cell.titleLabel.linkAttributes = nil;
            EventStatusType statusType = [ClassDataManager eventStatusTypeWithStatusString:item.status];
            if(EventStatusType_Cancel == statusType) {
                // 已经被删除的
                cell.titleLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kTTTStrikeOutAttributeName];
                [cell.titleLabel addLinkToURL:nil withRange:NSMakeRange(0, [item.title length])];
            }
        
            // 摘要
            cell.subLabel.text = item.summary;
            
            // 收藏
            cell.bookmarkView.hidden = YES;
            if([item.bookmarked boolValue]) {
                cell.bookmarkView.hidden = NO;
            }
            // 附件
            cell.attachmenttView.hidden = YES;
            if([item.hasAtt boolValue]) {
                cell.attachmenttView.hidden = NO;
            }
            // 评论
            cell.commentView.image = nil;
            cell.commentView.hidden = YES;
            if(![item.pub_id isEqualToString:LoginManagerInstance().accountName])
            {
                cell.commentView.hidden = NO;
                if([item.lastAwsTime timeIntervalSince1970] > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[ClassDataManager hasAnwserWithEventId:item.event_id] ? TableViewCommentUnReadIcon:TableViewCommentIcon ofType:@"png"]];
                    cell.commentView.image = image;
                }
            }
            // 紧急
            cell.emergentView.hidden = YES;
            if([item.ifshow boolValue]) {
                cell.emergentView.hidden = NO;
            }
            // 回评
            cell.reviewView.hidden = YES;
            if([item.needreview boolValue]) {
                cell.reviewView.hidden = NO;
            }
            
            // 时间
            cell.timeLabel2.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"Post", nil), [item.postDate toStringToday]];
            
            if([item.lastAwsTime timeIntervalSince1970] > 0) {
                cell.timeLabel1.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"Anwser", nil), [item.lastAwsTime toStringToday]];
            }
            else {
                cell.timeLabel1.text = @"";
            }
            
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.items.count) {
        if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectClassEvent:)]) {
            [self.tableViewDelegate tableView:self didSelectClassEvent:[self.items objectAtIndex:indexPath.row]];
        }
    }
    else {
        if([self.tableViewDelegate respondsToSelector:@selector(didSelectMore:)]) {
            [self.tableViewDelegate didSelectMore:self];
        }
    }
}

#pragma mark - 异步下载图片控件回调
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    ClassFile *file = [ClassDataManager fileWithUrl:imageView.imageUrl isLocal:NO];
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