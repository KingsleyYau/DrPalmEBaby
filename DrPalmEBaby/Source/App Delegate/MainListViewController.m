//
//  MainListViewController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-7.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "MainListViewController.h"
#import "MainTabBarController.h"
#import "MainSearchListViewController.h"
#import "EbabyChanelViewController.h"

#import "MainListTableViewCell.h"
#import "EBabyHeaderTableViewCell.h"

#import "LocalAreaRequest.h"
#import "LocalAreaDataManager.h"
#import "ClassDataManager.h"
#import "SchoolDataManager.h"

@interface MainListViewController () <LocalAreaRequestOperatorDelegate> {
}
@property (nonatomic, retain) LocalAreaRequest *request;
@property (nonatomic, retain) NSArray *bookmarkItemArray;
@property (nonatomic, retain) NSArray *curLocalAreaItemArray;
@property (nonatomic, retain) NSString *url;

@end

@implementation MainListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.curLocalAreaId = TopParentId;
        self.tabItem = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self autoSchool];
    [self setupNavigationBar];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadFromServer];
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
#pragma mark - 界面布局
- (void)setupTableView {
    self.tableView.backgroundView = nil;
}
- (BOOL)autoSchool {
    // 清空旧schoolkey
    DrPalmGateWayManager *drPalmGateWayManager = DrPalmGateWayManagerInstance();
    drPalmGateWayManager.schoolKey = nil;
    drPalmGateWayManager.schoolId = nil;
    if(!_isEverPushView && [drPalmGateWayManager lastSchoolKey].length > 0 && [self.curLocalAreaId isEqualToString:TopParentId]) {
        // 第一次进入并且曾经选择过学校,自动进入
        drPalmGateWayManager.schoolKey = [drPalmGateWayManager lastSchoolKey];
        [CoreDataManager changeSchool:drPalmGateWayManager.schoolKey];
        
        // 第一次进入该学校
        if(![CoreDataManager isExist]) {
            // 初始化本地分类
            [SchoolDataManager staticCategory];
            [ClassDataManager staticCategory];
        }
        [self toTabBarController];
    }
    return NO;
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    UIBarButtonItem *barButtonItem = nil;
    UIButton *button = nil;
    UIImage *image = nil;
    
    // TODO:右边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 刷新按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationRefreshButton ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];

    // 搜索按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationSearchButton ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.rightBarButtonItems = array;
    self.navigationItem.titleView = nil;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    nvc.customTitleImage = nil;
}
- (void)setupBackgroundView {
    [super setupBackgroundView];
}

#pragma mark - 按钮事件
- (void)buttonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *localId = [NSString stringWithFormat:@"%d", button.tag];
    LocalArea *area = [LocalAreaDataManager areaWithId:localId];
    area.bookmark = [NSNumber numberWithBool:![area.bookmark boolValue]];
    [LocalCoreDataManager saveData];
    [self reloadData:YES];
}
- (IBAction)searchAction:(id)sender {
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    MainSearchListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MainSearchListViewController"];
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)refreshAction:(id)sender{
    [self loadFromServer];
}
- (void)toTabBarController {
    _isEverPushView = YES;
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    MainTabBarController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    
    [nvc pushViewController:vc animated:YES];
}
- (void)filterArray:(NSArray*) array {
    if(array == nil || array.count<= 0)
        return;
}
- (void)reloadData:(BOOL)isReloadView {
    // 收藏
    self.bookmarkItemArray = [LocalAreaDataManager areaBookmark];
    // 当前父地区
//    self.curParentItem = [LocalAreaDataManager areaWithId:_curLocalAreaId];
    // 当前幼儿园或者地区列表
    self.curLocalAreaItemArray = [LocalAreaDataManager areaWithParentId:_curLocalAreaId];
    if(isReloadView) {
        [self.tableView reloadData];
    }
}
- (void)handleViewSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    NSString *localId = [NSString stringWithFormat:@"%d", gestureRecognizer.view.tag];
    LocalArea *area = [LocalAreaDataManager areaWithId:localId];
    area.bookmark = [NSNumber numberWithBool:![area.bookmark boolValue]];
    [LocalCoreDataManager saveData];
    [self reloadData:YES];
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 2;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch(section) {
        case 0: {
            //if(_curLocalAreaId == TopParentId) {
                // 根节点显示收藏的校园
                number = self.bookmarkItemArray.count;
            //}
        }break;
        case 1: {
            // 显示当前节点的所有子节点
            number = self.curLocalAreaItemArray.count + 1;
        }break;
        default:break;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat number = [MainListTableViewCell cellHeight];
    return number;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    switch (indexPath.section) {
        case 0: {
            // 已经收藏的幼儿园
            LocalArea *area = [self.bookmarkItemArray objectAtIndex:indexPath.row];
            MainListTableViewCell *cell = [MainListTableViewCell getUITableViewCell:tableView];
            cell.titleLabel.text = area.name;
            
            // TODO:区域类型
            if([area.type isEqualToString:SCHOOL]) {
                // TODO:学校,显示收藏
                UIImage *bookmarkImage = nil;
                if([area.bookmark boolValue]) {
                    bookmarkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:GuideButtonBookmark ofType:@"png"]];
                }
                else {
                    bookmarkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:GuideButtonUnBookmark ofType:@"png"]];
                }
                [cell.bookmarkButton setImage:bookmarkImage forState:UIControlStateNormal];
                cell.bookmarkButton.tag = [area.local_id intValue];
                [cell.bookmarkButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                [cell.bookmarkButton setImage:nil forState:UIControlStateNormal];
            }
            result = cell;
            
        }break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    // 区域标题
                    EBabyHeaderTableViewCell *cell = [EBabyHeaderTableViewCell getUITableViewCell:tableView];
                    self.webview = cell.webView;
                    self.webview.delegate = self;
                    
                    NSString *deviceToken = nil;
                    if (nil != AppDelegate().deviceToken){
                        deviceToken = [[NSString stringWithFormat:@"%@", AppDelegate().deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
                        deviceToken = [deviceToken substringWithRange:NSMakeRange(1, [deviceToken length]-2)];
                    }
                    NSString *pagewidth = [NSString stringWithFormat:@"%f", self.webview.frame.size.width - 30];
                    self.url = [NSString stringWithFormat:EBABYCHANNEL_TOPBANNER_URL,deviceToken,pagewidth];
                    
                    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:8];
                    [self.webview loadRequest:urlRequest];
                    [self.webview setHidden:YES];
                    result = cell;
                }break;
                default: {
                    // TODO:区域列表
                    LocalArea *area = [self.curLocalAreaItemArray objectAtIndex:indexPath.row - 1];
                    MainListTableViewCell *cell = [MainListTableViewCell getUITableViewCell:tableView];
                    cell.titleLabel.text = area.name;
                    
                    // TODO:区域类型
                    UIImage *bookmarkImage = nil;
                    if([area.type isEqualToString:SCHOOL]) {
                        // TODO:学校,显示收藏
                        if([area.bookmark boolValue]) {
                            bookmarkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:GuideButtonBookmark ofType:@"png"]];
                        }
                        else {
                            bookmarkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:GuideButtonUnBookmark ofType:@"png"]];
                        }
                    }
                    [cell.bookmarkButton setImage:bookmarkImage forState:UIControlStateNormal];
                    [cell.bookmarkButton sizeToFit];
                    cell.bookmarkButton.tag = [area.local_id intValue];
                    [cell.bookmarkButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

                    result = cell;
                }break;
            }
        }break;
        default:
            break;
    }

    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            // 收藏
            LocalArea *area = [self.bookmarkItemArray objectAtIndex:indexPath.row];
            if([area.type isEqualToString:SCHOOL]) {
                // 是学校则进入模块主界面
                // 记录schoolKey
                DrPalmGateWayManager *drPalmGateWayManager = DrPalmGateWayManagerInstance();
                if(!area.schoolKey) {
                    // 没有schoolkey
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"NoSchoolKey", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
                    [alertView show];
                    return;
                }
                [drPalmGateWayManager setLastSchoolKey:area.schoolKey];
                drPalmGateWayManager.schoolKey = area.schoolKey;
                drPalmGateWayManager.schoolId = nil;
                [CoreDataManager changeSchool:drPalmGateWayManager.schoolKey];

                [self toTabBarController];
            }
        }break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                }break;
                default: {
                    // 区域列表
                    LocalArea *area = [self.curLocalAreaItemArray objectAtIndex:indexPath.row - 1];
                    if([area.type isEqualToString:SCHOOL]) {
                        
                        // 记录schoolKey
                        DrPalmGateWayManager *drPalmGateWayManager = DrPalmGateWayManagerInstance();
                        if(!area.schoolKey) {
                            // 没有schoolkey
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"NoSchoolKey", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
                            [alertView show];
                            return;
                        }
                        [drPalmGateWayManager setLastSchoolKey:area.schoolKey];
                        drPalmGateWayManager.schoolKey = area.schoolKey;
                        drPalmGateWayManager.schoolId = nil;
                        [CoreDataManager changeSchool:drPalmGateWayManager.schoolKey];
                        
                        [self toTabBarController];
                    }
                    else if([area.type isEqualToString:LOCAL]){
                        // 是区域则继续进入
                        UIStoryboard *storyBoard = AppDelegate().storyBoard;
                        
                        KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
                        MainListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MainListViewController"];
                        vc.curLocalAreaId = area.local_id;
                        
                        UIImage *image = nil;
//                        image = [UIImage imageWithContentsOfFile:[ResourcePacketManagerInstance() resourceFilePath:NavigationTitleImage]];
                        if (!image) {
                            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationDefaultTitleImage ofType:@"png"]];
                        }
                        nvc.customTitleImage = image;
                        [nvc pushViewController:vc animated:YES gesture:YES];
                    }
                }break;
            }
        }break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - 协议请求
- (void)cancel {
    
}
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.request) {
        self.request = [[LocalAreaRequest alloc] init];
        self.request.delegate = self;
    }
    return [self.request getSchoolList:self.curLocalAreaId];
}
- (void)operateFinish:(id)data requestType:(LocalAreaRequestStatus)type {
    [self cancel];
    switch (type) {
        case LocalAreaRequestStatus_GetSchoolList: {
            [self reloadData:YES];
        }break;
        default:
            break;
    }
}
- (void)operateFail:(NSString*)error requestType:(LocalAreaRequestStatus)type {
    [self cancel];
    switch (type) {
        case LocalAreaRequestStatus_GetSchoolList: {
            [self setTopStatusText:error];
        }break;
        default:break;
    }
}
#pragma mark - webview回调 (UIWebViewDelegate)
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(UIWebViewNavigationTypeLinkClicked == navigationType) {
        // 不响应用户操作, 打开EBabyChannel
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
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView setHidden:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}
@end
