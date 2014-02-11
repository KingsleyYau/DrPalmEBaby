//
//  ClassDetailInfoTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-5.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassEvent;
@class ClassDetailInfoTableView;
@protocol ClassDetailInfoTableViewDelegate <NSObject>
@optional
- (void)reSizetableViewHeight:(ClassDetailInfoTableView *)tableView newHeight:(CGFloat)newHeight;
@end


@interface ClassDetailInfoTableView : UITableView
@property (nonatomic, weak) id <ClassDetailInfoTableViewDelegate> tableViewDelegate;
@property (nonatomic, strong) ClassEvent *item;
@property (nonatomic, weak) UIViewController *vc;
@end
