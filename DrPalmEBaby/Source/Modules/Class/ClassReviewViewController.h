//
//  ClassReviewViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-12.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassReviewViewController.h"
@class ClassEvent;
@interface ClassReviewViewController : BaseViewController <KKTextFieldDelegate, KKTextViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) ClassEvent *item;
- (IBAction)sendAction:(id)sender;
@end
