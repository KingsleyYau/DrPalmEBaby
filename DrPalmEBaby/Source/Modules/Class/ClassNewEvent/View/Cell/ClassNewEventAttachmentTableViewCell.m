//
//  ClassNewEventAttachmentTableViewCell.m
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassNewEventAttachmentTableViewCell.h"

@implementation ClassNewEventAttachmentTableViewCell
+ (NSString *)cellIdentifier {
    return @"ClassNewEventAttachmentTableViewCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ClassNewEventAttachmentTableViewCell *cell = (ClassNewEventAttachmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ClassNewEventAttachmentTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassNewEventAttachmentTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
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
    NSInteger xCurIndex = self.leftImageView.frame.origin.x;
    if(self.leftImageView.image) {
        [self.leftImageView sizeToFit];
        xCurIndex += self.leftImageView.frame.size.width;
        xCurIndex += 10;
    }
    
    self.titleLabel.frame = CGRectMake(xCurIndex, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
}
@end
