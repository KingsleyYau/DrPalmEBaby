//
//  ClassReviewTxtEditCell.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-28.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassReviewTxtEditCell.h"

@implementation ClassReviewTxtEditCell
+ (NSString *)cellIdentifier {
    return @"ClassReviewTxtEditCell";
}
+ (NSInteger)cellHeight {
    return 88;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ClassReviewTxtEditCell *cell = (ClassReviewTxtEditCell *)[tableView dequeueReusableCellWithIdentifier:[ClassReviewTxtEditCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassReviewTxtEditCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.titleLabel.text = @"";
    cell.textField.text = @"";
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
