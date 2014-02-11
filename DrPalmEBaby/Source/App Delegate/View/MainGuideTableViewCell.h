//
//  MainGuideTableViewCell.h
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-9-30.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainGuideTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIView *view1;
@property (nonatomic, weak) IBOutlet UIView *view2;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
