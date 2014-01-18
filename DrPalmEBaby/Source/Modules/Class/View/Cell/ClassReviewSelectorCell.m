//
//  ClassReviewSelectorCell.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-28.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassReviewSelectorCell.h"

@implementation ClassReviewSelectorCell
+ (NSString *)cellIdentifier {
    return @"ClassReviewSelectorCell";
}
+ (NSInteger)cellHeight {
    return 88;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ClassReviewSelectorCell *cell = (ClassReviewSelectorCell *)[tableView dequeueReusableCellWithIdentifier:[ClassReviewSelectorCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassReviewSelectorCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = @"";
    cell.kkRankSelector.numberOfRank = 0;
    UIImage *image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    cell.kkRankSelector.kkImage = image;
    cell.kkRankSelector.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    cell.kkRankSelector.canEditable = YES;
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
