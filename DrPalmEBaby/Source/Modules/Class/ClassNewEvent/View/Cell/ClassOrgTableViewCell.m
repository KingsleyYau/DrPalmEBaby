//
//  ClassOrgTableViewCell.M
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassOrgTableViewCell.h"

@implementation ClassOrgTableViewCell
+ (NSString *)cellIdentifier {
    return @"ClassOrgTableViewCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ClassOrgTableViewCell *cell = (ClassOrgTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ClassOrgTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassOrgTableViewCell" owner:tableView options:nil];
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
}
@end
