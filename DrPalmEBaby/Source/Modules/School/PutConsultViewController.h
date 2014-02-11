//
//  PutConsultViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-12.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface PutConsultViewController : BaseViewController <KKTextFieldDelegate, KKTextViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet KKTextField *textFieldName;
@property (nonatomic, weak) IBOutlet UIImageView *textFieldNameWrongImageView;

@property (nonatomic, weak) IBOutlet KKTextField *textFieldPhone;
@property (nonatomic, weak) IBOutlet UIImageView *textFieldPhoneWrongImageView;

@property (nonatomic, weak) IBOutlet KKTextField *textFieldEmail;
@property (nonatomic, weak) IBOutlet UIImageView *textFieldEmailWrongImageView;

@property (nonatomic, weak) IBOutlet KKTextField *textFieldTitle;
@property (nonatomic, weak) IBOutlet UIImageView *textFieldTitleWrongImageView;

@property (nonatomic, weak) IBOutlet KKTextView *textView;
@property (nonatomic, weak) IBOutlet UIImageView *textViewWrongImageView;

@property (nonatomic, strong) LoadingView *loadingView;

- (IBAction)sendAction:(id)sender;

@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) NSString *contactPhone;
@property (nonatomic, strong) NSString *contactEmail;
@property (nonatomic, strong) NSString *contactTitle;
@property (nonatomic, strong) NSString *contactContent;

@property (nonatomic, assign) BOOL contactNameEmpty;
@property (nonatomic, assign) BOOL contactPhoneEmpty;
@property (nonatomic, assign) BOOL contactContentEmpty;

@end
