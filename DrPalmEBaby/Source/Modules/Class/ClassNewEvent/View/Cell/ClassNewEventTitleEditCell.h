//
//  ClassNewEventTitleEditCell.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-28.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassNewEventTitleEditCell : UITableViewCell
@property (nonatomic, weak) IBOutlet KKTextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *button;
+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
