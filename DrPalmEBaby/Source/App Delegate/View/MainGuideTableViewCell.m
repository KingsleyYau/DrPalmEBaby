//
//  MainGuideTableViewCell.m
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-9-30.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "MainGuideTableViewCell.h"

@implementation MainGuideTableViewCell
+ (NSString *)cellIdentifier {
    return @"MainGuideTableViewCell";
}
+ (NSInteger)cellHeight {
    return 120;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    MainGuideTableViewCell *cell = (MainGuideTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[MainGuideTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainGuideTableViewCell" owner:tableView options:nil];
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
//    NSLog(@"cell.frame.origin.y:%f", self.frame.origin.y);
//    NSLog(@"cell.superview.frame.origin.y:%f", self.superview.frame.origin.y);
}
@end
