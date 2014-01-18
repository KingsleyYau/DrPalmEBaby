//
//  ClassNewEventReceiverCell.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-28.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassNewEventReceiverCell.h"

@implementation ClassNewEventReceiverCell
+ (NSString *)cellIdentifier {
    return @"ClassNewEventReceiverCell";
}
+ (NSInteger)cellHeight {
    return 52;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ClassNewEventReceiverCell *cell = (ClassNewEventReceiverCell *)[tableView dequeueReusableCellWithIdentifier:[ClassNewEventReceiverCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassNewEventReceiverCell" owner:tableView options:nil];
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
