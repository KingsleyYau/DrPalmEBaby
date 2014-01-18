//
//  SchoolAlbumListViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SchoolAlbumListViewController.h"
#import "SchoolAlbumnDetailViewController.h"

#import "SchoolCommonDef.h"

@interface SchoolAlbumListViewController () <SchoolRequestOperatorDelegete, EGORefreshTableHeaderDelegate>{
    NSInteger _maxItem;
    BOOL _hasMore;
    BOOL _reloading;
    BOOL _loadMore;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property (nonatomic, retain) SchoolNewsCategory *itemCategory;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) SchoolRequestOperator *requestOperator;
@end

@implementation SchoolAlbumListViewController

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
    //是否自动刷新
    if(UserInfoManagerInstance().isOnlyWifi && ![WiFiChecker isWiFiEnable])
        return;
    NSDate* lastupdate = [LastUpdateDataManager getLastUpdateWithCategory:[self categoryTrans:self.category.category_id] hasUser:NO];
    if(lastupdate != nil)
    {
        if([[NSDate date]timeIntervalSinceDate:lastupdate] > UPDATETIMEINTEVAL)
        {
            [_refreshHeaderView egoRefreshScrollViewRefresh:_tableView];
        }
    }
    else
        [_refreshHeaderView egoRefreshScrollViewRefresh:_tableView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark － 界面逻辑
- (void)reloadData:(BOOL)isReloadView {
    if(!_loadMore)
        _maxItem = 10;
    
    NSArray *array = [SchoolDataManager newsListWithCatalog:self.category.category_id];
    if(array) {
        NSInteger limit = array.count;
        if(array.count >= _maxItem) {
            // 数据库条数大于可以显示的条数,显示更多
            limit = _maxItem;
            _hasMore = YES;
        }
        else {
            _hasMore = NO;
        }
        self.items = [array subarrayWithRange:NSMakeRange(0, limit)];
        //        if(limit > 10)
        //            _maxItem = limit;
    }
    else {
        self.items = array;
    }
    if(isReloadView) {
        // 改变分隔符线颜色
        if(self.items.count > 0) {
            [self.tipsLabel setHidden:YES];
        }
        else {
            [self.tipsLabel setHidden:NO];
        }
        self.tableView.items = self.items;
        self.tableView.hasMore = _hasMore;
        [self.tableView reloadData];
    }
}
- (void)setupTableView {
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
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(self.category.title, nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (NSInteger)categoryTrans:(NSString*)curCategory {
    // TODO:分类逻辑转换
    NSInteger category = Category_SchoolActivity;
    if([curCategory isEqualToString:SchoolCategoryIdActivity])
        category = Category_SchoolActivity;
    else if([curCategory isEqualToString:SchoolCategoryIdDiet])
        category =  Category_SchoolRecipeDiet;
    else if([curCategory isEqualToString:SchoolCategoryIdNews])
        category = Category_SchoolNews;
    else if([curCategory isEqualToString:SchoolCategoryIdChildren])
        category = Category_SchoolChildren;
    else if([curCategory isEqualToString:SchoolCategoryIdAlbum])
        category = Category_SchoolAlbum;
    return category;
}
- (NSString*)getLastUpdatedText {
    // TODO:最后更新时间
    NSString *text = nil;
    if(self.category.lastUpdated && self.category.expectedCount) {
        text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"LastUpdateTime", nil), [self.category.lastUpdated toString2YMDHM], nil];
    }
    return text;
}
#pragma mark - 列表界面回调
- (void)needReloadData:(SchoolAlbumListTableView *)tableView {
    [self reloadData:NO];
}
- (void)tableView:(SchoolAlbumListTableView *)tableView didSelectSchoolNews:(SchoolNews *)item {
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    SchoolAlbumnDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolAlbumnDetailViewController"];
    vc.item = item;
    [nvc pushViewController:vc animated:YES gesture:NO];
}
- (void)didSelectMore:(SchoolAlbumListTableView *)tableView {
    // 点击更多
    _maxItem += 10;
    [self loadFromServer:YES];
}
#pragma mark - 数据加载 (Data Source Loading / Reloading Methods)
- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [self loadFromServer:NO];
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
#pragma mark - 协议
- (void)cancel {
    [self doneLoadingTableViewData];
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)loadFromServer:(BOOL)loadMore {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[SchoolRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    _loadMore = loadMore;
    NSInteger lastUpdate = 0;
    if(loadMore) {
        if(self.items) {
            SchoolNews *item  = [self.items lastObject];
            lastUpdate = [item.lastUpdate timeIntervalSince1970];
        }
    }
    [self.requestOperator getNewsList:self.category.category_id lastupdate:lastUpdate];
    return YES;
}
#pragma mark - 协议回调 (SchoolRequestOperatorDelegate)
- (void)operateFinish:(id)data requestType:(SchoolRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case SchoolRequestOperator_GetNewsList: {
            [self reloadData:YES];
            [LastUpdateDataManager updateLastUpdateWithCategory:[self categoryTrans:self.category.category_id] lastupdate:[NSDate date] hasUser:NO];
            
        }break;
        default:break;
    }
}
- (void)operateFail:(NSString*)error requestType:(SchoolRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case SchoolRequestOperator_GetNewsList:{
            [self setTopStatusText:error];
        }break;
        default:break;
    }
}

@end
