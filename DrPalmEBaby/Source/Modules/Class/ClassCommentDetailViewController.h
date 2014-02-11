//
//  ClassCommentDetailViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-1.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
@class ClassEvent;
@class ClassAnwserMan;
@interface ClassCommentDetailViewController : BaseViewController <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *toolBar;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *button;

- (IBAction)sendAction:(id)sender;

@property (nonatomic, strong) ClassEvent *item;
@property (nonatomic, strong) ClassAnwserMan *classAnwserMan;
@end
