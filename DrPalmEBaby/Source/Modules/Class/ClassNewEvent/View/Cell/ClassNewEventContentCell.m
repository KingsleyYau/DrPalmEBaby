//
//  ClassNewEventContentCell.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-28.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassNewEventContentCell.h"

@implementation ClassNewEventContentCell
+ (NSString *)cellIdentifier {
    return @"ClassNewEventContentCell";
}
+ (NSInteger)cellHeight {
    return 152;
}
+ (NSInteger)cellHeight:(UITableView *)tableView content:(NSString *)content {
    NSInteger height;
    height = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(tableView.frame.size.width - 2 * 10, MAXFLOAT)
                 lineBreakMode:NSLineBreakByClipping].height;
    height += 14;
    
    return MAX(height, [ClassNewEventContentCell cellHeight]);
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ClassNewEventContentCell *cell = (ClassNewEventContentCell *)[tableView dequeueReusableCellWithIdentifier:[ClassNewEventContentCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassNewEventContentCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.wrongImageView.hidden = YES;
    }
    return cell;
}
+ (id)getUITableViewCell:(UITableView*)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    ClassNewEventContentCell *cell = (ClassNewEventContentCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassNewEventContentCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.wrongImageView.hidden = YES;
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
