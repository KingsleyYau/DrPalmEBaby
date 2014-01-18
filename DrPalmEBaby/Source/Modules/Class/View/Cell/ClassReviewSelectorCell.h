//
//  ClassReviewSelectorCell.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-28.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassReviewSelectorCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet KKRankSelector *kkRankSelector;
+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
