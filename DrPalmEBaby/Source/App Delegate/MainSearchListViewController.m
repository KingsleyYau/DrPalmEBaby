//
//  MainSearchListViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "MainSearchListViewController.h"
#import "MainListTableViewCell.h"
#import "MainTabBarController.h"

#import "LocalAreaRequest.h"
#import "LocalAreaDataManager.h"

#import "SchoolDataManager.h"
#import "ClassDataManager.h"

@interface MainSearchListViewController () <MITSearchDisplayDelegate, UISearchBarDelegate, LocalAreaRequestOperatorDelegate> {
    LoadingView *_loadingView;
}

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) MITSearchDisplayController *searchController;
@property (nonatomic, retain) LocalAreaRequest *requestOperator;
@end

@implementation MainSearchListViewController

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
    _loadingView = [[LoadingView alloc] init];
    [self setupSearchBar];
    [self setupTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark － 界面逻辑
- (void)reloadData:(BOOL)isReloadView{
    if(self.searchString.length > 0) {
        self.items = [LocalAreaDataManager areaWithSearchString:self.searchString];
    }
    else {
        self.items = [NSArray array];
    }
    
    if(isReloadView) {
        // 改变分隔符线颜色
        if(self.items.count > 0) {
            [self.tipsLabel setHidden:YES];
        }
        else {
            [self.tipsLabel setHidden:NO];
        }
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
    titleLabel.text = NSLocalizedString(@"SchoolSearchListNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupSearchBar {
    self.theSearchBar.tintColor = [UIColor colorWithIntRGB:144 green:211 blue:236 alpha:255];
    if (!self.searchController) {
        self.searchController = [[MITSearchDisplayController alloc] initWithSearchBar:self.theSearchBar contentsController:self];
        self.searchController.delegate = self;
        self.searchController.searchResultsTableView = nil;
    }
}
- (void)setupTableView {
    self.tableView.backgroundView = nil;
}
#pragma mark - 搜索回调 (Search delegate)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchString = searchBar.text;
    [self reloadData:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 点击搜索
    [self loadFromServer];
    [self.searchController setActive:NO animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // 点击取消
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
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 1;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = self.items.count;
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat number = [MainListTableViewCell cellHeight];
    return number;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if(indexPath.row < self.items.count) {
        // TODO:区域列表
        LocalArea *area = [self.items objectAtIndex:indexPath.row];
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
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row < self.items.count) {
        LocalArea *area = [self.items objectAtIndex:indexPath.row];
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
            
            // 初始化本地分类
            [SchoolDataManager staticCategory];
            [ClassDataManager staticCategory];
            
            // 进入学校
            UIStoryboard *storyBoard = AppDelegate().storyBoard;
            KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
            MainTabBarController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
            
            UIImage *image = nil;
            //image = [UIImage imageWithContentsOfFile:[ResourcePacketManagerInstance() resourceFilePath:NavigationTitleImage]];
            if (!image) {
                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationDefaultTitleImage ofType:@"png"]];
            }
            nvc.customTitleImage = image;
            [nvc pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - 协议请求
- (void)cancel {
    [_loadingView hideLoading:YES];
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[LocalAreaRequest alloc] init];
        self.requestOperator.delegate = self;
    }
    return [self.requestOperator searchSchool:[self.searchString commitString]];
}
#pragma mark - SchoolRequestOperatorDelegete

- (void)operateFinish:(id)data requestType:(LocalAreaRequestStatus)type {
    [self cancel];
    switch (type) {
        case LocalAreaRequestStatus_SearchSchool: {
            [self.searchController hideSearchOverlayAnimated:YES];
            // 非测试版本
//            if(![[[[NSBundle mainBundle] infoDictionary] objectForKey:@"IsTestVersion"] boolValue]) {
//                [LocalAreaDataManager delewithKeyString:DRCOM_TEST_KEY];
//            }
            [self reloadData:YES];
        }break;
        default:
            break;
    }
    
}
- (void)operateFail:(NSString*)error requestType:(LocalAreaRequestStatus)type {
    [self cancel];
    switch (type) {
        case LocalAreaRequestStatus_SearchSchool: {
            [self.searchController hideSearchOverlayAnimated:YES];
            [self reloadData:YES];
            [self setTopStatusText:error];
        }break;
        default:
            break;
    }
}
@end
