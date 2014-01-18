//
//  MainGuideViewController.m
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-9-16.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "MainGuideViewController.h"
#import "MainListViewController.h"
#import "MainTabBarController.h"

#import "MainGuideTableViewCell.h"

#import "SchoolDataManager.h"
#import "ClassDataManager.h"
#import "LocalAreaDataManager.h"
#import "LocalAreaRequest.h"
//#import "KGTabBarController.h"
#import "EbabyChanelViewController.h"
//
//#import "DrPalmGatewayManagerInclude.h"
//#import "ResourceDownloadController.h"
//#import "ResourcePacketManager.h"


@interface MainGuideViewController () <LocalAreaRequestOperatorDelegate>{
    BOOL _isFirstTime;
}
@property (nonatomic, retain) LocalAreaRequest *localAreaRequest;
@property (nonatomic, retain) NSArray *items;
@property(nonatomic) SEL buttonAction;
@end

@implementation MainGuideViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isFirstTime = YES;
    self.navigationItem.title = @"导航分区";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData];
    [self getAgentList];
    [self autoSchool];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancel];
}
- (void)didReceiveMemoryWarning
{
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - (界面逻辑)
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"MainGuideNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *button = nil;
    UIImage *image = nil;
    
    // 右边按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationRefreshButton ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}
- (BOOL)autoSchool {
    // TODO:清空旧schoolkey
    DrPalmGateWayManager *drPalmGateWayManager = DrPalmGateWayManagerInstance();
    drPalmGateWayManager.schoolKey = nil;
    drPalmGateWayManager.schoolId = nil;
    if(_isFirstTime && [drPalmGateWayManager lastSchoolKey].length > 0) {
        // TODO:第一次进入并且曾经选择过学校,自动进入
        _isFirstTime = NO;
        drPalmGateWayManager.schoolKey = [drPalmGateWayManager lastSchoolKey];
        [CoreDataManager changeSchool:drPalmGateWayManager.schoolKey];
        
        // 第一次进入该学校
        if(![CoreDataManager isExist]) {
            // 初始化本地分类
            [SchoolDataManager staticCategory];
            [ClassDataManager staticCategory];
        }
        // TODO:进入主界面
        [self toTabBarController];
    }
    return NO;
}
- (void)toTabBarController {
    _isEverPushView = YES;
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    MainTabBarController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    
    UIImage *image = nil;
    image = [UIImage imageWithContentsOfFile:[ResourcePacketManagerInstance() resourceFilePath:NavigationTitleImage]];
    image = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:NavigationTitleImage]];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationDefaultTitleImage ofType:@"png"]];
    }
    nvc.customTitleImage = image;
    [nvc pushViewController:vc animated:YES];
}
- (BOOL)deviceCanDail {
    UIDevice * device = [UIDevice currentDevice];
    NSString* devicetype = device.model;
    if([devicetype isEqualToString:@"iPod touch"]
       || [devicetype isEqualToString:@"iPad"]
       || [devicetype isEqualToString:@"iPhone Simulator"]) {
        return NO;
    }
    else {
        return YES;
    }
}
- (void)refreshAction:(id)sender{
    [self getAgentList];
}
- (CAAnimation *)animationRotate {
    CATransform3D rotationTransform = CATransform3DMakeRotation( 180 , 0 , 1 , 0 );
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration = 0.3;
    animation.beginTime = 0;
    animation.delegate = self;
    return animation;
}
- (void)buttonAnimation:(id)sender action:(SEL)action{
    for(UIButton *button in self.buttonArray) {
        button.enabled = NO;
    }
    
    UIButton *theButton = sender;
    CAAnimation *myAnimationRotate = [self animationRotate];
//    CAAnimationGroup* m_pGroupAnimation;
//    m_pGroupAnimation = [CAAnimationGroup animation];
//    m_pGroupAnimation.delegate = self;
//    m_pGroupAnimation.removedOnCompletion = YES;
//    m_pGroupAnimation.duration = 1;
//    m_pGroupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    m_pGroupAnimation.repeatCount = 1;
//    m_pGroupAnimation.fillMode = kCAFillModeForwards;
//    m_pGroupAnimation.animations = [NSArray arrayWithObjects:myAnimationRotate, nil];
    [theButton.layer addAnimation:myAnimationRotate forKey:@"animationRotate"];
    self.buttonAction = action;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if([self respondsToSelector:self.buttonAction]) {
        [self performSelector:self.buttonAction];
    }
    
    for(UIButton *button in self.buttonArray) {
        button.enabled = YES;
    }
}
- (IBAction)associationAction:(id)sender {
    [self buttonAnimation:sender action:@selector(pushAssocation)];
}
- (void)pushAssocation {
    // TODO:进入机构列表导航
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    MainListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MainListViewController"];
    Agent *agent = [LocalAreaDataManager agentAssociation];
    vc.curLocalAreaId = agent.localID;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)gardenAction:(id)sender {
    [self buttonAnimation:sender action:@selector(pushGarden)];
}
- (void)pushGarden {
    // TODO:进入幼儿园列表导航
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    MainListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MainListViewController"];
    Agent *agent = [LocalAreaDataManager agentGarden];
    vc.curLocalAreaId = agent.localID;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)clientAction:(id)sender {
    // TODO:进入客服
    [self buttonAnimation:sender action:@selector(callClient)];
}
- (void)callClient {
    // TODO:拨打客服
    if(![self deviceCanDail]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Disable_HotLine", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSString* phoneNO = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"HotLine"];
        NSString* btnTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"HotLine", nil), phoneNO];
        UIActionSheet* actionSheet =[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:btnTitle, nil];
        [actionSheet showInView:self.view];
    }
}
- (IBAction)ebabyAction:(id)sender {
    [self buttonAnimation:sender action:@selector(pushEBabyChanel)];
}
- (void)pushEBabyChanel {
    // TODO:进入EBaby频道
    NSString *deviceToken = nil;
    if (nil != AppDelegate().deviceToken){
        deviceToken = [[NSString stringWithFormat:@"%@", AppDelegate().deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
        deviceToken = [deviceToken substringWithRange:NSMakeRange(1, [deviceToken length]-2)];
    }
    NSString* pagewidth = [NSString stringWithFormat:@"%f", self.view.frame.size.width];
    NSString *urlString = [NSString stringWithFormat:EBABYCHANNEL_COMMON_URL,deviceToken, pagewidth];
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    EbabyChanelViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"EbabyChanelViewController"];
    
    vc.myNavigationController = self.navigationController;
    [vc loadUrl:[NSURL URLWithString:urlString]];
    [nvc pushViewController:vc animated:YES gesture:NO];
}
- (void)reloadData {
    self.buttonArray = [NSMutableArray array];
    
    NSMutableArray *array = [NSMutableArray array];
    
    // TODO:是否显示幼儿园
    Agent *agent = [LocalAreaDataManager agentGarden];
    if(agent) {
        UIButton *button = nil;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageWithContentsOfFileLanguage:[[NSBundle mainBundle] pathForResource:GuideGardenImage ofType:@"png"] ofType:@"png"];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(gardenAction:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [array addObject:button];
    }
    // TODO:是否显示培训机构
    agent = [LocalAreaDataManager agentAssociation];
    if(agent) {
        UIButton *button = nil;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageWithContentsOfFileLanguage:[[NSBundle mainBundle] pathForResource:GuideAssociationImage ofType:@"png"] ofType:@"png"];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(associationAction:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [array addObject:button];
    }
    
    UIButton *button = nil;
    UIImage *image = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    image = [UIImage imageWithContentsOfFileLanguage:[[NSBundle mainBundle] pathForResource:GuideServiceImage ofType:@"png"] ofType:@"png"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clientAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [array addObject:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    image = [UIImage imageWithContentsOfFileLanguage:[[NSBundle mainBundle] pathForResource:GuideEBabyImage ofType:@"png"] ofType:@"png"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ebabyAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [array addObject:button];
    self.items = array;
    
    [self.tableView reloadData];
}
#pragma mark - (协议接口)
- (void)cancel {
    if(self.localAreaRequest) {
        [self.localAreaRequest cancel];
        self.localAreaRequest = nil;
    }
}
- (BOOL)getAgentList {
    [self cancel];
    if(!self.localAreaRequest) {
        self.localAreaRequest = [[LocalAreaRequest alloc] init];
        self.localAreaRequest.delegate = self;
    }
    
    return [self.localAreaRequest getAgentList:TopAgentId];
}
#pragma mark (协议回调)
-(void)operateFinish:(id)data requestType:(LocalAreaRequestStatus)type {
    [self cancel];
    [self reloadData];
}
-(void)operateFail:(NSString*)error requestType:(LocalAreaRequestStatus)type {
    [self cancel];
    [self setTopStatusText:error];
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = (nil == self.items)?0:(self.items.count + 1)/ 2;
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MainGuideTableViewCell cellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainGuideTableViewCell *cell = [MainGuideTableViewCell getUITableViewCell:tableView];
    NSInteger index = 2 * indexPath.row;
    if(index < self.items.count) {
        // TODO:按钮1
        UIButton *button1 = [self.items objectAtIndex:index];
        [button1 removeFromSuperview];
        [cell.view1 addSubview:button1];
        button1.center = CGPointMake(cell.view1.bounds.size.width / 2, cell.view1.bounds.size.height / 2);
        [self.buttonArray addObject:button1];
        
        // TODO:按钮2
        if(2 * indexPath.row + 1 < self.items.count) {
            UIButton *button2 = [self.items objectAtIndex:index + 1];
            [button2 removeFromSuperview];
            [cell.view2 addSubview:button2];
            button2.center = CGPointMake(cell.view2.bounds.size.width / 2, cell.view2.bounds.size.height / 2);
            [self.buttonArray addObject:button2];
        }

        
        // TODO:背景
        if(indexPath.row % 2 == 0) {
            cell.view1.backgroundColor = [UIColor whiteColor];
            cell.view2.backgroundColor = [UIColor colorWithIntRGB:113 green:201 blue:237 alpha:255];
        }
        else {
            cell.view1.backgroundColor = [UIColor colorWithIntRGB:113 green:201 blue:237 alpha:255];
            cell.view2.backgroundColor = [UIColor whiteColor];
        }
    }
    return cell;
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex){
        NSString* phoneNO = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"HotLine"];
        NSString* str = [NSString stringWithFormat:@"tel://%@",phoneNO];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
@end
