//
//  CommentCell.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-1.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell
+ (NSString *)cellIdentifier {
    return @"CommentCell";
}
+ (NSInteger)cellHeight:(UITableView*)tableView content:(NSString *)content {
    NSInteger cellHeight = 72;
    NSInteger autoResizeHeight = 0;
    
    // 内容
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(0.71 * tableView.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    autoResizeHeight = 42 + contentSize.height;
    
    cellHeight = MAX(cellHeight, autoResizeHeight);
    return cellHeight;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:[CommentCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.labelTime.text = @"";
        cell.labelContent.text = nil;
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
    
    [self.labelContent sizeToFit];
    
    self.imageViewContent.frame = CGRectMake(self.labelContent.frame.origin.x - 20, self.imageViewContent.frame.origin.y, self.labelContent.frame.size.width + 30, self.labelContent.frame.size.height + 10);
}
@end
