//
//  CommonSwitchTableViewCell.m
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommonSwitchTableViewCell.h"

@implementation CommonSwitchTableViewCell
+ (NSString *)cellIdentifier {
    return @"CommonSwitchTableViewCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CommonSwitchTableViewCell *cell = (CommonSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CommonSwitchTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommonSwitchTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.tipsLabel.text = nil;
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
}
@end
