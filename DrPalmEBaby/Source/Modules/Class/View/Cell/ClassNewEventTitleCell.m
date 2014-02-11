//
//  ClassNewEventTitleCell.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-28.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassNewEventTitleCell.h"

@implementation ClassNewEventTitleCell
+ (NSString *)cellIdentifier {
    return @"ClassNewEventTitleCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ClassNewEventTitleCell *cell = (ClassNewEventTitleCell *)[tableView dequeueReusableCellWithIdentifier:[ClassNewEventTitleCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassNewEventTitleCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIImage *image = [UIImage imageWithContentsOfFileLanguage:[[NSBundle mainBundle] pathForResource:ClassNewEventTitleImage ofType:@"png"] ofType:@"png"];
    [cell.titleImageView setImage:image];
    
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
