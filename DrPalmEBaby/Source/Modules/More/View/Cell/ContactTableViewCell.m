//
//  ContactTableViewCell.m
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell
+ (NSString *)cellIdentifier {
    return @"ContactTableViewCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ContactTableViewCell *cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ContactTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.tipsLabel.text = nil;
        cell.wrongImageView.hidden = YES;
        cell.warningImageView.hidden = YES;
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
    
    NSInteger xCurIndex = self.warningImageView.frame.origin.x;
    
    if(!self.warningImageView.hidden) {
        xCurIndex -= self.wrongImageView.frame.size.width;
        xCurIndex -= BLANKING_X;
    }
    
    self.wrongImageView.frame = CGRectMake(xCurIndex, self.wrongImageView.frame.origin.y, self.wrongImageView.frame.size.width, self.wrongImageView.frame.size.height);
    
}
@end
