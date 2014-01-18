//
//  EBabyHeaderTableViewCell.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-22.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBabyHeaderTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIWebView *webView;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;

@end
