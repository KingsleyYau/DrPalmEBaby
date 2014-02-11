//
//  SchoolBookmarkListViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SchoolBookmarkListViewController.h"
#import "SchoolDetailViewController.h"
#import "SchoolAlbumnDetailViewController.h"

#import "SchoolCommonDef.h"

@interface SchoolBookmarkListViewController () {
    LoadingView *_loadingView;
}

@property (nonatomic, retain) NSArray *items;
@end

@implementation SchoolBookmarkListViewController

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
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark － 界面逻辑
- (void)reloadData:(BOOL)isReloadView{
    self.items = [SchoolDataManager newsWithBookmark];
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
    titleLabel.text = NSLocalizedString(@"SchoolBookmarkListNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
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
@end
