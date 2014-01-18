//
//  ClassListSentTableViewCell.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassListSentTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *readImageView;
@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel1;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel2;


@property (nonatomic, weak) IBOutlet UIImageView *bookmarkView;
@property (nonatomic, weak) IBOutlet UIImageView *attachmenttView;
@property (nonatomic, weak) IBOutlet UIImageView *emergentView;
@property (nonatomic, weak) IBOutlet UIImageView *commentView;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
