//
//  LatestTableViewCell.h
//  DrPalm
//
//  Created by KingsleyYau on 13-4-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BadgeButton;
@interface LatestTableViewCell : UITableViewCell {
}
@property (nonatomic, weak) IBOutlet BadgeImageView *logoView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
