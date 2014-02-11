//
//  ClassSearchListViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassSearchListViewController.h"
#import "ClassDetailViewController.h"
#import "ClassAlbumnDetailViewController.h"
#import "ClassVideoDetailViewController.h"

#import "ClassCommonDef.h"

@interface ClassSearchListViewController () <MITSearchDisplayDelegate, UISearchBarDelegate> {
    LoadingView *_loadingView;
}

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) MITSearchDisplayController *searchController;
@end

@implementation ClassSearchListViewController

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
    self.items = [ClassDataManager eventWithSearchString:self.searchString];
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
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"ClassSearchListNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupSearchBar {
    self.theSearchBar.tintColor = [UIColor colorWithIntRGB:144 green:211 blue:236 alpha:255];
    self.theSearchBar.placeholder = NSLocalizedString(@"InputClassEventTitleTips", nil);
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
    [self.searchController setActive:NO animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // 点击取消
}
#pragma mark - 列表界面回调
- (void)needReloadData:(ClassListTableView *)tableView {
    [self reloadData:NO];
}
- (void)tableView:(ClassListTableView *)tableView didSelectClassEvent:(ClassEvent *)item {
    ClassEventCategory *category = [[item.categories allObjects] lastObject];
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    if([category.type isEqualToString:TYPE_ALBUM]) {
        // TODO: 点击班级相册
        ClassAlbumnDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassAlbumnDetailViewController"];
        vc.item = item;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if ([category.type isEqualToString:TYPE_VIDEO]) {
        // TODO: 点击班级视频
        ClassVideoDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassVideoDetailViewController"];
        vc.item = item;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if([category.type isEqualToString:TYPE_LIST]) {
        // TODO: 点击班级通告
        ClassDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassDetailViewController"];
        vc.item = item;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
}
@end
