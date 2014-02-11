//
//  ClassListSentTableViewCell.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassListSentTableViewCell.h"

@implementation ClassListSentTableViewCell
+ (NSString *)cellIdentifier {
    return @"ClassListSentTableViewCell";
}
+ (NSInteger)cellHeight {
    return 76;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ClassListSentTableViewCell *cell = (ClassListSentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ClassListSentTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassListSentTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.titleLabel.text = @"";
        cell.subLabel.text = @"";
        cell.timeLabel.text = @"";
        cell.timeLabel1.text = @"";
        cell.timeLabel2.text = @"";
        
        cell.bookmarkView.hidden = YES;
        cell.attachmenttView.hidden = YES;
        cell.emergentView.hidden = YES;
        cell.commentView.hidden = YES;
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.timeLabel.text = nil;
        self.titleLabel.text = nil;
        self.subLabel.text = nil;
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
    
    NSInteger xCurIndex = self.headImageView.frame.origin.x;
    if(!self.headImageView.hidden) {
        self.headImageView.frame = CGRectMake(xCurIndex, self.headImageView.frame.origin.y, self.headImageView.frame.size.width, self.headImageView.frame.size.height);
        xCurIndex += self.headImageView.frame.size.width;
        xCurIndex += BLANKING_X;
    }
    
    self.titleLabel.frame = CGRectMake(xCurIndex, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    xCurIndex += self.titleLabel.frame.size.width;
    xCurIndex += BLANKING_X;

    xCurIndex = self.titleLabel.frame.origin.x;
    
    if(!self.bookmarkView.hidden) {
        self.bookmarkView.frame = CGRectMake(xCurIndex, self.bookmarkView.frame.origin.y, self.bookmarkView.frame.size.width, self.bookmarkView.frame.size.height);
        xCurIndex += self.bookmarkView.frame.size.width;
        xCurIndex += BLANKING_X;
    }
    if(!self.attachmenttView.hidden) {
        self.attachmenttView.frame = CGRectMake(xCurIndex, self.attachmenttView.frame.origin.y, self.attachmenttView.frame.size.width, self.attachmenttView.frame.size.height);
        xCurIndex += self.attachmenttView.frame.size.width;
        xCurIndex += BLANKING_X;
    }
    if(!self.emergentView.hidden) {
        self.emergentView.frame = CGRectMake(xCurIndex, self.emergentView.frame.origin.y,  self.emergentView.frame.size.width, self.emergentView.frame.size.height);
        xCurIndex += self.emergentView.frame.size.width;
        xCurIndex += BLANKING_X;
    }
    if(!self.commentView.hidden) {
        self.commentView.frame = CGRectMake(xCurIndex, self.commentView.frame.origin.y,  self.commentView.frame.size.width, self.commentView.frame.size.height);
        xCurIndex += self.commentView.frame.size.width;
        xCurIndex += BLANKING_X;
    }
}
@end
