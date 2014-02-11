//
//  SchoolSearchListViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SchoolSearchListViewController.h"
#import "SchoolDetailViewController.h"
#import "SchoolAlbumnDetailViewController.h"
#import "SchoolCommonDef.h"

@interface SchoolSearchListViewController () <MITSearchDisplayDelegate, UISearchBarDelegate, SchoolRequestOperatorDelegete> {
    LoadingView *_loadingView;
    UIImageView* _backgroundView;
}

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) MITSearchDisplayController *searchController;
@property (nonatomic, retain) SchoolRequestOperator *requestOperator;
@end

@implementation SchoolSearchListViewController

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
    self.items = [SchoolDataManager newsWithSearchString:self.searchString];
    if(isReloadView) {
        // 改变分隔符线颜色
        if(self.items.count > 0) {
            [self.tipsLabel setHidden:YES];
        }
        else {
            [self.tipsLabel setHidden:NO];
        }
        self.tableView.items = self.items;
        self.tableView.hasMore = NO;
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
    self.theSearchBar.placeholder = NSLocalizedString(@"InputSchoolNewsTitleTips", nil);
    if (!self.searchController) {
        self.searchController = [[MITSearchDisplayController alloc] initWithSearchBar:self.theSearchBar contentsController:self];
        self.searchController.delegate = self;
        self.searchController.searchResultsTableView = nil;
    }
    
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
#pragma mark - 列表界面回调
- (void)needReloadData:(SchoolListTableView *)tableView {
    [self reloadData:NO];
}
- (void)tableView:(SchoolListTableView *)tableView didSelectSchoolNews:(SchoolNews *)item {
    SchoolNewsCategory *category = [[item.categories allObjects] lastObject];
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    if([category.type isEqualToString:TYPE_ALBUM]) {
        // TODO: 点击校园相册
        SchoolAlbumnDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolAlbumnDetailViewController"];
        vc.item = item;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if([category.type isEqualToString:TYPE_LIST]) {
        // TODO: 点击校园新闻
        SchoolDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolDetailViewController"];
        vc.item = item;
        [nvc pushViewController:vc animated:YES gesture:NO];
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
        self.requestOperator = [[SchoolRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    return [self.requestOperator searchNews:self.searchString start:0];
}
#pragma mark - SchoolRequestOperatorDelegete

- (void)operateFinish:(id)data requestType:(SchoolRequestOperatorStatus)type {
    [self cancel];
    [self reloadData:YES];
    [self.searchController hideSearchOverlayAnimated:YES];
}
- (void)operateFail:(NSString*)error requestType:(SchoolRequestOperatorStatus)type {
    [self cancel];
    [self.searchController hideSearchOverlayAnimated:YES];
}
@end
