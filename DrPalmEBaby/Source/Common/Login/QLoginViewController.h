//
//  QLoginViewController.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-5.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserInfo.h"

@interface QLoginViewController : BaseViewController

@property (nonatomic, weak)  IBOutlet UIScrollView *accoutScrollView;
@property (nonatomic, weak)  IBOutlet UITextField *tfUser;
@property (nonatomic, weak)  IBOutlet UITextField *tfPwd;

@property (nonatomic, weak)  IBOutlet UIButton *btnDrop;

@property (nonatomic, weak)  IBOutlet UIView *accountBox;
@property (nonatomic, weak)  IBOutlet UIView *pwdGroup;
@property (nonatomic, weak)  IBOutlet UIButton *btnLogin;
@property (nonatomic, weak)  IBOutlet UIButton *btnGetPwd;

@property (nonatomic, weak)  IBOutlet UILabel *labelRember;
@property (nonatomic, weak)  IBOutlet UIButton *btnRember;
@property (nonatomic, weak)  IBOutlet UILabel *labelAutoLogin;
@property (nonatomic, weak)  IBOutlet UIButton *btnAutoLogin;

-(IBAction)dropAction:(id)sender;
-(IBAction)loginAction:(id)sender;
-(IBAction)getPwdAction:(id)sender;

-(IBAction)rememberAction:(id)sender;
-(IBAction)autoLoginAction:(id)sender;


@property (nonatomic,strong) NSString* username;
@property (nonatomic,strong) NSString* password;


-(void)initViewData:(UserInfo*)userInfo;

@end
