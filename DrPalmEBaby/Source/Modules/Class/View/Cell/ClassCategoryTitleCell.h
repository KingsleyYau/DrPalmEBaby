//
//  ClassCategoryTitleCell.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-28.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCategoryTitleCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *titleImageView;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) IBOutlet UIButton *button2;
+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
