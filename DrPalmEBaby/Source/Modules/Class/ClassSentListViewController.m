//
//  ClassSentListViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassSentListViewController.h"
#import "ClassSentDetailViewController.h"
#import "ClassSentAlbumnDetailViewController.h"
#import "ClassSentVideoDetailViewController.h"

#import "ClassCommonDef.h"

@interface ClassSentListViewController () <ClassRequestOperatorDelegate, EGORefreshTableHeaderDelegate> {
    NSInteger _maxItem;
    BOOL _hasMore;
    BOOL _reloading;
    BOOL _loadMore;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
}

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation ClassSentListViewController

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
    NSDate* lastupdate = [LastUpdateDataManager getLastUpdateWithCategory:Category_ClassSent hasUser:NO];
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
    if(!_loadMore)
        _maxItem = 10;
    
    NSArray *array = [ClassDataManager eventSentList];
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
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"ClassCategorySendTitle", nil);
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
#pragma mark － 界面逻辑
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
    return category;
}
- (NSString*)getLastUpdatedText {
    // TODO:最后更新时间
    NSString *text = nil;
    return text;
}
- (NSDate*)getMinLastUpdateInArray:(NSArray*)array
{
    NSInteger lastupdate = 0;
    int count = 0;
    for(ClassEventSent* eventsent in array)
    {
        NSInteger time = [eventsent.lastUpdate timeIntervalSince1970];
        if(count == 0)
            lastupdate = time;
        else
            lastupdate = lastupdate>time?time:lastupdate;
        count ++;
    }
    return [NSDate dateWithTimeIntervalSince1970:lastupdate];
}
#pragma mark - 列表界面回调
- (void)needReloadData:(ClassListSentTableView *)tableView {
    [self reloadData:NO];
}
- (void)tableView:(ClassListSentTableView *)tableView didSelectClassEventSent:(ClassEventSent *)item {
    ClassEventCategory *category = [[item.categories allObjects] lastObject];
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    if([category.type isEqualToString:TYPE_ALBUM]) {
        // TODO: 点击班级相册
        ClassSentAlbumnDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassSentAlbumnDetailViewController"];
        vc.item = item;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if ([category.type isEqualToString:TYPE_VIDEO]) {
        // TODO: 点击班级视频
        ClassSentVideoDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassSentVideoDetailViewController"];
        vc.item = item;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if([category.type isEqualToString:TYPE_LIST]) {
        // TODO: 点击班级通告
        ClassSentDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassSentDetailViewController"];
        vc.item = item;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
}
- (void)didSelectMore:(ClassListSentTableView *)tableView {
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
#pragma mark - 协议请求
- (void)cancel {
    [self doneLoadingTableViewData];
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)loadFromServer:(BOOL)loadMore {
    _loadMore = loadMore;
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    NSInteger lastUpdate = 0;
    if(loadMore) {
        if(self.items!= nil && self.items.count > 0) {
            NSDate *last = [self getMinLastUpdateInArray:self.items];
            lastUpdate = [last timeIntervalSince1970];
        }
    }
    return [self.requestOperator getSentEventList:lastUpdate];
}
#pragma mark - (协议回调 ClassRequestOperatorDelegate)
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ClassRequestOperator_GetSentEventList: {
            [self reloadData:YES];
            [LastUpdateDataManager updateLastUpdateWithCategory:Category_ClassSent lastupdate:[NSDate date] hasUser:YES];
        }break;
        default:break;
    }
}
-(void)updatedData:(NSInteger)total requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ClassRequestOperator_GetSentEventList: {
            [self reloadData:YES];
            [LastUpdateDataManager updateLastUpdateWithCategory:Category_ClassSent lastupdate:[NSDate date] hasUser:YES];
        }break;
        default:break;
    }
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ClassRequestOperator_GetSentEventList:{
            [self setTopStatusText:error];
        }break;
        default:break;
    }
}
@end
