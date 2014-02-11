//
//  CommentCell.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-1.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (nonatomic, weak) IBOutlet RequestImageView *requestImageView;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewContent;
@property (nonatomic, weak) IBOutlet UILabel *labelContent;
@property (nonatomic, weak) IBOutlet UILabel *labelTime;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight:(UITableView*)tableView content:(NSString *)content;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
