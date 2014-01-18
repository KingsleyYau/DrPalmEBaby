//
//  CommonDynamicLabelTableViewCell.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonDynamicLabelTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (NSInteger)cellHeight:(UITableView*)tableView content:(NSString *)content;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
