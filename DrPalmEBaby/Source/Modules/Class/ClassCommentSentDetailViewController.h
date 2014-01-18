//
//  ClassCommentSentDetailViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-1.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
@class ClassEventSent;
@class ClassAnwserMan;
@interface ClassCommentSentDetailViewController : BaseViewController <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *toolBar;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *button;

- (IBAction)sendAction:(id)sender;

@property (nonatomic, strong) ClassEventSent *item;
@property (nonatomic, strong) ClassAnwserMan *classAnwserMan;
@end
