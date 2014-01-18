//
//  GrowupListViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "GrowupListViewController.h"
#import "GrowupDetailViewController.h"
#import "CommonRequestOperator.h"
#import "DraftTableViewCell.h"

@interface GrowupListViewController () <CommonRequestOperatorDelegate, EGORefreshTableHeaderDelegate> {
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    NSInteger _delRow;
}
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, retain) CommonRequestOperator *requestOperator;
@end

@implementation GrowupListViewController

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
    [self loadFromServer];
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
    titleLabel.text = NSLocalizedString(@"GrowUp", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *barButtonItem = nil;
    UIButton *button = nil;
    UIImage *image = nil;
    
    // TODO:右边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 新增按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlue ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [button addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlueC ofType:@"png"]];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
        
    self.navigationItem.rightBarButtonItems = array;
}
- (IBAction)addAction:(id)sender {
    // TODO: 点击新增
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    GrowupDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"GrowupDetailViewController"];
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)deleteAction:(id)sender {
    // TODO: 点击删除
    UIButton *button = (UIButton *)sender;
    _delRow = button.tag;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"EnsureDeleteDraft", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Delete", nil), nil];
    [alert show];
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
    self.items = [UserInfoManager getGrowDiaryList];
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
    CGFloat height = [DraftTableViewCell cellHeight];
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if(indexPath.row < self.items.count) {
        DraftTableViewCell *cell = [DraftTableViewCell getUITableViewCell:tableView];
        result = cell;
        
        GrowDiary *item = (GrowDiary *)[self.items objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.title;
        cell.subTitleLabel.text = item.summary;
        
        cell.button.tag = indexPath.row;
        [cell.button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *strTime = [NSString stringWithFormat:@"%@", [item.lastupdate toStringToday], nil];
        cell.timeLabel.text = strTime;
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: 点击详细
    GrowDiary *item = [self.items objectAtIndex:indexPath.row];

    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    GrowupDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"GrowupDetailViewController"];
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
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 != buttonIndex){
        [self submitAction];
    }
}
- (BOOL)submitAction {
    [self cancel];
    if(self.requestOperator == nil) {
        self.requestOperator = [[CommonRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    GrowDiary *item = [self.items objectAtIndex:_delRow];
    
    GrowDiaryForSent *sentItem = [UserInfoManager newGrowDiaryForSent];
    sentItem.diaryid = item.diaryid;
    sentItem.status = OperateStatus_Del;
    
    NSMutableArray* array = [NSMutableArray array];
    [array addObject:sentItem];
    
    return [self.requestOperator submitGrowDiary:array];
}
- (BOOL)loadFromServer {
    [self cancel];
    if(self.requestOperator == nil) {
        self.requestOperator = [[CommonRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    NSString* lastupdate = @"0";
    if(self.items != nil && self.items.count > 0)
    {
        GrowDiary* item = (GrowDiary*)[self.items objectAtIndex:0];
        NSInteger time = [item.lastupdate timeIntervalSince1970];
        lastupdate = [NSString stringWithFormat:@"%d",time];
    }
    return [self.requestOperator getGrowDiary:lastupdate];
}
#pragma mark ClassRequestOperatorDelegate
- (void)requestFinish:(id)data requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    switch (type) {
        case CommonRequestOperatorStatus_GetGrowDiary:{
            [self reloadData:YES];
        }break;
        case CommonRequestOperatorStatus_SubmitGrowDiary:{
            [self loadFromServer];
        }break;
        default:
            break;
    }
}
- (void)requestFail:(NSString*)error requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
}
@end
