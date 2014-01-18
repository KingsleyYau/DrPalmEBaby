//
//  SchoolMainViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-15.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//
#import "SchoolMainViewController.h"
#import "MainTabBarController.h"

#import "SchoolSearchListViewController.h"
#import "SchoolBookmarkListViewController.h"

#import "DrPalmToursHomeController.h"
#import "SchoolMainListViewController.h"
#import "SchoolAlbumListViewController.h"
#import "LatestSchoolNewsViewController.h"
#import "PutConsultViewController.h"

#import "SchoolCommonDef.h"
#import "CommonRequestOperator.h"

@interface SchoolMainViewController () <CommonRequestOperatorDelegate>
@property (nonatomic, retain) NSArray *categoryArray;
@property (nonatomic, retain) CommonRequestOperator *requestOperator;
@end

@implementation SchoolMainViewController

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
    UIImage *image = [UIImage imageWithContentsOfFileLanguage:[[NSBundle mainBundle] pathForResource:SchoolCategoryTitleImage ofType:@"png"] ofType:@"png"];
    [self.titleImageView setImage:image];
    //[self.mailButton setTitle:NSLocalizedString(@"SchoolPrincipalMailbox", nil) forState:UIControlStateNormal];
    self.mailLabel.text = NSLocalizedString(@"SchoolPrincipalMailbox", nil);
    [self setupGridView];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDate* lastupdate = [LastUpdateDataManager getLastUpdateWithCategory:Category_SchoolMain hasUser:NO];
    if(lastupdate != nil)
    {
        if([[NSDate date]timeIntervalSinceDate:lastupdate] > UPDATETIMEINTEVAL)
        {
            [self loadCategoryFromServer];
        }
    }
    else
        [self loadCategoryFromServer];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (IBAction)searchAction:(id)sender {
    // TODO:搜索新闻
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    SchoolSearchListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolSearchListViewController"];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)bookmarkAction:(id)sender {
    // TODO:收藏新闻
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    SchoolBookmarkListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolBookmarkListViewController"];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)mailAction:(id)sender {
    return;
    // 院长信箱
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    PutConsultViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"PutConsultViewController"];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)latestAction:(id)sender {
    // TODO:最新新闻
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    LatestSchoolNewsViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"LatestSchoolNewsViewController"];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (void)toursAction:(id)sender {
    // TODO:校园简介
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    DrPalmToursHomeController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"DrPalmToursHomeController"];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:NO];
}
- (void)iconGridButtonAction:(id)sender {
    BadgeButton *aButton = sender;
    SchoolNewsCategory *category = [self.categoryArray objectAtIndex:aButton.tag];
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    if([category.type isEqualToString:TYPE_ALBUM]) {
        // 相册
        SchoolAlbumListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolAlbumListViewController"];
        vc.category = category;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if([category.type isEqualToString:TYPE_LIST]) {
        // 列表
        SchoolMainListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolMainListViewController"];
        vc.category = category;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    UIBarButtonItem *barButtonItem = nil;
    UIButton *button = nil;
    UIImage *image = nil;
    
    // TODO:右边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 最新按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlue ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"Latest", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [button addTarget:self action:@selector(latestAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlueC ofType:@"png"]];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.rightBarButtonItems = array;
}
- (void)setupGridView {
    [self.iconGridView setHorizontalMargin:5.0 vertical:10.0];
    [self.iconGridView setHorizontalPadding:5.0 vertical:10.0];
    [self.iconGridView setMinimumColumns:3 maximum:3];
}
- (void)reloadData:(BOOL)isReloadView {
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    NSMutableArray *buttons = [NSMutableArray array];
    NSInteger viewHeight = 64;
    NSInteger viewWidth = 64;
    
    UIImage *image = nil;
    UILabel *titleLabel = nil;
    BadgeButton *aButton = nil;
    
    //Tours模块
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    NSString *buttonTitle = NSLocalizedString(@"SchoolToursModule", nil);
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49 + 3, 64, 12)];
    [view addSubview:titleLabel];
    titleLabel.text = buttonTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = font;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    aButton = [BadgeButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:aButton];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:SchoolModuleTours ofType:@"png"]];
    [aButton setImage:image forState:UIControlStateNormal];
    
    aButton.frame = CGRectMake(8, 0, 49, 49);
    [aButton addTarget:self action:@selector(toursAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:view];
    
    self.categoryArray = [SchoolDataManager categoryList];
    for(int i = 0; i<self.categoryArray.count; i++) {
        SchoolNewsCategory *category = [self.categoryArray objectAtIndex:i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        NSString *buttonTitle = NSLocalizedString(category.title, nil);
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49 + 3, 64, 12)];
        [view addSubview:titleLabel];
        titleLabel.text = buttonTitle;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = font;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        BadgeButton *aButton = [BadgeButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:aButton];
        aButton.contentMode = UIViewContentModeScaleAspectFit;

        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:category.logoImage.path ofType:@"png"]];
        [aButton setImage:image forState:UIControlStateNormal];
        aButton.frame = CGRectMake(8, 0, 49, 49);
        aButton.tag = i;
        [aButton addTarget:self action:@selector(iconGridButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 分类最后更新时间比本地最后一条item更新时间迟
        if(![category.lastUpdateChannel isEqualToDate:category.lastUpdateChannelList]) {
            if([category.lastUpdateChannel isEqualToDate:[category.lastUpdateChannel laterDate:category.lastUpdateChannelList]] && [category.lastUpdateChannel timeIntervalSince1970] > 0) {
                [aButton setBadgeValue:NSLocalizedString(@"New", nil)];
            }
        }
        [buttons addObject:view];
    }
    
    if(isReloadView) {
        self.iconGridView.icons = buttons;
        [self.iconGridView setNeedsLayout];
    }
}
#pragma mark - 协议请求
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (void)loadCategoryFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[CommonRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    [self.requestOperator getLastUpdate];
}
#pragma mark - 协议回调 (CommonRequestOperatorDelegate)
-(void)requestFinish:(id)data requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case CommonRequestOperatorStatus_GetLastUpdate: {
            [self reloadData:YES];
            [LastUpdateDataManager updateLastUpdateWithCategory:Category_SchoolMain lastupdate:[NSDate date] hasUser:YES];
            MainTabBarController *tvc = (MainTabBarController *)self.tabBarController;
            [tvc updateViewControllers];
        }break;
        default:break;
    }
}
-(void)requestFail:(NSString*)error requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case CommonRequestOperatorStatus_GetLastUpdate:{
        }break;
        default:break;
    }
}
@end
