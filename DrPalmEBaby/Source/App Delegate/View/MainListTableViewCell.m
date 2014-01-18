//
//  MainListTableViewCell.m
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-9-25.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "MainListTableViewCell.h"
#import "ResourceManager.h"

@implementation MainListTableViewCell
+ (NSString *)cellIdentifier {
    return @"MainListTableViewCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    MainListTableViewCell *cell = (MainListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[MainListTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainListTableViewCell" owner:tableView options:nil];
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
- (void)layoutSubviews {
    [super layoutSubviews];
    UIImage *image = [self.bookmarkButton imageForState:UIControlStateNormal];
    if(nil == image) {
        [self.bookmarkButton setHidden:YES];
        self.titleLabel.frame = CGRectMake(self.bookmarkButton.frame.origin.x, 0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    }
    else {
        [self.bookmarkButton setHidden:NO];
        self.titleLabel.frame = CGRectMake(self.bookmarkButton.frame.origin.x + self.bookmarkButton.frame.size.width + 10, 0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    }
//    NSLog(@"cell.frame.origin.y:%f", self.frame.origin.y);
//    NSLog(@"cell.superview.frame.origin.y:%f", self.superview.frame.origin.y);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
