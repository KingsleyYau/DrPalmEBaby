//
//  LatestTableViewCell.m
//  DrPalm
//
//  Created by KingsleyYau on 13-4-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "LatestTableViewCell.h"
@implementation LatestTableViewCell
+ (NSString *)cellIdentifier {
    return @"LatestTableViewCell";
}
+ (NSInteger)cellHeight {
    return 76;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    LatestTableViewCell *cell = (LatestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[LatestTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LatestTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.titleLabel.text = @"";
        cell.descLabel.text = @"";
        cell.dateLabel.text = @"";
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
