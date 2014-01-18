//
//  AccountImageTableViewCell.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountImageTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet RequestImageView *requestImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
