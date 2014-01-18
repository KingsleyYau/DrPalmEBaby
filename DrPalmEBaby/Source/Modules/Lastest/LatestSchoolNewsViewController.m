//
//  LatestSchoolNewsViewController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-4-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "LatestSchoolNewsViewController.h"
#import "SchoolMainListViewController.h"
#import "SchoolAlbumListViewController.h"

#import "SchoolCommonDef.h"
#import "CommonDataManager.h"

@interface LatestSchoolNewsViewController () <SchoolRequestOperatorDelegete, EGORefreshTableHeaderDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) SchoolRequestOperator *requestOperator;

- (void)setupTableView;

- (void)reloadData:(BOOL)isReloadView;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (BOOL)loadFromServer;
- (void)cancel;
@end
@implementation LatestSchoolNewsViewController
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
    
    // TODO: 导航栏标题
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    titleLabel.text = NSLocalizedString(@"LatestSchoolNewsNavigationTitle", nil);
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
    // TODO: 下拉界面
    if(!_refreshHeaderView) {
        // 下拉刷新
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - _tableView.bounds.size.height, _tableView.frame.size.width, _tableView.bounds.size.height)];
        [_tableView addSubview:_refreshHeaderView];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        _refreshHeaderView.lastUpdatedLabel.textColor = AppEnviromentInstance().globalUIEntitlement.egoRefreshTableHeaderViewColor;
        _refreshHeaderView.statusLabel.textColor = AppEnviromentInstance().globalUIEntitlement.egoRefreshTableHeaderViewColor;
        [_refreshHeaderView refreshLastUpdatedDate];
    }
}
#pragma mark - 界面逻辑
- (void)reloadData:(BOOL)isReloadView {
    self.items = [SchoolDataManager categoryList];
    if(isReloadView) {
        self.tableView.items = self.items;
        [self.tableView reloadData];
    }
}
- (NSString*)getLastUpdatedText {
    NSString *text = @"";
//    LatestItem *item = [[CommonDataManager newsLateList] lastObject];
//    if(item.lastLocalUpdate) {
//        text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"LastUpdateTime", nil), [item.lastLocalUpdate toString2YMDHM], nil];
//    }
    return text;
}
#pragma mark - 列表回调 ()
- (void)tableView:(LatestSchoolNewsTableView *)tableView didSelectLatestNews:(SchoolNewsCategory *)item {
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    if([item.type isEqualToString:TYPE_ALBUM]) {
        // 相册
        SchoolAlbumListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolAlbumListViewController"];
        vc.category = item;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if([item.type isEqualToString:TYPE_LIST]) {
        // 列表
        KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
        SchoolMainListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolMainListViewController"];
        vc.category = item;
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
#pragma mark - 协议请求
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[SchoolRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    return [self.requestOperator getNewsModuleInfoList];
}
- (void)cancel {
    [self doneLoadingTableViewData];
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
#pragma mark - 协议回调 (SchoolRequestOperatorDelegete)
-(void)operateFinish:(id)data requestType:(SchoolRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        default: {
            [self reloadData:YES];
            break;
        }
    }
}
-(void)operateFail:(NSString*)error requestType:(SchoolRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        default:{
            break;
        }
    }
}

@end
