//
//  DrCOMClientWSViewController.m
//  DrCOMClientWS
//
//  Created by Keqin Su on 11-4-15.
//  Copyright 2011 City Hotspot Co., Ltd. All rights reserved.
//

#import "DrCOMClientWSViewController.h"
#import "SettingFileController.h"
#import "Utilities.h"
#import "DrCOMDefine.h"
#import "CustomNavigationBar.h"
#import "AppEnviroment.h"
#import "DrClientImageDef.h"
#import "UIColor+RGB.h"
#import "DrClientLanguageDef.h"
#import "WiFiChecker.h"
#import "ResourceManager.h"
#import "UIImage+ResourcePath.h"

#define LableTextColor [UIColor colorWithIntRGB:87 green:105 blue:141 alpha:255]

SettingFileController *fileController = nil;

@interface DrCOMClientWSViewController(private)
- (void)initViews;
- (void)startLoading;
- (void)stopLoading;
- (BOOL)loginStatus:(NSString*)msg msga:(NSString*)msga xip:(NSString*)xip mac:(NSString*)mac time:(NSString*)time flow:(NSString*)flow code:(NSString*)code;
- (void)setViewControl:(BOOL)login;
- (void)setInterface;
- (NSString*)grantUpdateRequest;
- (void)getHttpHandler;
- (void)getHttVersionpHandler;
- (void)urlRequest:(NSString*)url data:(NSString*)data type:(NSString*)type callbackmode:(NSString*)callbackmode;
@end

@interface DrCOMClientWSViewController() {
    UIImageView *_backgroundView;
}
@property (nonatomic, retain) NSString *usedTime;
@property (nonatomic, retain) NSString *usedFlux;
@end

@implementation DrCOMClientWSViewController

@synthesize nameField;
@synthesize passField;
@synthesize nameLabel;
@synthesize passLabel;
@synthesize loginButton;

@synthesize usedTimeLabel;
@synthesize usedFluxLabel;	
@synthesize timeLabel;
@synthesize fluxLabel;	
@synthesize minLabel;
@synthesize mbyteLabel;
@synthesize logoutButton;

@synthesize rememberLabel;
@synthesize signLabel;
@synthesize reconnectLabel;	

@synthesize rememberSwitch;
@synthesize signSwitch;
@synthesize reconnectSwitch;	

@synthesize markView;
@synthesize tableView;

@synthesize usedTime;
@synthesize usedFlux;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _drClientManager = nil;
        self.tableView = nil;
        self.usedTime = DrCOM_Def_Num;
        self.usedFlux = DrCOM_Def_Num;
    }
    return self;
}

- (void)dealloc 
{
	self.nameField = nil;
	self.passField = nil;
	self.nameLabel = nil;
	self.passLabel = nil;
	self.loginButton = nil;
	
	self.usedTimeLabel = nil;
	self.usedFluxLabel = nil;	
	self.timeLabel = nil;
	self.fluxLabel = nil;	
	self.minLabel = nil;
	self.mbyteLabel = nil;
	self.logoutButton = nil;
	
	self.markView = nil;
    self.tableView = nil;
    
    self.usedTime = nil;
    self.usedFlux = nil;
	
	[fileController release];
	fileController = nil;
    [super dealloc];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
    srand(time(NULL));
	[super viewDidLoad];
    
    _backgroundView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _backgroundView.contentMode = UIViewContentModeScaleToFill;
    _backgroundView.image = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DrPalmImageNameLoginBackground]];
    [self.view addSubview:_backgroundView];
    [self.view sendSubviewToBack:_backgroundView];
    
	[self setInterface];
	reconnectSwitch.enabled = NO;
	[self setViewControl:NO];
    
    // 初始化DrClientManager
    _drClientManager = [[DrClientManager alloc] init];
    _drClientManager.delegate = self;
	
	fileController = [[SettingFileController alloc] init];
	
	nameField.text = [Utilities decodeString:[fileController readParamInSettingFile:DrCOMUsername] key:DrCOMClientWS];
	_drClientManager.gwUrl = [Utilities decodeString:[fileController readParamInSettingFile:DrCOMUrl] key:DrCOMClientWS];
	
	if ([[fileController readParamInSettingFile:DrCOMSignIn] isEqualToString:DrCOMYES]) {
		[rememberSwitch setOn:YES animated:YES];
		[signSwitch setOn:YES animated:YES];
	} else {
		[signSwitch setOn:NO animated:YES];
	}

	
	if ([[fileController readParamInSettingFile:DrCOMRememberPass] isEqualToString:DrCOMYES]) {
		[rememberSwitch setOn:YES animated:YES];
		passField.text = [Utilities decodeString:[fileController readParamInSettingFile:DrCOMPass] key:DrCOMClientWS];
	} else {
		[rememberSwitch setOn:NO animated:YES];
	}
    
	if ([[fileController readParamInSettingFile:DrCOMSignIn] isEqualToString:DrCOMYES] && [nameField.text length] > 0 && [passField.text length] >0)  {
		[self onLogin];
	}
    _drClientManager.macList = [Utilities GetHardwareAddressList];
    
    // NavigationBar title
    if (AppEnviromentInstance().globalUIEntitlement.navigationBarEntitlement.isShowImage && nil != DrClientTitleImage){
        UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamedWithData:[ResourceManager resourceFilePath:DrClientTitleImage]]];
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    else{
        self.navigationItem.title = AppEnviromentInstance().globalUIEntitlement.navigationBarEntitlement.titleString;
    }
    
    // set NavigationBar background color
    UINavigationBar* navigationBar = [[self navigationController] navigationBar];
    navigationBar.tintColor = AppEnviromentInstance().globalUIEntitlement.navigationBarEntitlement.tintColor;
    [navigationBar setDefaultBackgroundImage];
    
    
    // 设置背景
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamedWithData:[ResourceManager resourceFilePath:DrClientBackgroundImage]]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    [backgroundView release];
    
    // 界面排版
    [self initViews];
    
    // set TableView
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, signSwitch.frame.origin.y + signSwitch.frame.size.height) style:UITableViewStyleGrouped] autorelease];
//    self.tableView.hidden = YES;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.nameField = nil;
	self.passField = nil;
	self.nameLabel = nil;
	self.passLabel = nil;
	self.loginButton = nil;
	
	self.usedTimeLabel = nil;
	self.usedFluxLabel = nil;	
	self.timeLabel = nil;
	self.fluxLabel = nil;	
	self.minLabel = nil;
	self.mbyteLabel = nil;
	self.logoutButton = nil;
    self.tableView = nil;
	
	self.markView = nil;	
	[super viewDidUnload];
}

- (void)initViews
{
    // 排版
    // 设置内容
    CGFloat hstep = 7;
    CGFloat vstep = 10;
    CGFloat left = vstep;
    CGFloat top = vstep;
    CGFloat width = self.view.frame.size.width - (left * 2);
    
    // username
    nameLabel.frame = CGRectMake(left, top, width, 30);
//    usernameLabel.text = LoginUsername;
    nameLabel.textColor = LableTextColor;
    nameLabel.backgroundColor = [UIColor clearColor];
    top += 30 + hstep;
    
    nameField.frame = CGRectMake(left, top, width, 30);
    top += 30 + hstep;
    
    // password
    passLabel.frame = CGRectMake(left, top, width, 30);
    //    usernameLabel.text = LoginUsername;
    passLabel.textColor = LableTextColor;
    passLabel.backgroundColor = [UIColor clearColor];
    top += 30 + hstep;
    
    passField.frame = CGRectMake(left, top, width, 30);
    top += 30 + hstep * 2;
    
    // remember me
    NSInteger remembermeViewWidth = 70;
    rememberLabel.frame = CGRectMake(left, top, width - remembermeViewWidth - vstep, 30);
    rememberLabel.textColor =LableTextColor;
    rememberLabel.backgroundColor = [UIColor clearColor];
    
    rememberSwitch.frame = CGRectMake(width - remembermeViewWidth - left -5, top, remembermeViewWidth, 30);
    rememberSwitch.center = CGPointMake(rememberSwitch.center.x, rememberLabel.center.y);
    top += 30 + hstep * 2;
    
    // autologin
    NSInteger autologinViewWidth = 70;
    signLabel.frame = CGRectMake(left, top, width - autologinViewWidth - vstep, 30);
    signLabel.textColor = LableTextColor;
    signLabel.backgroundColor = [UIColor clearColor];
    signLabel.hidden = YES;
    
    signSwitch.frame = CGRectMake(width - remembermeViewWidth - left -5, top, autologinViewWidth, 30);
    signSwitch.center = CGPointMake(signSwitch.center.x, signLabel.center.y);
    signSwitch.hidden = YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (IBAction)backgroundTap:(id)sender {
	[nameField resignFirstResponder];
	[passField resignFirstResponder];
}

- (IBAction)onLogin {
    NSString *msg = nil;
	
    if ([nameField.text length] < 1) {
    	msg = DrClientEnterUsername;
    } else if ([passField.text length] < 1){
        msg = DrClientEnterPassword;			
    }
	
    if ([msg length] > 1) {
        [Utilities showDrAlert:msg];
    } else {
        if ([WiFiChecker isWiFiEnable]){
            [self startLoading];
            [_drClientManager login:nameField.text password:passField.text];
        }
        else {
            [Utilities showDrAlert:DrClientNoWiFi];
        }
    }
}

- (IBAction)onLogout {
    [self startLoading];
    [_drClientManager logout];
}

- (void)signChanged:(id)sender {
	UISwitch *witchSwitch = (UISwitch*)sender;
	NSString *val = nil;
	
	if (witchSwitch.isOn) {
		val = DrCOMYES;
		[rememberSwitch setOn:YES animated:YES];
		[fileController writeParamInSettingFile:DrCOMRememberPass value:val];
	} else {
		val = DrCOMYNO;
	}
	[fileController writeParamInSettingFile:DrCOMSignIn value:val];
}

- (void)rememberChanged:(id)sender {
	UISwitch *witchSwitch = (UISwitch*)sender;
	NSString *val = nil;

	if (witchSwitch.isOn) {
		val = DrCOMYES;
	} else {
		val = DrCOMYNO;
		[signSwitch setOn:NO animated:YES];
		[fileController writeParamInSettingFile:DrCOMSignIn value:val];
	}
	[fileController writeParamInSettingFile:DrCOMRememberPass value:val];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (range.location >= MaxTextFieldInputLen) {
		return NO;
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)startLoading{
	[self.view addSubview:markView];
	[(UIActivityIndicatorView *)[markView viewWithTag:202] startAnimating];
	
	markView.center = self.view.center;
	markView.alpha = 0.0f;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	markView.center = CGPointMake(markView.frame.size.width/2, markView.frame.size.height/2);
	markView.alpha = 0.70f;
	[UIView commitAnimations];
}
 
- (void)stopLoading {
	[(UIActivityIndicatorView *)[markView viewWithTag:202] stopAnimating];
	[markView removeFromSuperview];
}

- (void)setViewControl:(BOOL)login {
	if (login) {
		nameField.hidden = YES;
		passField.hidden = YES;
		nameLabel.hidden = YES;
		passLabel.hidden = YES;
		loginButton.hidden = YES;
		
//		usedTimeLabel.hidden = NO;
//		usedFluxLabel.hidden = NO;	
//		timeLabel.hidden = NO;
//		fluxLabel.hidden = NO;	
//		minLabel.hidden = NO;
//		mbyteLabel.hidden = NO;
		logoutButton.hidden = NO;
//        self.tableView.hidden = NO;
        [self.view addSubview:self.tableView];
		
        rememberLabel.hidden = YES;
		rememberSwitch.hidden = YES;
        signLabel.hidden = YES;
		signSwitch.hidden = YES;
	} else {
		nameField.hidden = NO;
		passField.hidden = NO;
		nameLabel.hidden = NO;
		passLabel.hidden = NO;
		loginButton.hidden = NO;
		
		usedTimeLabel.hidden = YES;
		usedFluxLabel.hidden = YES;	
		timeLabel.hidden = YES;
		fluxLabel.hidden = YES;	
		minLabel.hidden = YES;
		mbyteLabel.hidden = YES;
		logoutButton.hidden = YES;
//        self.tableView.hidden = YES;
        [self.tableView removeFromSuperview];
		
        rememberLabel.hidden = NO;
		rememberSwitch.hidden = NO;
        signLabel.hidden = NO;
		signSwitch.hidden = NO;
        
        self.usedFlux = DrCOM_Def_Num;
        self.usedTime = DrCOM_Def_Num;
	}
}

- (void)setInterface {
	nameField.placeholder = DrClientUsername;
	passField.placeholder = DrClientPassword;
	nameLabel.text = DrClientUsernameText;
	passLabel.text = DrClientPasswordText;
	[loginButton setTitle:DrClientLogin forState:UIControlStateNormal];
	usedTimeLabel.text = DrClientUsedTime;
	usedFluxLabel.text = DrClientUsedFlux;	
	minLabel.text  = DrClientMin;
	mbyteLabel.text  = DrClientMByte;
	[logoutButton setTitle:DrClientLogout forState:UIControlStateNormal];
	rememberLabel.text = DrClientRememberPassword;
	signLabel.text = DrClientSignAutomatically;
	reconnectLabel.text = DrClientReconnectAutomatically;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"SSID:";
            cell.detailTextLabel.text = [WiFiChecker currentSSID];
            break;
            
        case 1:
            cell.textLabel.text = DrClientUsernameText;
            cell.detailTextLabel.text = nameField.text;
            break;
            
        case 2:
            cell.textLabel.text = DrClientUsedTime;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.usedTime, DrClientMin];
            break;
            
        case 3:
            cell.textLabel.text = DrClientUsedFlux;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.usedFlux, DrClientMByte];
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - public callback
- (void)loginSuccess
{
    [self stopLoading];
    [self setViewControl:YES];
//	[self statusRequest];
    
    // save login information
    [fileController writeParamInSettingFile:DrCOMUsername value:[Utilities encodeString:nameField.text key:DrCOMClientWS]];
    [fileController writeParamInSettingFile:DrCOMPass value:[Utilities encodeString:passField.text key:DrCOMClientWS]];
    [fileController writeParamInSettingFile:DrCOMUrl value:[Utilities encodeString:_drClientManager.gwUrl key:DrCOMClientWS]];
}

- (void)loginFail:(NSString*)error
{
    if (nil != error){
        [Utilities showDrAlert:error];
    }
    [self stopLoading];
    [self setViewControl:NO];
}

- (void)logoutSuccess
{
    [self setViewControl:NO];
    [self stopLoading];
    if (![[fileController readParamInSettingFile:DrCOMRememberPass] isEqualToString:DrCOMYES]) {
        passField.text = @"";
    }
    //add by Keqin in 2011-04-30
    _drClientManager.gwUrl = @"";
    [fileController writeParamInSettingFile:DrCOMUrl value:_drClientManager.gwUrl];
    //add end
}

- (void)requestFail:(NSString*)error
{
    [self setViewControl:NO];
	if (nil != _drClientManager.errorMessage && ![_drClientManager.errorMessage isEqualToString:error]) {
		[Utilities showDrAlert:_drClientManager.errorMessage];
	}
    else{
        [Utilities showDrAlert:error];
    }
	[self stopLoading];
}

- (void)statusChange:(NSString*)time flow:(NSString*)flow
{
    NSString *viewTime = nil;
    NSString *viewFlux = nil;
    if (([time length] > 0) && ([flow length] > 0)) {
        viewTime = [Utilities trimString:time];
        viewFlux = [Utilities trimString:flow];
        NSInteger iflow = [viewFlux intValue];
        NSInteger iflow0 = 0, iflow1 = 0;
        iflow0 = iflow % 1024;
        iflow1 = iflow - iflow0;
        iflow0 = iflow0 * 1000;
        iflow0 = iflow0 - iflow0 % 1024;
        NSString *flow3;
        if ((iflow0 / 1024) < 10) {
            flow3 = @".00";
        } else if ((iflow0 / 1024) < 100) {
            flow3 = @".0";
        } else {
            flow3 = @".";
        }
        viewFlux = [NSString stringWithFormat:@"%i%@%i", iflow/1024, flow3, iflow0/1024];
    }
    
    if (nil != viewTime){
        self.usedTime = viewTime;
    }
    if (nil != viewFlux){
        self.usedFlux = viewFlux;
    }
    
    [self.tableView reloadData];
}
@end
