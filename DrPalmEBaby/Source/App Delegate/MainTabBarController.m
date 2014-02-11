//
//  MainTabBarController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-8.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "MainTabBarController.h"
#import "LatestClassEventViewController.h"
#import "ResourceDownloadManager.h"

#import "SchoolDataManager.h"
#import "ClassDataManager.h"

#pragma mark - 同步EBaby2的登陆帐号到EBaby3
#define TEXT_ACCOUNT                @"Account"
#define TEXT_PASSWORD               @"Password"
#define TEXT_USERNAME               @"Username"
#define SWITCH_ISSAVEACCOUNTINFO    @"IsSaveAccountInfo"
#define TEXT_USERTYPE               @"UserType"
#define SWITCH_AUTOLOGIN            @"AutoLogin"
#define ENCRYPT_KEY                 @"drcom"

@interface MainTabBarController () <LoginManagerDelegate, ResourceDownloadManagerDelegate> {
    BOOL _hideRightButton;
    BOOL _autoLogin;
    NSString* _lastSchoolKey;
}
@property (nonatomic, strong) ResourceDownloadManager *resDownLoadManager;
@end

@implementation MainTabBarController
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
    self.delegate = self;
    
    
    // 初始化本地分类
    [SchoolDataManager staticCategory];
    [ClassDataManager staticCategory];
    
    // 拿网关
    DrPalmGateWayManager *gatewayManager = DrPalmGateWayManagerInstance();
    [gatewayManager getGateWays:self];
    
    // 同步二期帐号至三期(二期登陆帐号保存在plist，三期保存在数据库)
    [self transLoginUserData2To3];
    
    // 用户信息
    [UserInfoManagerInstance() initWithCurSchool];
    
    // 重新加载帐号
//    [LoginViewControllerInstance() initViewData:UserInfoManagerInstance().userInfo];
    
    // 自动登陆
    if([LoginManagerInstance() autoLogin]) {
        _autoLogin = YES;
    }
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    LoginManager *loginManager = LoginManagerInstance();
    [loginManager addDelegate:self];
    
    [self updateViewControllers];
    [self setupNavigationBar];
    
    if(self.tabItem != 0) {
        [self selectTabAtIndex:self.tabItem];
        if(!_autoLogin)
            self.tabItem = 0;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    LoginManager *loginManager = LoginManagerInstance();
    [loginManager removeDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 横屏切换
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - 界面逻辑
- (void)setupNavigationBar {
    // TODO:设置左边按钮
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    if(nvc.viewControllers.count > 1) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBackBlue ofType:@"png"]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"Navigation", nil) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBackBlueC ofType:@"png"]];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button sizeToFit];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
    
//    self.navigationItem.leftBarButtonItem = self.selectedViewController.navigationItem.leftBarButtonItem;
//    self.navigationItem.leftBarButtonItems = self.selectedViewController.navigationItem.leftBarButtonItems;
    
    // TODO:设置右边按钮
    self.navigationItem.rightBarButtonItem = self.selectedViewController.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItems = self.selectedViewController.navigationItem.rightBarButtonItems;
    
    // 标题栏
    UIImage *image = nil;
    image = [UIImage imageWithContentsOfFileLanguage:[ResourcePacketManagerInstance() resourceFilePath:NavigationTitleImage] ofType:@"png"];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationDefaultTitleImage ofType:@"png"]];
    }
    nvc.customTitleImage = image;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = imageView;
}
- (void)resetNavigationBar {
}
- (void)backAction:(id)sender {
    LoginManager *loginManager = LoginManagerInstance();
    if(loginManager.sessionKey.length > 0) {
        // 已经登陆则弹出注销提示
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CommonEnsureLogout", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
        [alertView show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)checkResPacket {
    ResourcePacketManager* resPacketManager = ResourcePacketManagerInstance() ;
    ResourcePacketInfo* packinfo = [resPacketManager findResPacketWithSchoolKey:DrPalmGateWayManagerInstance().schoolKey];
    NSString* timestamp = @"0";
    if(packinfo != nil)
        timestamp = packinfo.timestamp;
    
    if(!self.resDownLoadManager) {
        self.resDownLoadManager = [[ResourceDownloadManager alloc] init];
        [self.resDownLoadManager addDelegate:self];
    }
    [self.resDownLoadManager checkResourcePacket:timestamp];
}
#pragma mark - 兼容2期
- (NSString*)decryNSData:(NSData*)data {
    NSString* strreturn = nil;
    if(data == nil)
        return strreturn;
    NSData* decryptedData = [data AES256DecryptWithKey:ENCRYPT_KEY];
    strreturn = [[NSString alloc] initWithData:decryptedData encoding:NSASCIIStringEncoding];
    return strreturn;
}
- (void)transLoginUserData2To3 {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *nschoolKey = @"SettingDefault";
    if(DrPalmGateWayManagerInstance().schoolKey)
        nschoolKey = DrPalmGateWayManagerInstance().schoolKey;
    
    NSString *realPath = [NSString stringWithFormat:@"%@/%@setting.plist", documentPath, nschoolKey];
    NSDictionary *dictSetting = [[NSDictionary alloc] initWithContentsOfFile:realPath];
    if (nil != dictSetting){
        
        BOOL bOnlyWifi = [[dictSetting objectForKey:@"WIFI"] isEqualToString:@"YES"];
        if([dictSetting objectForKey:@"AccountInfo"] != nil){
            NSMutableArray * accountArray = [NSMutableArray arrayWithArray:[dictSetting objectForKey:@"AccountInfo"]];
            if(accountArray && accountArray.count > 0)
            {
                for(NSDictionary* dict in accountArray)
                {
                    //LoginManagerInstance().accountName = account.userName;
                    [UserInfoManagerInstance() loadCurUserInfo:[dict objectForKey:TEXT_ACCOUNT]];
                    id pwdData = [dict objectForKey:TEXT_PASSWORD];
                    if(pwdData != nil && [pwdData isKindOfClass:[NSData class]])
                    {
                        UserInfoManagerInstance().userInfo.password = [self decryNSData:[dict objectForKey:TEXT_PASSWORD]];
                    }
                    UserInfoManagerInstance().userInfo.isautologin = [NSNumber numberWithBool:[[dict objectForKey:SWITCH_AUTOLOGIN] isEqualToString:@"YES"]];
                    UserInfoManagerInstance().userInfo.isrememberme = [NSNumber numberWithBool:[[dict objectForKey:SWITCH_ISSAVEACCOUNTINFO] isEqualToString:@"YES"]];
                }
                UserInfoManagerInstance().isOnlyWifi = bOnlyWifi;
                [UserInfoManagerInstance() saveUserInfo];
                //数据迁移后删除原来数据
                NSDictionary* emptyDict = [NSDictionary dictionary];
                [emptyDict writeToFile:realPath atomically:YES];
            }
        }
        return;
    }
}
#pragma mark - (底部分页控件)
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0) {
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self setupNavigationBar];
    [self selectTabBarItem:tabBarController viewController:viewController];
}
- (void)selectTabBarItem:(UITabBarController *)tabBarController viewController:(UIViewController *)viewController{
    // 显示对应的高亮tabrBarItem
    for(KKTabBarItem *tabrBarItem in tabBarController.tabBar.items) {
        [tabrBarItem setSelected:NO];
    }
    KKTabBarItem *tabrBarItem = (KKTabBarItem *)viewController.tabBarItem;
    [tabrBarItem setSelected:YES];
}
- (void)selectTabAtIndex:(int)index {
    if(index > self.viewControllers.count)
        return;
    self.selectedViewController = [self.viewControllers objectAtIndex:index];
    [self selectTabBarItem:self viewController:self.selectedViewController];
    [self setupNavigationBar];
}
- (void)selectTabViewController:(UIViewController *)viewController {
    self.selectedViewController = [self.viewControllers objectAtIndex:self.selectedIndex];
    [self setupNavigationBar];
}
- (void)updateViewControllers {
    NSMutableArray *moduleArray = [NSMutableArray array];
    
    for(EBabyModule *module in EBabyModuleListInstance().modules) {
        if(module.viewController)
            [moduleArray addObject:module.viewController];
        
        KKTabBarItem *tabrBarItem = (KKTabBarItem *)module.viewController.tabBarItem;
        tabrBarItem.kkimage = module.tabBarUnSelectedIcon;
        tabrBarItem.kkselectedImage = module.tabBarSelectedIcon;
        tabrBarItem.isFullItemImage = YES;
        tabrBarItem.isHighLight = NO;
        [tabrBarItem setSelected:NO];
        
        // 刷新Tabbar数字
        if([module.viewController respondsToSelector:@selector(reloadTabbarItem)]) {
            [module.viewController performSelector:@selector(reloadTabbarItem)];
        }
    }
    
    self.viewControllers = moduleArray;

    if(self.selectedIndex > 0 && self.selectedIndex < self.tabBar.items.count) {
        [self selectTabAtIndex:self.selectedIndex];
    }
    else {
        // TODO:默认选上第一项
        [self selectTabAtIndex:0];
    }
}

#pragma mark － 回退注销提示
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            // 取消
            break;
        }
        case 1:{
            // 确定
            [LoginManagerInstance() logout];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}
#pragma mark － 登陆状态改变回调（LoginManagerDelegate）
- (void)loginStatusChanged:(LoginStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 重置tabbar和tabcontroller
        [self updateViewControllers];
        [self setupNavigationBar];
        if(status == LoginStatus_online) {
            if(_autoLogin && self.tabItem != 0) {
                // 由推送进入并且自动登陆成功
                // TODO:最新通告
                UIStoryboard *storyBoard = AppDelegate().storyBoard;
                LatestClassEventViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"LatestClassEventViewController"];
                KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
                [nvc pushViewController:vc animated:YES gesture:YES];
                _autoLogin = NO;
            }
            
            //欢迎提示
            NSString* tips = [NSString stringWithFormat:@"%@%@!", NSLocalizedString(@"Welcome", nil), [LoginManagerInstance() userName]];
            [MyNotificationManager notificationWithMessage:tips];
        }
    });
}
#pragma mark - 获取网关回调
- (void)getGateWaySuccess {
    // 获取网关成功,开始获取资源包
    [self checkResPacket];
}
#pragma mark - 获取资源包回调
- (void)downloadFinish:(ResourceDownloadManager*)resourceDownloadManager packet:(ResourcePacket*)packet left:(NSInteger)left {
    [self setupNavigationBar];
}
@end
