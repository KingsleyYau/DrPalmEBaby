//
//  ClassAlbumListViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassAlbumListViewController.h"
#import "ClassAlbumnDetailViewController.h"

#import "ClassCommonDef.h"

@interface ClassAlbumListViewController () <ClassRequestOperatorDelegate, EGORefreshTableHeaderDelegate>{
    BOOL _reloading;

    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation ClassAlbumListViewController

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
    NSDate* lastupdate = [LastUpdateDataManager getLastUpdateWithCategory:[self categoryTrans:self.category.category_id] hasUser:YES];
    if(lastupdate != nil)
    {
        if([[NSDate date]timeIntervalSinceDate:lastupdate] > UPDATETIMEINTEVAL)
        {
            [_refreshHeaderView egoRefreshScrollViewRefresh:self.tableView];
        }
    }
    else
        [_refreshHeaderView egoRefreshScrollViewRefresh:_tableView];
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
#pragma mark － 界面逻辑
- (void)reloadData:(BOOL)isReloadView{
    self.items = [ClassDataManager eventListWithCatalog:self.category.category_id];
    
    if(isReloadView) {
        // 改变分隔符线颜色
        if(self.items.count > 0) {
            [self.tipsLabel setHidden:YES];
        }
        else {
            [self.tipsLabel setHidden:NO];
        }
        self.tableView.items = self.items;
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
    NSInteger category = Category_ClassNews;
    if([curCategory isEqualToString:ClassCategoryIdNews])
        category = Category_ClassNews;
    else if([curCategory isEqualToString:ClassCategoryIdComment])
        category =  Category_ClassRemark;
    else if([curCategory isEqualToString:ClassCategoryIdCourseware])
        category = Category_ClassCouseware;
    else if([curCategory isEqualToString:ClassCategoryIdActivity])
        category = Category_ClassActivity;
    else if([curCategory isEqualToString:ClassCategoryIdAlbum])
        category = Category_ClassAlbum;
    else if([curCategory isEqualToString:ClassCategoryIdVideo])
        category = Category_ClassVide;
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
- (void)needReloadData:(ClassAlbumListTableView *)tableView {
    [self reloadData:NO];
}
- (void)tableView:(ClassAlbumListTableView *)tableView didSelectClassEvent:(ClassEvent *)item {
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassAlbumnDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassAlbumnDetailViewController"];
    vc.item = item;
    [nvc pushViewController:vc animated:YES gesture:NO];
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
#pragma mark - 协议
- (void)cancel {
    [self doneLoadingTableViewData];
    if(self.requestOperator) {
        [self.requestOperator cancel];
        self.requestOperator = nil;
    }
}
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    NSInteger lastUpdate = 0;
    NSInteger lastReadTime = 0;

    if(self.items) {
        NSDate* date = [ClassDataManager lastupdateWithCatalog:self.category.category_id];
        if(date)
            lastUpdate = [date timeIntervalSince1970];
        date = [ClassDataManager lastReadTimeWithCatalog:self.category.category_id];
        if(date)
            lastReadTime = [date timeIntervalSince1970];
    }
    
    return [self.requestOperator getEventList:self.category.category_id lastupdate:lastUpdate lastReadTime:lastReadTime];
}
#pragma mark - 协议回调 (SchoolRequestOperatorDelegate)
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ClassRequestOperator_GetEventList: {
            [self reloadData:YES];
            [LastUpdateDataManager updateLastUpdateWithCategory:Category_ClassAlbum lastupdate:[NSDate date] hasUser:YES];
        }break;
        default:break;
    }
}
-   (void)updatedData:(NSInteger)total requestType:(ClassRequestOperatorStatus)type {
    switch(type){
        case ClassRequestOperator_GetEventList: {
            [self reloadData:YES];
            [LastUpdateDataManager updateLastUpdateWithCategory:[self categoryTrans:self.category.category_id] lastupdate:[NSDate date] hasUser:YES];
        }break;
        default:break;
    }
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ClassRequestOperator_GetEventList:{
            [self setTopStatusText:error];
        }break;
        default:break;
    }
}
@end
