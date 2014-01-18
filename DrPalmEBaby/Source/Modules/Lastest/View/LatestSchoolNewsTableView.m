//
//  LatestSchoolNewsTableView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-4-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "LatestSchoolNewsTableView.h"
#import "LatestTableViewCell.h"

#import "SchoolDataManager.h"

@implementation LatestSchoolNewsTableView
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 1;
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger number = 0;
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat number = 0.0;
    number = [LatestTableViewCell cellHeight];
    return number;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    number = self.items.count;
	return number;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    
    if(indexPath.row < self.items.count) {
        SchoolNewsCategory *item = [self.items objectAtIndex:indexPath.row];
        LatestTableViewCell *cell = [LatestTableViewCell getUITableViewCell:tableView];

        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:item.logoImage.path ofType:@"png"]];
        [cell.logoView setImage:image];
        // 分类最后更新时间比本地最后一条item更新时间迟
        [cell.logoView setBadgeValue:nil];
        if(![item.lastUpdateChannel isEqualToDate:item.lastUpdateChannelList]) {
            if([item.lastUpdateChannel isEqualToDate:[item.lastUpdateChannel laterDate:item.lastUpdateChannelList]] &&  [item.lastUpdateChannel timeIntervalSince1970] > 0) {
                [cell.logoView setBadgeValue:NSLocalizedString(@"New", nil)];
            }
        }
        cell.titleLabel.text = NSLocalizedString(item.title, nil);

        cell.descLabel.text = item.titleofLastNews;
        cell.dateLabel.text = [item.lastUpdateChannel toStringToday];
        cell.dateLabel.hidden = [item.lastUpdateChannel timeIntervalSince1970] == 0 ;
        result = cell;
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectLatestNews:)]) {
        [self.tableViewDelegate tableView:self didSelectLatestNews:[self.items objectAtIndex:indexPath.row]];
    }
}
#pragma mark - 滚动界面回调 (UIScrollViewDelegate)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.tableViewDelegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.tableViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
@end
