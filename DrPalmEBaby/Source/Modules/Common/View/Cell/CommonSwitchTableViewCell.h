//
//  CommonSwitchTableViewCell.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonSwitchTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property (nonatomic, weak) IBOutlet UISwitch *rightSwitch;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
