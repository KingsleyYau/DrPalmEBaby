//
//  CommunicateTableViewCell.m
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommunicateTableViewCell.h"

@implementation CommunicateTableViewCell
+ (NSString *)cellIdentifier {
    return @"CommunicateTableViewCell";
}
+ (NSInteger)cellHeight {
    return 56;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CommunicateTableViewCell *cell = (CommunicateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CommunicateTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommunicateTableViewCell" owner:tableView options:nil];
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

@end
