//
//  ClassNewEventContentCell.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-28.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassNewEventContentCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *wrongImageView;
@property (nonatomic, weak) IBOutlet KKTextView *textView;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (NSInteger)cellHeight:(UITableView *)tableView content:(NSString *)content;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
