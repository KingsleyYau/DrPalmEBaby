//
//  AccountManageViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-11.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface AccountManageViewController : BaseViewController <RequestImageViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

//@property (nonatomic, weak) IBOutlet UISwitch *rememberPasswordSwitch;
//@property (nonatomic, weak) IBOutlet UISwitch *autoLoginSwitch;

@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, assign) BOOL isRememberPassword;
@property (nonatomic, assign) BOOL isAutoLogin;

- (IBAction)rememberPasswordSwitchChanged:(id)sender;
- (IBAction)autoLoginSwitchChanged:(id)sender;
@end
