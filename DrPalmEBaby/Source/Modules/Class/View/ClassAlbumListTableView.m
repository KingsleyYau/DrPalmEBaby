//
//  ClassAlbumListTableView.m
//  YiCoupon
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassAlbumListTableView.h"
#import "CommonAlbumTableViewCell.h"
#import "CenteralTextTableViewCell.h"

#import "ClassDataManager.h"
@implementation ClassAlbumListTableView
@synthesize tableViewDelegate;
@synthesize items;
- (void)initialize {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.separatorColor = [UIColor clearColor];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}
#pragma mark - 界面事件
- (UITableViewCell *)cellForSubView:(UIView *)view {
    // TODO:获取子控件所在单元格
    UITableViewCell *cell = nil;
    CGRect rect = [view convertRect:view.bounds toView:[[UIApplication sharedApplication] keyWindow]];
    for (UITableViewCell *subCell in [self visibleCells]) {
        CGRect subRect = [subCell convertRect:subCell.bounds toView:[[UIApplication sharedApplication] keyWindow]];
        if (CGRectIntersectsRect(rect, subRect)) {
            cell = subCell;
            break;
        }
    }
    return cell;
}
- (UIView *)viewForIndexPath:(NSIndexPath *)indexPath {
    // TODO:获单元格详细界面
    UIView *view = nil;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    view.backgroundColor = [UIColor grayColor];
    return view;
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
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
                self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                number = (self.items.count + 1) / 2;
            }
            else {
                self.separatorStyle = UITableViewCellSeparatorStyleNone;
                number = 0;
            }
        }
        default:break;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.row < (self.items.count + 1) / 2) {
        height = [CommonAlbumTableViewCell cellHeight];
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if (indexPath.row < (self.items.count + 1) / 2) {
        CommonAlbumTableViewCell *cell = [CommonAlbumTableViewCell getUITableViewCell:tableView];
        result = cell;
        
        // TODO:数据填充
        ClassEvent *item1 = (ClassEvent *)[self.items objectAtIndex:(2 * indexPath.row)];
        
        // 标题颜色
        UIColor *titleColor = TITLETEXTCOLOR;
        if([item1.isReadforServer boolValue]) {
            // 已读
            titleColor = ISREADTITLECOLOR;
        }
        cell.titleLabel1.textColor = titleColor;
        cell.titleLabel1.text = item1.title;
        
        cell.titleLabel1.linkAttributes = nil;
        EventStatusType statusType = [ClassDataManager eventStatusTypeWithStatusString:item1.status];
        if(EventStatusType_Cancel == statusType) {
            // 已经被删除的
            cell.titleLabel1.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kTTTStrikeOutAttributeName];
            [cell.titleLabel1 addLinkToURL:nil withRange:NSMakeRange(0, [item1.title length])];
        }
        
        // 收藏
        cell.bookmarkView1.hidden = YES;
        if([item1.bookmarked boolValue]) {
            cell.bookmarkView1.hidden = NO;
        }
//        // 附件
//        cell.attachmenttView1.hidden = YES;
//        if([item1.hasAtt boolValue]) {
//            cell.attachmenttView1.hidden = NO;
//        }
        // 评论
        cell.commentView1.hidden = YES;
        if(![item1.pub_id isEqualToString:LoginManagerInstance().accountName])
        {
            if([item1.lastAwsTime timeIntervalSince1970] > 0) {
                cell.commentView1.hidden = NO;
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[ClassDataManager hasAnwserWithEventId:item1.event_id] ? TableViewCommentUnReadIcon:TableViewCommentIcon ofType:@"png"]];
                cell.commentView1.image = image;
            }
        }
        // 紧急
        cell.emergentView1.hidden = YES;
        if([item1.ifshow boolValue]) {
            cell.emergentView1.hidden = NO;
        }
        // 回评
        cell.reviewView1.hidden = YES;
        if([item1.needreview boolValue]) {
            cell.reviewView1.hidden = NO;
        }

        
        cell.requestImageView1.imageUrl = item1.mainImage.fullImage.path;
        cell.requestImageView1.imageData = item1.mainImage.fullImage.data;
        cell.requestImageView1.contentType = item1.mainImage.fullImage.contenttype;
        cell.requestImageView1.delegate = self;
        cell.requestImageView1.tag = 2 * indexPath.row;
        [cell.requestImageView1 loadImage];
        
        if((2 * indexPath.row) + 1 < self.items.count) {
            cell.containView2.hidden = NO;
            
            ClassEvent *item2 = (ClassEvent *)[self.items objectAtIndex:(2 * indexPath.row) + 1];
            
            // 标题颜色
            UIColor *titleColor = TITLETEXTCOLOR;
            if([item2.isReadforServer boolValue]) {
                // 已读
                titleColor = ISREADTITLECOLOR;
            }
            cell.titleLabel2.textColor = titleColor;
            cell.titleLabel2.text = item2.title;
            
            cell.titleLabel2.linkAttributes = nil;
            EventStatusType statusType = [ClassDataManager eventStatusTypeWithStatusString:item2.status];
            if(EventStatusType_Cancel == statusType) {
                // 已经被删除的
                cell.titleLabel2.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kTTTStrikeOutAttributeName];
                [cell.titleLabel2 addLinkToURL:nil withRange:NSMakeRange(0, [item2.title length])];
            }
            
            // 收藏
            cell.bookmarkView2.hidden = YES;
            if([item2.bookmarked boolValue]) {
                cell.bookmarkView2.hidden = NO;
            }
//            // 附件
//            cell.attachmenttView2.hidden = YES;
//            if([item2.hasAtt boolValue]) {
//                cell.attachmenttView2.hidden = NO;
//            }
            // 评论
            cell.commentView2.hidden = YES;
            if(![item2.pub_id isEqualToString:LoginManagerInstance().accountName])
            {
                if([item2.lastAwsTime timeIntervalSince1970]> 0 ) {
                    if([item2.lastAwsTime timeIntervalSince1970] > 0) {
                        cell.commentView2.hidden = NO;
                        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[ClassDataManager hasAnwserWithEventId:item2.event_id] ? TableViewCommentUnReadIcon:TableViewCommentIcon ofType:@"png"]];
                        cell.commentView2.image = image;
                    }
                }
            }
            // 紧急
            cell.emergentView2.hidden = YES;
            if([item2.ifshow boolValue]) {
                cell.emergentView2.hidden = NO;
            }
            // 回评
            cell.reviewView2.hidden = YES;
            if([item2.needreview boolValue]) {
                cell.reviewView2.hidden = NO;
            }

            
            cell.requestImageView2.imageUrl = item2.mainImage.fullImage.path;
            cell.requestImageView2.imageData = item2.mainImage.fullImage.data;
            cell.requestImageView2.contentType = item2.mainImage.fullImage.contenttype;
            cell.requestImageView2.delegate = self;
            cell.requestImageView2.tag = 2 * indexPath.row + 1;
            [cell.requestImageView2 loadImage];
        }
        else {
            cell.containView2.hidden = YES;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < (self.items.count + 1) / 2) {
    }
    else {
        if([self.tableViewDelegate respondsToSelector:@selector(didSelectMore:)]) {
            [self.tableViewDelegate didSelectMore:self];
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
#pragma mark - (异步下载图片控件回调)
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
- (void)photoViewDidSingleTap:(RequestImageView *)imageView {
    if(imageView.tag < self.items.count) {
        ClassEvent *item = (ClassEvent *)[self.items objectAtIndex:imageView.tag];
        if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectClassEvent:)]) {
            [self.tableViewDelegate tableView:self didSelectClassEvent:item];
        }
    }
}
@end
