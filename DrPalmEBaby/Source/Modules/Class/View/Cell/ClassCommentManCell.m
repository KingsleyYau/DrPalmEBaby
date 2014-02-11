//
//  ClassCommentManCell.m
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassCommentManCell.h"

@implementation ClassCommentManCell
+ (NSString *)cellIdentifier {
    return @"ClassCommentManCell";
}
+ (NSInteger)cellHeight {
    return 52;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ClassCommentManCell *cell = (ClassCommentManCell *)[tableView dequeueReusableCellWithIdentifier:[ClassCommentManCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassCommentManCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.titleLabel.text = nil;
        cell.timeLabel.text = nil;
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
    
    NSInteger xCurIndex = self.titleLabel.frame.origin.x;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, MIN(self.titleLabel.frame.size.width, 120), 28);
   
    xCurIndex += self.titleLabel.frame.size.width;
    xCurIndex += BLANKING_X;
    
    self.noticeImageView.frame = CGRectMake(xCurIndex, self.noticeImageView.frame.origin.y, self.noticeImageView.frame.size.width, self.noticeImageView.frame.size.height);
}
@end
