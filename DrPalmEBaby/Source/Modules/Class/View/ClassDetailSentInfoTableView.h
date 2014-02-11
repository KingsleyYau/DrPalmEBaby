//
//  ClassDetailSentInfoTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-5.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassEventSent;
@class ClassDetailSentInfoTableView;
@protocol ClassDetailSentInfoTableViewDelegate <NSObject>
@optional
- (void)reSizetableViewHeight:(ClassDetailSentInfoTableView *)tableView newHeight:(CGFloat)newHeight;
@end


@interface ClassDetailSentInfoTableView : UITableView
@property (nonatomic, weak) id <ClassDetailSentInfoTableViewDelegate> tableViewDelegate;
@property (nonatomic, strong) ClassEventSent *item;
@property (nonatomic, weak) UIViewController *vc;
@end
