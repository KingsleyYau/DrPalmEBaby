//
//  LatestClassEventListViewController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-4-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "LatestClassEventViewController.h"
#import "ClassMainListViewController.h"
#import "ClassAlbumListViewController.h"
#import "ClassVideoListViewController.h"
#import "ClassSentListViewController.h"
#import "SystemMessageListViewController.h"
#import "CommunicateListViewController.h"

#import "ClassCommonDef.h"
#import "CommonDataManager.h"


@interface LatestClassEventViewController () <ClassRequestOperatorDelegate, EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;

    BOOL _reloading;
}
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;

- (void)setupTableView;

- (void)reloadData:(BOOL)isReloadView;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (BOOL)loadFromServer;
- (void)cancel;
@end

@implementation LatestClassEventViewController
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
    [self setupTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadFromServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面布局
//- (void)refreshAction:(id)sender{
//    [_refreshHeaderView egoRefreshScrollViewRefresh:self.tableView];
//}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
//    // TODO: 导航栏标题
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    titleLabel.text = NSLocalizedString(@"LatestClassEventNavigationTitle", nil);
//    titleLabel.backgroundColor = [UIColor clearColor];
//    [titleLabel sizeToFit];
//    self.navigationItem.titleView = titleLabel;
//    
//    UIButton *button = nil;
//    UIImage *image = nil;
//    
//    // 右边按钮
//    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationRefreshButton ofType:@"png"]];
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
//    [button setImage:image forState:UIControlStateNormal];
//    [button sizeToFit];
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = barButtonItem;
}
- (void)setupTableView {
    if(!_refreshHeaderView) {
        // 下拉刷新
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, BLANKING_Y - _tableView.bounds.size.height, _tableView.frame.size.width, _tableView.bounds.size.height)];
        [_tableView addSubview:_refreshHeaderView];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [_tableView addSubview:_refreshHeaderView];
        _refreshHeaderView.lastUpdatedLabel.textColor = AppEnviromentInstance().globalUIEntitlement.egoRefreshTableHeaderViewColor;
        _refreshHeaderView.statusLabel.textColor = AppEnviromentInstance().globalUIEntitlement.egoRefreshTableHeaderViewColor;
        [_refreshHeaderView refreshLastUpdatedDate];
    }
}
#pragma mark - 界面逻辑
- (void)reloadData:(BOOL)isReloadView {
    if(LoginManagerInstance().userType == UserTypeTeacher)
        self.items = [ClassDataManager showInLatestArray:AccountType_Teacher];
    else
        self.items = [ClassDataManager showInLatestArray:AccountType_Student];
    if(isReloadView) {
        _tableView.items = self.items;
        [_tableView reloadData];
    }
}
- (NSString*)getLastUpdatedText
{
    NSString *text = @"";
//    LatestItem *item = [[CommonDataManager eventsLateList] lastObject];
//    if(item.lastLocalUpdate) {
//        text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"LastUpdateTime", nil), [item.lastLocalUpdate toString2YMDHM], nil];
//    }
    return text;
}
#pragma mark - 协议请求
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    return [self.requestOperator getEventModuleInfoList];
}
- (void)cancel {
    [self doneLoadingTableViewData];
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
#pragma mark - 按钮事件
#pragma mark - 列表回调 ()
- (void)tableView:(LatestClassTableView *)tableView didSelectLatestEvent:(ClassEventCategory *)item {
    ClassEventCategory *category = item;
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    if([category.modulesname isEqualToString:EVENTMODULES]) {
        if([category.type isEqualToString:TYPE_ALBUM]) {
            // TODO: 点击班级相册
            ClassAlbumListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassAlbumListViewController"];
            vc.category = category;
            [nvc pushViewController:vc animated:YES gesture:YES];
        }
        else if([category.type isEqualToString:TYPE_LIST]) {
            // TODO: 点击通告列表
            ClassMainListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassMainListViewController"];
            vc.category = category;
            [nvc pushViewController:vc animated:YES gesture:YES];
        }
        else if([category.type isEqualToString:TYPE_VIDEO]) {
            // TODO: 点击班级视频
            ClassVideoListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassVideoListViewController"];
            vc.category = category;
            [nvc pushViewController:vc animated:YES gesture:YES];
        }
    }
    else if([item.modulesname isEqualToString:SENTEVENTMODULE]){
        // TODO: 已发
        ClassSentListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassSentListViewController"];
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if([item.modulesname isEqualToString:SYSMSGMODULE]){
        // TODO: 系统信息
        SystemMessageListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SystemMessageListViewController"];
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if([item.modulesname isEqualToString:FACE2FACEMOUDLE]){
        // TODO: 点击家园桥
        UIStoryboard *storyBoard = AppDelegate().storyBoard;
        KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
        CommunicateListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"CommunicateListViewController"];
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
#pragma mark - 数据加载 (Data Source Loading / Reloading Methods)
- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [self loadFromServer];
}
- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
    if(_refreshHeaderView)
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}
#pragma mark - 滚动界面回调 (UIScrollViewDelegate)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark - 上下拉界面回调 (EGORefreshTableHeaderDelegate)
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    if(_refreshHeaderView == view)
        [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSString *)egoRefreshTableHeaderDataSourceLastUpdatedString:(EGORefreshTableHeaderView*)view{
    NSString *text = [self getLastUpdatedText];
    return text;
}
#pragma mark - 协议回调 (ClassRequestOperatorDelegate)
-(void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        default: {
            [self reloadData:YES];
            break;
        }
    }
}
-(void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        default:{
            break;
        }
    }
}
@end
