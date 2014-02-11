//
//  HomeTableViewCell.m
//  YiCoupon
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommonAlbumTableViewCell.h"

@implementation CommonAlbumTableViewCell
+ (NSString *)cellIdentifier {
    return @"CommonAlbumTableViewCell";
}
+ (NSInteger)cellHeight {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamedWithFamily:NSStringFromClass([self class]) owner:nil options:nil];
    UITableViewCell *cell = [nib objectAtIndex:0];
    return cell.frame.size.height;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CommonAlbumTableViewCell *cell = (CommonAlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CommonAlbumTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamedWithFamily:NSStringFromClass([self class]) owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.titleLabel1.text = @"";
        cell.titleLabel2.text = @"";
        
        cell.bookmarkView1.hidden = YES;
        cell.attachmenttView1.hidden = YES;
        cell.emergentView1.hidden = YES;
        cell.commentView1.hidden = YES;
        cell.reviewView1.hidden = YES;
        
        cell.bookmarkView2.hidden = YES;
        cell.attachmenttView2.hidden = YES;
        cell.emergentView2.hidden = YES;
        cell.commentView2.hidden = YES;
        cell.reviewView2.hidden = YES;
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger xCurIndex = self.reviewView1.frame.origin.x;
    
    if(!self.reviewView1.hidden) {
        self.reviewView1.frame = CGRectMake(xCurIndex, self.reviewView1.frame.origin.y, self.reviewView1.frame.size.width, self.reviewView1.frame.size.height);
        xCurIndex -= self.reviewView1.frame.size.width;
    }
    
    if(!self.commentView1.hidden) {
        self.commentView1.frame = CGRectMake(xCurIndex, self.commentView1.frame.origin.y,  self.commentView1.frame.size.width, self.commentView1.frame.size.height);
        xCurIndex -= self.commentView1.frame.size.width;
    }
    
    if(!self.emergentView1.hidden) {
        self.emergentView1.frame = CGRectMake(xCurIndex, self.emergentView1.frame.origin.y,  self.emergentView1.frame.size.width, self.emergentView1.frame.size.height);
        xCurIndex -= self.emergentView1.frame.size.width;
    }
    
    if(!self.attachmenttView1.hidden) {
        self.attachmenttView1.frame = CGRectMake(xCurIndex, self.attachmenttView1.frame.origin.y, self.attachmenttView1.frame.size.width, self.attachmenttView1.frame.size.height);
        xCurIndex -= self.attachmenttView1.frame.size.width;
    }
    
    if(!self.bookmarkView1.hidden) {
        self.bookmarkView1.frame = CGRectMake(xCurIndex, self.bookmarkView1.frame.origin.y, self.bookmarkView1.frame.size.width, self.bookmarkView1.frame.size.height);
        xCurIndex -= self.bookmarkView1.frame.size.width;
    }
    
    xCurIndex = self.reviewView2.frame.origin.x;
    
    if(!self.reviewView2.hidden) {
        self.reviewView2.frame = CGRectMake(xCurIndex, self.reviewView2.frame.origin.y, self.reviewView2.frame.size.width, self.reviewView2.frame.size.height);
        xCurIndex -= self.reviewView2.frame.size.width;
    }
    
    if(!self.commentView2.hidden) {
        self.commentView2.frame = CGRectMake(xCurIndex, self.commentView2.frame.origin.y,  self.commentView2.frame.size.width, self.commentView2.frame.size.height);
        xCurIndex -= self.commentView2.frame.size.width;
    }
    
    if(!self.emergentView2.hidden) {
        self.emergentView2.frame = CGRectMake(xCurIndex, self.emergentView2.frame.origin.y,  self.emergentView2.frame.size.width, self.emergentView2.frame.size.height);
        xCurIndex -= self.emergentView2.frame.size.width;
    }
    
    if(!self.attachmenttView2.hidden) {
        self.attachmenttView2.frame = CGRectMake(xCurIndex, self.attachmenttView2.frame.origin.y, self.attachmenttView2.frame.size.width, self.attachmenttView2.frame.size.height);
        xCurIndex -= self.attachmenttView2.frame.size.width;
    }
    
    if(!self.bookmarkView2.hidden) {
        self.bookmarkView2.frame = CGRectMake(xCurIndex, self.bookmarkView2.frame.origin.y, self.bookmarkView2.frame.size.width, self.bookmarkView2.frame.size.height);
        xCurIndex -= self.bookmarkView2.frame.size.width;
    }
}
@end
