//
//  MoreMainViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-29.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "MoreMainViewController.h"
#import "CommonTableViewCell.h"
#import "CommonButtonTableViewCell.h"
#import "EbabyChanelViewController.h"

#import "AccountManageViewController.h"
#import "SystemConfigViewController.h"
#import "CommonWebViewController.h"
#import "AboutViewController.h"
#import "AdviceViewController.h"

#import "LastUpdateDataManager.h"

typedef enum {
    RowTypeAccount,
    RowTypeSystem,
    RowTypeEBabySet,
    RowTypeHelp ,
    RowTypeAdvice ,
    RowTypeShare ,
    RowTypeHotline ,
    RowTypeAbout ,
    RowTypeLogout,
} RowType;

typedef enum {
    ViewStatus_Close = 0,
    ViewStatu_Open = 1
}ViewStatus;

@interface MoreMainViewController () {
     ViewStatus   _viewStatus;
}
@property (nonatomic, assign) CGRect frameClose;
@property (nonatomic, assign) CGRect frameOpen;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) EbabyChanelViewController *ebabyChanelViewController;
@end

@implementation MoreMainViewController

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
	// Do any additional setup after loading the view.
    LoginManager *loginManager = LoginManagerInstance();
    [loginManager addDelegate:self];
    self.shareDelegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupDynamicWebView];
    [self setupDrapView];
    [self setupWebView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self closeView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - (界面逻辑)
- (void)setupNavigationBar {
    [super setupNavigationBar];
}
- (void)setupTableView {
    self.tableView.backgroundView = nil;
}
- (void)setupDynamicWebView {
    self.frameClose = self.dynamicWebView.frame;
    self.frameOpen = CGRectMake(self.dynamicWebView.frame.origin.x, self.dynamicWebView.frame.origin.y, self.dynamicWebView.frame.size.width, self.frameClose.size.height + self.tableView.frame.size.height - 20);
}
- (void)resetDrapView {
    for(UIGestureRecognizer *gestureRecognizer in self.drapImageView.gestureRecognizers) {
        [self.drapImageView removeGestureRecognizer:gestureRecognizer];
    }
}
- (void)setupDrapView {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.minimumNumberOfTouches = 1;
    [self.drapImageView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [singleTap setNumberOfTouchesRequired:1];
    [singleTap setNumberOfTapsRequired:1];
    [self.drapImageView addGestureRecognizer:singleTap];
}
- (void)setupWebView {
    [self.webView setCanBounces:NO];
    if(!self.ebabyChanelViewController) {
        self.ebabyChanelViewController = [[EbabyChanelViewController alloc] init];
        self.ebabyChanelViewController.myNavigationController = self.navigationController;
        self.ebabyChanelViewController.webView = self.webView;
    }
    
    NSString *deviceToken = @"";
    if (nil != AppDelegate().deviceToken){
        deviceToken = [[NSString stringWithFormat:@"%@", AppDelegate().deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
        deviceToken = [deviceToken substringWithRange:NSMakeRange(1, [deviceToken length]-2)];
    }
    
    NSString *urlString = @"";
    //URL
    NSString* pagewidth = [NSString stringWithFormat:@"%f",self.webView.frame.size.width];
    if(LoginManagerInstance().sessionKey.length > 0)
        urlString = [NSString stringWithFormat:EBABYCHANNEL_LOGIN_URL,deviceToken,pagewidth,LoginManagerInstance().sessionKey];
    else
        urlString = [NSString stringWithFormat:EBABYCHANNEL_COMMON_URL,deviceToken,pagewidth];
    
    [self.ebabyChanelViewController loadUrl:[NSURL URLWithString:urlString]];
}
- (void)reloadData:(BOOL)isReloadView {
    NSMutableArray *sectionArray = [NSMutableArray array];
    
    // section 1
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    LoginManager *loginManager = LoginManagerInstance();
    if(LoginStatus_off != loginManager.loginStatus) {
        // 用户设置
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeAccount] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }

    // 系统设置
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeSystem] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    // section 2
    array = [NSMutableArray array];
    
    // 幼儿园集合
    id hideEbabySet = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"IsHideEbabySet"];
    if(!(hideEbabySet && [hideEbabySet boolValue]))
    {
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeEBabySet] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }
    
    // 帮助
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeHelp] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 热线
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeHotline] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 建议
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeAdvice] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 告诉朋友
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeShare] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 关于
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeAbout] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    // section 3
    array = [NSMutableArray array];
    if(LoginStatus_off != loginManager.loginStatus || LoginStatus_local == loginManager.loginStatus) {
        // 注销
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [CommonButtonTableViewCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeLogout] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }
    
    [sectionArray addObject:array];
    
    self.sectionArray = sectionArray;
    
    if(isReloadView) {
        [self.tableView reloadData];
    }
    
    [self reloadTabbarItem];
}
- (void)reloadTabbarItem {
    // 刷新tabbar数字
    KKTabBarItem *item = (KKTabBarItem *)self.tabBarItem;
    item.badgeNum = [[LastUpdateDataManager getUnReadCountWithCategory:Category_EBabyChanel hasUser:NO] intValue];
}
- (IBAction)logoutAction:(id)sender {
    LoginManager *loginManager = LoginManagerInstance();
    if(loginManager.loginStatus == LoginStatus_online) {
        [loginManager logout];
    }
    else {
        [loginManager localLogout];
    }
}
- (BOOL)deviceCanDail {
    UIDevice * device = [UIDevice currentDevice];
    NSString* devicetype = device.model;
    if([devicetype isEqualToString:@"iPod touch"]
       || [devicetype isEqualToString:@"iPad"]
       || [devicetype isEqualToString:@"iPhone Simulator"]){
        return NO;
    }
    else
        return YES;
}
#pragma mark - (列表界面回调)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int number = 0;
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        number = self.sectionArray.count;
    }
    return number;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if([tableView isEqual:self.tableView]) {
        NSArray *array = [self.sectionArray objectAtIndex:section];
        number = array.count;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if([tableView isEqual:self.tableView]) {
        NSArray *array = [self.sectionArray objectAtIndex:indexPath.section];
        NSDictionary *dictionarry = [array objectAtIndex:indexPath.row];
        CGSize viewSize;
        NSValue *value = [dictionarry valueForKey:ROW_SIZE];
        [value getValue:&viewSize];
        height = viewSize.height;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        NSArray *array = [self.sectionArray objectAtIndex:indexPath.section];
        NSDictionary *dictionarry = [array objectAtIndex:indexPath.row];
        
        // TODO:大小
        CGSize viewSize;
        NSValue *value = [dictionarry valueForKey:ROW_SIZE];
        [value getValue:&viewSize];
        
        // TODO:类型
        RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
        switch (type) {
            case RowTypeAccount:{
                // 用户设置
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                cell.titleLabel.text =  NSLocalizedString(@"PersonalConfig", nil);
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MoreImageNameAccount ofType:@"png"]];
                result = cell;
                break;
            }
            case RowTypeSystem:{
                // 系统设置
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                cell.titleLabel.text =  NSLocalizedString(@"SystemConfig", nil);
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MoreImageNameSysSetting ofType:@"png"]];
                result = cell;
                break;
            }
            case RowTypeEBabySet:{
                // 幼儿园集合
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                cell.titleLabel.text = NSLocalizedString(@"EbabySet", nil);
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MoreImageNameEbabySet ofType:@"png"]];
                result = cell;
                break;
            }
            case RowTypeHelp:{
                // 帮助
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                cell.titleLabel.text = NSLocalizedString(@"Help", nil);
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MoreImageNameHelp ofType:@"png"]];
                result = cell;
                break;
            }
            case RowTypeHotline:{
                // 热线
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                NSString* phoneNO = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"HotLine"];
                NSString* btnTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"HotLine", nil), phoneNO];
                cell.titleLabel.text = btnTitle;
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MoreImageNameHotLine ofType:@"png"]];
                result = cell;
                break;
            }
            case RowTypeAdvice:{
                // 建议
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                cell.titleLabel.text = NSLocalizedString(@"Advice", nil);
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MoreImageNameAdvice ofType:@"png"]];
                result = cell;
                break;
            }
            case RowTypeShare:{
                // 告诉朋友
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                cell.titleLabel.text = NSLocalizedString(@"Share", nil);
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MoreImageNameShare ofType:@"png"]];
                result = cell;
                break;
            }
            case RowTypeAbout:{
                // 关于
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                cell.titleLabel.text = NSLocalizedString(@"MoreAbout", nil);
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MoreImageNameAbout ofType:@"png"]];
                result = cell;
                break;
            }
            case RowTypeLogout:{
                // 注销
                CommonButtonTableViewCell *cell = [CommonButtonTableViewCell getUITableViewCell:tableView];
                [cell.button setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MoreImageNameLogout ofType:@"png"]] forState:UIControlStateNormal];
                [cell.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.button setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
                [cell.button addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
                result = cell;
                break;
            }
            default:break;
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        NSArray *array = [self.sectionArray objectAtIndex:indexPath.section];
        NSDictionary *dictionarry = [array objectAtIndex:indexPath.row];
        
        // TODO:大小
        CGSize viewSize;
        NSValue *value = [dictionarry valueForKey:ROW_SIZE];
        [value getValue:&viewSize];
        
        // TODO:类型
        RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
        switch (type) {
            case RowTypeAccount:{
                // 用户设置
                UIStoryboard *storyBoard = AppDelegate().storyBoard;
                
                KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
                AccountManageViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"AccountManageViewController"];
                [nvc pushViewController:vc animated:YES gesture:NO];
            }break;
            case RowTypeSystem:{
                // 系统设置
                UIStoryboard *storyBoard = AppDelegate().storyBoard;
                
                KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
                SystemConfigViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SystemConfigViewController"];
                [nvc pushViewController:vc animated:YES gesture:NO];
            }break;
            case RowTypeEBabySet:{
                // 幼儿园集合
                UIStoryboard *storyBoard = AppDelegate().storyBoard;
                
                KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
                CommonWebViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"CommonWebViewController"];
                [vc loadUrl:[NSURL URLWithString:EBABYSET_URL]];
                [nvc pushViewController:vc animated:YES gesture:NO];
            }break;
            case RowTypeHelp:{
                // 帮助
                UIStoryboard *storyBoard = AppDelegate().storyBoard;
                
                KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
                CommonWebViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"CommonWebViewController"];
                [vc loadUrl:[NSURL URLWithString:HELP_URL]];
                [nvc pushViewController:vc animated:YES gesture:NO];
            }break;
            case RowTypeHotline:{
                // 热线
                if(![self deviceCanDail]) {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Disable_HotLine", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    NSString* phoneNO = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"HotLine"];
                    NSString* btnTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Call", nil), phoneNO];
                    UIActionSheet* actionSheet =[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"DailHotlineTips", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:btnTitle, nil];
                    [actionSheet showFromTabBar:self.tabBarController.tabBar];
                }
            }break;
            case RowTypeAdvice:{
                // 建议
                UIStoryboard *storyBoard = AppDelegate().storyBoard;
                
                KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
                AdviceViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"AdviceViewController"];
                [nvc pushViewController:vc animated:YES gesture:NO];
            }break;
            case RowTypeShare:{
                // 告诉朋友
                if ([self respondsToSelector:@selector(share:)]) {
                    [self performSelector:@selector(share:) withObject:self];
                }
            }break;
            case RowTypeAbout:{
                // 关于
                UIStoryboard *storyBoard = AppDelegate().storyBoard;
                
                KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
                AboutViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"AboutViewController"];
                [nvc pushViewController:vc animated:YES gesture:NO];
            }break;
            case RowTypeLogout:{
                // 注销
            }break;
            default:break;
        }
    }
}
#pragma mark - Gesture Recognizer
- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer {
    if( ([recognizer state] == UIGestureRecognizerStateBegan) ||
       ([recognizer state] == UIGestureRecognizerStateChanged) ) {
        // 开始拖动
        CGPoint movement = [recognizer translationInView:self.dynamicWebView.superview];
        CGRect newRect = self.dynamicWebView.frame;
        newRect.size.height += movement.y;
        if(newRect.size.height < self.frameClose.size.height) {
            self.dynamicWebView.frame = self.frameClose;
        }
        else if(newRect.size.height > self.frameOpen.size.height) {
            self.dynamicWebView.frame = self.frameOpen;
        }
        else {
            self.dynamicWebView.frame = newRect;
        }
        
        [recognizer setTranslation:CGPointZero inView:self.dynamicWebView.superview];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // 释放手指
        CGFloat halfPoint = self.frameOpen.size.height / 2;
        if(self.dynamicWebView.frame.size.height < halfPoint) {
            [self closeView];
        }
        else {
            [self openView];
        }
    }
}
- (void)handleSingleTap {
    if(_viewStatus == ViewStatus_Close)
        [self openView];
    else
        [self closeView];
}
- (void)openView {
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.dynamicWebView.frame = self.frameOpen;
    } completion:^(BOOL finished) {
        [self.dynamicWebView.superview setNeedsLayout];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:DynamicWebViewTapUp ofType:@"png"]];
        self.drapImageView.image = image;
        _viewStatus = ViewStatu_Open;
    }];
}
- (void)closeView {
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.dynamicWebView.frame = self.frameClose;
    } completion:^(BOOL finished) {
        [self.dynamicWebView.superview setNeedsLayout];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:DynamicWebViewTapDown ofType:@"png"]];
        self.drapImageView.image = image;
        [self.webView.subScrollView scrollRectToVisible:CGRectMake(0, 0, _webView.frame.size.width, _webView.frame.size.height) animated:NO];
        _viewStatus = ViewStatus_Close;
    }];
}
#pragma mark － 登陆状态改变回调（LoginManagerDelegate）
- (void)loginStatusChanged:(LoginStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData:YES];
    });
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex){
        NSString* phoneNO = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"HotLine"];
        NSString* str = [NSString stringWithFormat:@"tel://%@",phoneNO];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
#pragma mark - 分享回调 (ShareItemDelegate)
- (NSString *)actionSheetTitle {
	return @"";
}
- (NSString *)emailSubject {
	return @"";
}

- (NSString *)contentBody {
    return  [self emailBody];
}

- (NSString *)emailBody {
    NSString* body = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"MoreShareContent", nil), NSLocalizedString(@"MoreDownloadUrl", nil)];
    return body;
}
- (NSString*)urlBody
{
    return [self emailBody];
}
@end
