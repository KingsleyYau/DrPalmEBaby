//
//  SystemMessageListViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SystemMessageListViewController.h"
#import "SystemMessageDetailViewController.h"

#import "SystemTableViewCell.h"
#import "SystemMessageDataManager.h"
#import "LastUpdateDataManager.h"
#import "ClassRequestOperator.h"

@interface SystemMessageListViewController () <ClassRequestOperatorDelegate, EGORefreshTableHeaderDelegate> {
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation SystemMessageListViewController

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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //是否自动刷新
    if(UserInfoManagerInstance().isOnlyWifi && ![WiFiChecker isWiFiEnable])
        return;
    NSDate* lastupdate = [LastUpdateDataManager getLastUpdateWithCategory:Category_SysMessage hasUser:YES];
    if(lastupdate != nil)
    {
        if([[NSDate date]timeIntervalSinceDate:lastupdate] > UPDATETIMEINTEVAL)
        {
            [_refreshHeaderView egoRefreshScrollViewRefresh:self.tableView];
        }
    }
    else
        [_refreshHeaderView egoRefreshScrollViewRefresh:self.tableView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark － 界面逻辑
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"ClassCategorySysinfoTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
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
- (void)reloadData:(BOOL)isReloadView {
    self.items = [SystemMessageDataManager messageList];
    if(isReloadView) {
        [self.tableView reloadData];
    }
}
#pragma mark - (列表界面回调)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int number = 1;
    return number;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = self.items.count;
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [SystemTableViewCell cellHeight];
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if(indexPath.row < self.items.count) {
        SystemTableViewCell *cell = [SystemTableViewCell getUITableViewCell:tableView];
        result = cell;
        
        SystemMessage *item = (SystemMessage *)[self.items objectAtIndex:indexPath.row];
        
        // 标题
        if([item.isRead boolValue]) {
            // 已读
            cell.titleLabel.textColor = [UIColor colorWithIntRGB:176 green:170 blue:156 alpha:255];
        }
        else {
            cell.titleLabel.textColor = [UIColor colorWithIntRGB:6 green:112 blue:138 alpha:255];
        }
        cell.titleLabel.text = item.title;
        
        // 描述
        if([item.isRead boolValue]) {
            // 已读
            cell.desLabel.textColor = [UIColor colorWithIntRGB:176 green:170 blue:156 alpha:255];
        }
        else {
            cell.desLabel.textColor = [UIColor colorWithIntRGB:6 green:112 blue:138 alpha:255];
        }
        cell.desLabel.text = item.summary;

        // 时间
        if([item.isRead boolValue]) {
            // 已读
            cell.timeLabel.textColor = [UIColor colorWithIntRGB:176 green:170 blue:156 alpha:255];
        }
        else {
            cell.timeLabel.textColor = [UIColor colorWithIntRGB:6 green:112 blue:138 alpha:255];
        }
        NSString *strTime = [NSString stringWithFormat:@"%@", [item.lastUpdate toStringYMD], nil];
        cell.timeLabel.text = strTime;
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemMessage *item = [self.items objectAtIndex:indexPath.row];
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    SystemMessageDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SystemMessageDetailViewController"];
    vc.item = item;
    [nvc pushViewController:vc animated:YES gesture:YES];
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
    NSString *text = @"";
    return text;
}
- (void)cancel {
    [self doneLoadingTableViewData];
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)loadFromServer {
    [self cancel];
    if(self.requestOperator == nil) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    NSInteger lastupid = 0;
    if(self.items != nil && self.items.count > 0)
    {
        SystemMessage *item = (SystemMessage *)[self.items objectAtIndex:0];
        lastupid = [item.system_id intValue];
    }
    return [self.requestOperator getSysMsgs:lastupid];
}
#pragma mark ClassRequestOperatorDelegate
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    [self reloadData:YES];
    [LastUpdateDataManager updateLastUpdateWithCategory:Category_SysMessage lastupdate:[NSDate date] hasUser:YES];
    return;
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:error];
    return;
}
@end
