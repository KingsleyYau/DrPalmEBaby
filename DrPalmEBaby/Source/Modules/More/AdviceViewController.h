//
//  AdviceViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-12.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface AdviceViewController : BaseViewController <KKTextFieldDelegate, KKTextViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *textFieldWrongImageView;
@property (nonatomic, weak) IBOutlet KKTextField *textField;
@property (nonatomic, weak) IBOutlet KKTextView *textView;
@property (nonatomic, weak) IBOutlet UIImageView *textViewWrongImageView;
@property (nonatomic, strong) LoadingView *loadingView;

- (IBAction)sendAction:(id)sender;


@property (nonatomic, strong) NSString *contactPhone;
@property (nonatomic, strong) NSString *contactContent;

@property (nonatomic, assign) BOOL contactPhoneEmpty;
@property (nonatomic, assign) BOOL contactContentEmpty;
@end
