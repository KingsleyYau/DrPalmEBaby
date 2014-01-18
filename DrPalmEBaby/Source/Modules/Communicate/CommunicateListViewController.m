//
//  CommunicateListViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommunicateListViewController.h"
#import "CommunicateDetailViewController.h"

#import "CommunicateTableViewCell.h"
#import "CommunicateDataManager.h"
#import "LastUpdateDataManager.h"
#import "ClassRequestOperator.h"

@interface CommunicateListViewController () <ClassRequestOperatorDelegate, EGORefreshTableHeaderDelegate, RequestImageViewDelegate> {
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation CommunicateListViewController

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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancel];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    //是否自动刷新
//    if(UserInfoManagerInstance().isOnlyWifi && ![WiFiChecker isWiFiEnable])
//        return;
//    NSDate* lastupdate = [LastUpdateDataManager getLastUpdateWithCategory:Category_ContactList hasUser:YES];
//    if(lastupdate != nil)
//    {
//        if([[NSDate date]timeIntervalSinceDate:lastupdate] > UPDATETIMEINTEVAL)
//        {
//            [_refreshHeaderView egoRefreshScrollViewRefresh:self.tableView];
//        }
//    }
//    else
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
    titleLabel.text = NSLocalizedString(@"CommunicateModule", nil);
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
    self.items = [CommunicateDataManager getCommunicateManList];
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
    CGFloat height = [CommunicateTableViewCell cellHeight];
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if(indexPath.row < self.items.count) {
        CommunicateTableViewCell *cell = [CommunicateTableViewCell getUITableViewCell:tableView];
        result = cell;
        
        CommunicateMan *item = (CommunicateMan *)[self.items objectAtIndex:indexPath.row];
        
        cell.headRequestImageView.contentType = item.headImage.contentType;
        cell.headRequestImageView.imageUrl = item.headImage.path;
        cell.headRequestImageView.imageData = item.headImage.data;
        cell.headRequestImageView.delegate = self;
        [cell.headRequestImageView loadImage];
        
        cell.titleLabel.text = item.contactName;
        
        NSString *strTime = [NSString stringWithFormat:@"%@", [item.lastMessageDate toStringYMD], nil];
        cell.timeLabel.text = strTime;
        cell.timeLabel.hidden = [item.lastMessageDate timeIntervalSince1970] == 0;
        
        NSInteger unReadCount = [item.unread intValue];
        if(unReadCount > 0) {
            [cell.imageViewHead setBadgeValue:[NSString stringWithFormat:@"%d", unReadCount]];
        }else
            [cell.imageViewHead setBadgeValue:nil];
        
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunicateMan *item = [self.items objectAtIndex:indexPath.row];
    // TODO: 点击家园桥
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    CommunicateDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"CommunicateDetailViewController"];
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
    NSArray* array = [CommunicateDataManager getCommunicateManList];
    return [self.requestOperator getContactList:array];
}
#pragma mark ClassRequestOperatorDelegate
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    [self reloadData:YES];
    [LastUpdateDataManager updateLastUpdateWithCategory:Category_ContactList lastupdate:[NSDate date] hasUser:YES];
    return;
}

- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:error];
}
#pragma mark - 异步下载图片控件回调
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    CommunicateFile *file = [CommunicateDataManager fileWithUrl:imageView.imageUrl isLocal:NO];
    if(file) {
        file.data = imageView.imageData;
        file.contentType = imageView.contentType;
        [CoreDataManager saveData];
        [self reloadData:NO];
    }
}
- (UIImage *)imageForDefault:(RequestImageView *)imageView {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ClassCommentHeadDefaultImage ofType:@"png"]];
    return image;
}
@end
