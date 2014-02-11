//
//  QLoginViewController.m
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-9-5.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "QLoginViewController.h"
#import "CommonWebViewController.h"
#import "LoginManager.h"

#define ANIMATION_DURATION 0.3f

#define TFUSERNAME_TAG     300
#define TFPASSWORD_TAG      301

#define ACCOUNT_VIEW_HEIGHT  80
#define HEADIMAGE_WIDTH   50
#define DELBUTTON_WIDTH   20
#define LABEL_HEIGHT      20

#define MAX_USER_COUNT    5

@interface QLoginViewController ()<UITextFieldDelegate,LoginManagerDelegate>
{
    BOOL _isExpandAccountBox;
    
    BOOL _isRememberMe;
    BOOL _isAutoLogin;
    
    LoadingView* _loadingView;
    UserInfo* _loginUserInfo;
}

@property (nonatomic, retain) NSArray* userArray;

-(BOOL)checkInputAvailable;
-(void)setTopStatusText:(NSString *)text;

-(void)reloadAccountBox;
@end

@implementation QLoginViewController
@synthesize username,password;
@synthesize userArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userArray = [UserInfoManager getLoginUserList];
    _loadingView = [[LoadingView alloc] init];
    [LoginManagerInstance() addDelegate:self];
    
    self.tfUser.tag = TFUSERNAME_TAG;
    self.tfUser.placeholder = NSLocalizedString(@"AccountInputTips", nil);
    self.tfPwd.tag = TFPASSWORD_TAG;
    self.tfPwd.placeholder = NSLocalizedString(@"GetPassword", nil);
    self.tfPwd.secureTextEntry = YES;
    
    [self.btnLogin setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnGetPwd setTitle:NSLocalizedString(@"GetPassword", nil) forState:UIControlStateNormal];
    [self.btnGetPwd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _isExpandAccountBox = NO;
    _isRememberMe = YES;
    _isAutoLogin = NO;
    [self.accountBox setHidden:YES];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:LoginUserGroupDropDownImage ofType:@"png"]];
    [self.btnDrop setImage:image forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initViewData:UserInfoManagerInstance().userInfo];
    [self reloadAccountBox];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTopStatusText:(NSString *)text {
    [super setTopStatusText:text];
}



-(void)reloadAccountBox {
    [self.accoutScrollView removeAllSubviews];
    self.userArray = [UserInfoManager getLoginUserList];
    NSInteger count = self.userArray.count;
    if(count > MAX_USER_COUNT)
        self.userArray = [self.userArray subarrayWithRange:NSMakeRange(0, MAX_USER_COUNT)];
        
    NSInteger index = 0;
    NSInteger AccountViewWidth = self.accoutScrollView.frame.size.width/3;
    
    NSInteger xCur = 0;
    if(count == 1)
        xCur = AccountViewWidth;
    else if(count == 2)
        xCur = AccountViewWidth/2;
    
    for(UserInfo* userInfo in self.userArray)
    {        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(xCur, 0, AccountViewWidth, ACCOUNT_VIEW_HEIGHT)];
        //view.contentMode = uicont
        [self.accoutScrollView addSubview:view];
        //头像
        CGRect rtHead = CGRectMake((AccountViewWidth-HEADIMAGE_WIDTH)/2, 5, HEADIMAGE_WIDTH, HEADIMAGE_WIDTH);
        UIImage *image = [UIImage imageWithData:userInfo.headimage.data];
        if(!image) {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:LoginUserDefaultImage ofType:@"png"]];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.frame = rtHead;
        button.tag = index;
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        //删除按钮
        UIButton * btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* imgDel = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:LoginDelUserImage ofType:@"png"]];
        [btnDel setBackgroundImage:imgDel forState:UIControlStateNormal];
        btnDel.frame = CGRectMake(HEADIMAGE_WIDTH - DELBUTTON_WIDTH, 0, DELBUTTON_WIDTH, DELBUTTON_WIDTH);
        btnDel.tag = index*10;
        [btnDel addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:btnDel];
        
        //用户名
        CGRect rtLabel = CGRectMake(0, 10+HEADIMAGE_WIDTH, AccountViewWidth, LABEL_HEIGHT);
        UILabel* label = [[UILabel alloc] initWithFrame:rtLabel];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = userInfo.username;
        [view addSubview:label];
        index++;
        xCur += AccountViewWidth;
    }
    
    CGFloat width=AccountViewWidth*(index)<self.accoutScrollView.frame.size.width?self.accoutScrollView.frame.size.width:AccountViewWidth*(index);
    CGSize contentSize=CGSizeMake(width, self.accoutScrollView.frame.size.height);
    [self.accoutScrollView setContentSize:contentSize];
}

-(void)initViewData:(UserInfo*)userInfo
{
    //_loginUserInfo = UserInfoManagerInstance().userInfo;
    if(userInfo != nil)
    {
        _isRememberMe = [userInfo.isrememberme boolValue];
        _isAutoLogin = [userInfo.isautologin boolValue];
        self.tfUser.text = userInfo.username;
        if(_isRememberMe)
            self.tfPwd.text = userInfo.password;
        else
            self.tfPwd.text = @"";
    }
    else{
        self.tfUser.text  = @"";
        self.tfPwd.text = @"";
        _isRememberMe = YES;
        _isAutoLogin = NO;
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_isRememberMe?CheckBoxCheckedImage:CheckBoxUnCheckedImage ofType:@"png"]];
    [self.btnRember setImage:image forState:UIControlStateNormal];
    self.labelRember.text = NSLocalizedString(@"SavePassword", nil);
    
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_isAutoLogin?CheckBoxCheckedImage:CheckBoxUnCheckedImage ofType:@"png"]];
    [self.btnAutoLogin setImage:image forState:UIControlStateNormal];
    self.labelAutoLogin.text = NSLocalizedString(@"AutoLogin", nil);
}

- (void)stopEditing
{
    // 如果正在编辑，则把键盘收起
    UIView *textField = nil;
    textField = [self.view viewWithTag:TFUSERNAME_TAG];
    [textField resignFirstResponder];
    textField = [self.view viewWithTag:TFPASSWORD_TAG];
    [textField resignFirstResponder];
}


#pragma mark - other
-(BOOL)checkInputAvailable
{
    BOOL sussess = YES;
    // 用户名是否为空
    if(self.tfUser.text.length > 0 != YES) {
        sussess = NO;
    }
    else {
        self.username = self.tfUser.text;
    }
    // 密码是否为空
    if (self.tfPwd.text.length > 0 != YES){
        sussess = NO;
    }
    else {
        self.password = self.tfPwd.text;
    }
    if(!sussess)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"LoginIdAndPwdNotNull", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
        [alert show];
    }
    return sussess;
}


-(IBAction)loginAction:(id)sender
{
    [self stopEditing];
    // 登陆
    LoginManager *loginManager = LoginManagerInstance();
    if ([self checkInputAvailable])
    {
        [_loadingView showLoading:self.view animated:YES];
        [loginManager login:self.username password:self.password];
    }
}
-(IBAction)getPwdAction:(id)sender
{
    NSString* url = DrPalmGateWayManagerInstance().getPwdUrl;
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    CommonWebViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"CommonWebViewController"];
    [vc loadUrl:[NSURL URLWithString:url]];
    [nvc pushViewController:vc animated:YES gesture:NO];
    
//    CommonWebViewController* vc = [[[CommonWebViewController alloc] init] autorelease];
//    [vc loadUrl:[NSURL URLWithString:url]];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)rememberAction:(id)sender
{
    _isRememberMe = !_isRememberMe;
    if(!_isRememberMe)
        _isAutoLogin = NO;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_isRememberMe?CheckBoxCheckedImage:CheckBoxUnCheckedImage ofType:@"png"]];
    [self.btnRember setImage:image forState:UIControlStateNormal];
    
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_isAutoLogin?CheckBoxCheckedImage:CheckBoxUnCheckedImage ofType:@"png"]];
    [self.btnAutoLogin setImage:image forState:UIControlStateNormal];
    
}
-(IBAction)autoLoginAction:(id)sender
{
    _isAutoLogin = !_isAutoLogin;
    if(_isAutoLogin)
        _isRememberMe = YES;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_isRememberMe?CheckBoxCheckedImage:CheckBoxUnCheckedImage ofType:@"png"]];
    [self.btnRember setImage:image forState:UIControlStateNormal];
    
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_isAutoLogin?CheckBoxCheckedImage:CheckBoxUnCheckedImage ofType:@"png"]];
    [self.btnAutoLogin setImage:image forState:UIControlStateNormal];
}


-(IBAction)dropAction:(id)sender
{
   [self stopEditing];
    _isExpandAccountBox = !_isExpandAccountBox;
    if(_isExpandAccountBox)
    {
        [self showAccountBox];
    
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:LoginUserGroupDropUpImage ofType:@"png"]];
        [self.btnDrop setImage:image forState:UIControlStateNormal];
    }
    else
    {
        [self hideAccountBox];
        
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:LoginUserGroupDropDownImage ofType:@"png"]];
        [self.btnDrop setImage:image forState:UIControlStateNormal];
    }
}

-(void)showAccountBox
{
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.pwdGroup.center.x, self.pwdGroup.center.y)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(self.pwdGroup.center.x, self.pwdGroup.center.y+self.accountBox.frame.size.height)]];
    [move setDuration:ANIMATION_DURATION];
    [self.pwdGroup.layer addAnimation:move forKey:nil];
    
    
    [self.accountBox setHidden:NO];
    
    
    //模糊处理
    [self.tfUser setEnabled:NO];
    [self.tfPwd setEnabled:NO];
    [self.tfUser setAlpha:0.5f];
    [self.tfPwd setAlpha:0.5f];
    [self.btnLogin setEnabled:NO];
    [self.btnGetPwd setEnabled:NO];
    [self.btnLogin setAlpha:0.5f];
    [self.btnGetPwd setAlpha:0.5f];
    //[self._btn]
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    CABasicAnimation *center=[CABasicAnimation animationWithKeyPath:@"position"];
    [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.accountBox.center.x, self.accountBox.center.y-self.accountBox.bounds.size.height/2)]];
    [center setToValue:[NSValue valueWithCGPoint:CGPointMake(self.accountBox.center.x, self.accountBox.center.y)]];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,center, nil]];
    [group setDuration:ANIMATION_DURATION];
    [self.accountBox.layer addAnimation:group forKey:nil];
    
    
    
    [self.pwdGroup setCenter:CGPointMake(self.pwdGroup.center.x, self.pwdGroup.center.y+self.accountBox.frame.size.height)];
}
-(void)hideAccountBox
{
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.pwdGroup.center.x, self.pwdGroup.center.y)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(self.pwdGroup.center.x, self.pwdGroup.center.y-self.accountBox.frame.size.height)]];
    [move setDuration:ANIMATION_DURATION];
    [self.pwdGroup.layer addAnimation:move forKey:nil];
    
    [self.pwdGroup setCenter:CGPointMake(self.pwdGroup.center.x, self.pwdGroup.center.y-self.accountBox.frame.size.height)];
    
    
    [self.tfUser setEnabled:YES];
    [self.tfPwd setEnabled:YES];
    [self.tfUser setAlpha:1.0f];
    [self.tfPwd setAlpha:1.0f];
    [self.btnAutoLogin setEnabled:YES];
    [self.btnRember setEnabled:YES];
    [self.btnAutoLogin setAlpha:1.0f];
    [self.btnRember setAlpha:1.0f];
    [self.btnLogin setEnabled:YES];
    [self.btnGetPwd setEnabled:YES];
    [self.btnLogin setAlpha:1.0f];
    [self.btnGetPwd setAlpha:1.0f];
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
    
    CABasicAnimation *center=[CABasicAnimation animationWithKeyPath:@"position"];
    [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.accountBox.center.x, self.accountBox.center.y)]];
    [center setToValue:[NSValue valueWithCGPoint:CGPointMake(self.accountBox.center.x, self.accountBox.center.y-self.accountBox.bounds.size.height/2)]];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,center, nil]];
    [group setDuration:ANIMATION_DURATION];
    [self.accountBox.layer addAnimation:group forKey:nil];
    
    
    [self.accountBox performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:NO] afterDelay:ANIMATION_DURATION];
}

#pragma mark - UITextViewDelegate
#define KeyboardHeight 216.0
// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // became first responder
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES 
    switch ( textField.tag ) {
        case TFUSERNAME_TAG: {
            self.username = textField.text;
        }break;
        case TFPASSWORD_TAG: {
            self.password = textField.text;
        }break;
        default:break;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 不是最后一项
    if(TFPASSWORD_TAG != textField.tag){
        [self.tfPwd becomeFirstResponder];
    }
    else
    {
        // 取消键盘
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

- (void)buttonTapped:(id)sender {
    UIButton* btn = (UIButton*)sender;
    NSInteger index = btn.tag;
    UserInfo* userinfo = (UserInfo*)[self.userArray objectAtIndex:index];
    [self initViewData:userinfo];
    [self dropAction:nil];
}

- (void)delAction:(id)sender {
    UIButton* btn = (UIButton*)sender;
    NSInteger index = btn.tag/10 ;
    UserInfo* userinfo = (UserInfo*)[self.userArray objectAtIndex:index];
    if(userinfo)
    {
        //删除帐号为View初始化帐号
        if([userinfo.username isEqualToString:self.tfUser.text])
        {
            [self initViewData:nil];
        }
        [UserInfoManager delUser:userinfo];
        [self reloadAccountBox];
    }
}

#pragma mark - LoginManagerDelegate
- (void)loginStatusChanged:(LoginStatus)status
{
    if (LoginStatus_online == status){
        //add
        UserInfoManagerInstance().userInfo.password = self.password;
        UserInfoManagerInstance().userInfo.isrememberme = [NSNumber numberWithBool:_isRememberMe];
        UserInfoManagerInstance().userInfo.isautologin = [NSNumber numberWithBool:_isAutoLogin];
        UserInfoManagerInstance().userInfo.lastlogintime = [NSDate date];
        [UserInfoManagerInstance() saveUserInfo];
    }
    else if(LoginStatus_local == status){
        [self setTopStatusText:NSLocalizedString(@"LoginLocalTips", nil)];
        
    }
    //[LoginManagerInstance() cancel];
    [_loadingView hideLoading:YES];
}

- (void)handleError:(LoginManagerHandleStatus)status error:(NSString*)error
{
    [self setTopStatusText:error];
    [_loadingView hideLoading:YES];
}
@end
