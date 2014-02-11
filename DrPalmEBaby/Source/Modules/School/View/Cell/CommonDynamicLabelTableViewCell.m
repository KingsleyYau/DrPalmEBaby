//
//  CommonDynamicLabelTableViewCell.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommonDynamicLabelTableViewCell.h"

@implementation CommonDynamicLabelTableViewCell
+ (NSString *)cellIdentifier {
    return @"CommonDynamicLabelTableViewCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (NSInteger)cellHeight:(UITableView*)tableView content:(NSString *)content {
    NSInteger cellHeight = 44;
    NSInteger autoResizeHeight = 0;
    
    // 内容
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(0.93 * tableView.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    autoResizeHeight = 23 + contentSize.height;
    
    cellHeight = MAX(cellHeight, autoResizeHeight);
    return cellHeight;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CommonDynamicLabelTableViewCell *cell = (CommonDynamicLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CommonDynamicLabelTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommonDynamicLabelTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.contentLabel.text = nil;
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
