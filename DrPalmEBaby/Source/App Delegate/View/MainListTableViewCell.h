//
//  MainListTableViewCell.h
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-9-25.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
//@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
