//
//  GrowupDetailViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-12.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
@class GrowDiary;
@interface GrowupDetailViewController : BaseViewController <KKTextFieldDelegate, KKTextViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet KKTextField *textFieldTitle;
@property (nonatomic, weak) IBOutlet UIImageView *textFieldTitleWrongImageView;

@property (nonatomic, weak) IBOutlet KKTextView *textView;
@property (nonatomic, weak) IBOutlet UIImageView *textViewWrongImageView;

@property (nonatomic, strong) LoadingView *loadingView;

- (IBAction)sendAction:(id)sender;

@property (nonatomic, strong) NSString *contactTitle;
@property (nonatomic, strong) NSString *contactContent;

@property (nonatomic, assign) BOOL contactTitleEmpty;
@property (nonatomic, assign) BOOL contactContentEmpty;
@property (nonatomic, strong) GrowDiary *item;

@end
