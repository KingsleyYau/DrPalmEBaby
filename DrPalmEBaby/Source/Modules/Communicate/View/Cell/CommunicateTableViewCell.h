//
//  CommunicateTableViewCell.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunicateTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet RequestImageView *headRequestImageView;
@property (nonatomic, weak) IBOutlet BadgeImageView *imageViewHead;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *accessImageView;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
