//
//  CommentCell2.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-1.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommentCell2.h"

@implementation CommentCell2
+ (NSString *)cellIdentifier {
    return @"CommentCell";
}
+ (NSInteger)cellHeight:(UITableView*)tableView content:(NSString *)content {
    NSInteger cellHeight = 72;
    NSInteger autoResizeHeight = 0;
    
    // 内容
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(0.93 * tableView.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    autoResizeHeight = 42 + contentSize.height;
    
    cellHeight = MAX(cellHeight, autoResizeHeight);
    return cellHeight;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CommentCell2 *cell = (CommentCell2 *)[tableView dequeueReusableCellWithIdentifier:[CommentCell2 cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentCell2" owner:tableView options:nil];
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
    
    NSInteger xCurIndex = 0;
    xCurIndex = self.imageViewHead.frame.origin.x;
//    xCurIndex = self.frame.size.width - 10;
    
    self.labelContent.frame = CGRectMake(xCurIndex - 10 - 20 - self.labelContent.frame.size.width, self.labelContent.frame.origin.y, self.labelContent.frame.size.width, self.labelContent.frame.size.height);
    
    self.imageViewContent.frame = CGRectMake(self.labelContent.frame.origin.x - 10, self.imageViewContent.frame.origin.y, self.labelContent.frame.size.width + 30, self.labelContent.frame.size.height + 10);
//    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.labelContent.frame.size.height + 20);
}
@end
