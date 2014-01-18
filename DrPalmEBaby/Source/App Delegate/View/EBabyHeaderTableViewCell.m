//
//  EBabyHeaderTableViewCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-22.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "EBabyHeaderTableViewCell.h"

@implementation EBabyHeaderTableViewCell
+ (NSString *)cellIdentifier {
    return @"EBabyHeaderTableViewCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    EBabyHeaderTableViewCell *cell = (EBabyHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[EBabyHeaderTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EBabyHeaderTableViewCell" owner:tableView options:nil];
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

@end
