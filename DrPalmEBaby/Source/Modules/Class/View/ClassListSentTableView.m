//
//  didSelectClassEventSent.m
//  DrPalm
//
//  Created by KingsleyYau on 13-5-2.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "ClassListSentTableView.h"
#import "CommonListTableViewCell.h"
#import "CommonListTextTableViewCell.h"
#import "CenteralTextTableViewCell.h"
#import "ClassListSentTableViewCell.h"

#import "ClassDataManager.h"

@interface ClassListSentTableView () {
    
}
@end

@implementation ClassListSentTableView
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
        ClassEventSent *item = (ClassEventSent *)[self.items objectAtIndex:indexPath.row];
        
        ClassListSentTableViewCell *cell = [ClassListSentTableViewCell getUITableViewCell:tableView];
        
        if([item.isRead boolValue]) {
            // 已读
            cell.titleLabel.textColor = ISREADTITLECOLOR;
            cell.rightTitleLabel.textColor = ISREADTITLECOLOR;
            cell.subLabel.textColor = ISREADTEXTCOLOR;
            cell.timeLabel1.textColor = ISREADTEXTCOLOR;
            cell.timeLabel2.textColor = ISREADTEXTCOLOR;
            cell.readImageView.hidden = YES;
        }
        else {
            cell.titleLabel.textColor = TITLETEXTCOLOR;
            cell.rightTitleLabel.textColor = TITLETEXTCOLOR;
            cell.subLabel.textColor = DESCTEXTCOLOR;
            cell.timeLabel1.textColor = TIMETEXTCOLOR;
            cell.timeLabel2.textColor = TIMETEXTCOLOR;
            cell.readImageView.hidden = NO;
        }
        
        // 是自己发送还是同班其他老师发送
        if([item.pub_id isEqualToString:UserInfoManagerInstance().userInfo.username]) {
            cell.headImageView.hidden = YES;
        }
        else {
            cell.headImageView.hidden = NO;
        }
        
        // 标题
        cell.titleLabel.text = item.title;
        
        // 发件人
        NSString *sender = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"Sender", nil), item.pubName];
        cell.subLabel.text = sender;
        
        // 已读人数
        NSString *readCount = [NSString stringWithFormat:@"%d/%d",[item.readCount integerValue],[item.readTotal integerValue]];
        cell.rightTitleLabel.text = readCount;
        
        // 附件
        cell.attachmenttView.image = nil;
        if([item.hasAtt boolValue]) {
            cell.attachmenttView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:TableViewAttachmentIcon ofType:@"png"]];
        }
        // 评论
        cell.commentView.image = nil;
        if(![item.pub_id isEqualToString:LoginManagerInstance().accountName])
        {
            if([item.lastAwsTime timeIntervalSince1970]>0) {
                cell.commentView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[ClassDataManager hasAnwserWithEventSentId:item.event_id] ? TableViewCommentUnReadIcon:TableViewCommentIcon ofType:@"png"]];
            }
            
        }
        // 紧急
        cell.emergentView.image = nil;
        if([item.ifshow boolValue]) {
            cell.emergentView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:TableViewEemergentIcon ofType:@"png"]];
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
        if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectClassEventSent:)]) {
            [self.tableViewDelegate tableView:self didSelectClassEventSent:[self.items objectAtIndex:indexPath.row]];
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