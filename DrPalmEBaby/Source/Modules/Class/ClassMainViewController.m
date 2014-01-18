//
//  SchoolMainViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-15.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//
#import "ClassMainViewController.h"
#import "MainTabBarController.h"

#import "ClassCategoryTitleCell.h"
#import "ClassNewEventTitleCell.h"

#import "ClassBookmarkListViewController.h"
#import "ClassSearchListViewController.h"

#import "LatestClassEventViewController.h"
#import "ClassAlbumListViewController.h"
#import "ClassMainListViewController.h"
#import "ClassVideoListViewController.h"
#import "CommunicateListViewController.h"

#import "ClassNewEventViewController.h"
#import "ClassSentListViewController.h"
#import "ClassDraftViewController.h"
#import "SystemMessageListViewController.h"

#import "ClassCommonDef.h"
#import "CommonRequestOperator.h"

typedef enum {
    RowTypeCategoryTitle,
    RowTypeCategory,
    RowTypeNewEventTitle,
    RowTypeNewEvent,
} RowType;

@interface ClassMainViewController () <CommonRequestOperatorDelegate>
@property (nonatomic, retain) NSArray *categoryArray;
@property (nonatomic, strong) NSArray *tableViewArray;
@property (nonatomic, strong) CommonRequestOperator *requestOperator;
@end

@implementation ClassMainViewController

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
//    [self setupGridView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadIconGrid];
    [self reloadIconGrid2];
    [self reloadData:YES];
    //[self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.needGetUnreadCount) {
        // 需要立即拿未读条数
        [self loadCategoryFromServer];
    }
    else {
        NSDate* lastupdate = [LastUpdateDataManager getLastUpdateWithCategory:Category_ClassMain hasUser:YES];
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (IBAction)searchAction:(id)sender {
    // TODO: 点击搜索班级通告
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassSearchListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassSearchListViewController"];
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)bookmarkAction:(id)sender {
    // TODO: 点击收藏班级通告
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassBookmarkListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassBookmarkListViewController"];
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)latestAction:(id)sender {
    // TODO:最新通告
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    LatestClassEventViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"LatestClassEventViewController"];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (void)iconGridButtonAction:(id)sender {
    BadgeButton *aButton = sender;
    ClassEventCategory *category = [self.categoryArray objectAtIndex:aButton.tag];
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    if([category.type isEqualToString:TYPE_ALBUM]) {
        // TODO: 点击班级相册
        ClassAlbumListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassAlbumListViewController"];
        vc.category = category;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if ([category.type isEqualToString:TYPE_VIDEO]) {
        // TODO: 点击班级视频
        ClassVideoListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassVideoListViewController"];
        vc.category = category;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if([category.type isEqualToString:TYPE_LIST]) {
        // TODO: 点击通告列表
        ClassMainListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassMainListViewController"];
        vc.category = category;
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
}
- (void)moduleFace2FaceAction:(id)sender {
    // TODO: 点击家园桥
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    CommunicateListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"CommunicateListViewController"];
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)moduleInAndOutAction:(id)sender {
    // TODO: 点击入院离院
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"UnRegisteModule", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil, nil];
    [alert show];
}
- (IBAction)newEventAction:(id)sender {
    // TODO:点击新建通告
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassNewEventViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassNewEventViewController"];
    [nvc pushViewController:vc animated:YES gesture:NO];
}
- (IBAction)moduleSystemMessageAction:(id)sender {
    // TODO: 点击系统信息
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    SystemMessageListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SystemMessageListViewController"];
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)moduleSentEventAction:(id)sender {
    // TODO: 点击已发通告
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassSentListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassSentListViewController"];
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)moduleDraftAction:(id)sender {
    // TODO: 点击草稿
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassDraftViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassDraftViewController"];
    [nvc pushViewController:vc animated:YES gesture:YES];
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
    if(!self.iconGridView) {
        self.iconGridView = [[IconGrid alloc] initWithFrame:CGRectZero];
        self.iconGridView.delegate = self;
        self.iconGridView.backgroundColor = [UIColor clearColor];
        [self.iconGridView setHorizontalMargin:5.0 vertical:10.0];
        [self.iconGridView setHorizontalPadding:5.0 vertical:10.0];
        [self.iconGridView setMinimumColumns:3 maximum:3];
    }
    self.iconGridView.frame = CGRectMake(20, 0, self.tableView.frame.size.width - 40, 0);
}
- (void)setupGridView2 {
    if(!self.iconGridView2) {
        self.iconGridView2 = [[IconGrid alloc] initWithFrame:CGRectZero];
        self.iconGridView2.delegate = self;
        self.iconGridView2.backgroundColor = [UIColor clearColor];
        [self.iconGridView2 setHorizontalMargin:5.0 vertical:10.0];
        [self.iconGridView2 setHorizontalPadding:5.0 vertical:10.0];
        [self.iconGridView2 setMinimumColumns:3 maximum:3];
    }
    self.iconGridView2.frame = CGRectMake(20, 0, self.tableView.frame.size.width - 40, 0);
}
- (void)reloadIconGrid {
    UIFont *font = [UIFont boldSystemFontOfSize:11];
    NSMutableArray *buttons = [NSMutableArray array];
    NSInteger viewHeight = 64;
    NSInteger viewWidth = 64;
    NSInteger totalUnReadCount = 0;
    
    UIImage *image = nil;
    UILabel *titleLabel = nil;
    BadgeButton *aButton = nil;
    
    self.categoryArray = [ClassDataManager categoryList];
    for(int i = 0; i<self.categoryArray.count; i++) {
        ClassEventCategory *category = [self.categoryArray objectAtIndex:i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        NSString *buttonTitle = NSLocalizedString(category.title, nil);
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49 + 3, viewWidth, 12)];
        [view addSubview:titleLabel];
        titleLabel.text = buttonTitle;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = font;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        aButton = [BadgeButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:aButton];
        aButton.contentMode = UIViewContentModeScaleAspectFit;
        
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:category.logoImage.path ofType:@"png"]];
        [aButton setImage:image forState:UIControlStateNormal];
        aButton.frame = CGRectMake(8, 0, 49, 49);
        aButton.tag = i;
        [aButton addTarget:self action:@selector(iconGridButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        int unreadcount = [category.unreadcount intValue];
        totalUnReadCount += unreadcount;
        if(unreadcount>0) {
            [aButton setBadgeValue:[NSString stringWithFormat:@"%d",unreadcount]];
        }
        
        [buttons addObject:view];
    }
    
    // TODO: 重置tabbar未读数字
    [ClassDataManager setUnReadCount:totalUnReadCount];
    [self reloadTabbarItem];
    
    ClassEventCategory *category = [ClassDataManager categaoryWithId:FACE2FACEMOUDLE];
    if([category.bShow boolValue]) {
        //交流模块
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        NSString *buttonTitle = NSLocalizedString(@"CommunicateModule", nil);
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49 + 3, viewWidth, 12)];
        [view addSubview:titleLabel];
        titleLabel.text = buttonTitle;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:10];
        titleLabel.lineBreakMode = NSLineBreakByClipping;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        BadgeButton *aButton = [BadgeButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:aButton];
        aButton.contentMode = UIViewContentModeScaleAspectFit;
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:category.logoImage.path ofType:@"png"]];
        [aButton setImage:image forState:UIControlStateNormal];
        aButton.frame = CGRectMake(8, 0, 49, 49);
        [aButton addTarget:self action:@selector(moduleFace2FaceAction:) forControlEvents:UIControlEventTouchUpInside];
        // 未读条数
        NSInteger unReadCount = [category.unreadcount intValue];
        if(unReadCount > 0) {
            [aButton setBadgeValue:[NSString stringWithFormat:@"%d", unReadCount]];
        }
        [buttons addObject:view];
    }
    
    //入园离园
    category = [ClassDataManager categaoryWithId:INANDOUTMODULE];
    if([category.bShow boolValue]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        NSString *buttonTitle = NSLocalizedString(@"InAndOutModule", nil);
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49 + 3, viewWidth, 12)];
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
        [aButton addTarget:self action:@selector(moduleInAndOutAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:view];
    }
    
    // TODO: 重置九宫格
    [self setupGridView];
    self.iconGridView.icons = buttons;
    [self.iconGridView setNeedsLayout];
}
- (void)reloadIconGrid2 {
    // TODO: 加载本地功能(已发通告\草稿\系统信息)
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    NSMutableArray *buttons = [NSMutableArray array];
    NSInteger viewHeight = 64;
    NSInteger viewWidth = 64;
    
    UIView *view = nil;
    UIImage *image = nil;
    UILabel *titleLabel = nil;
    BadgeButton *aButton = nil;
    
    ClassEventCategory *category = [ClassDataManager categaoryWithId:SENTEVENTMODULE];
    if([category.bShow boolValue]) {
        // 已发通告
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        NSString *buttonTitle = NSLocalizedString(@"ClassCategorySendTitle", nil) ;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49 + 3, viewWidth, 12)];
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
        [aButton addTarget:self action:@selector(moduleSentEventAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:view];
    }
    
    // 草稿
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49 + 3, viewWidth, 12)];
    [view addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = font;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = NSLocalizedString(@"ClassCategoryDraftTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    
    aButton = [BadgeButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:aButton];
    aButton.frame = CGRectMake(8, 0, 49, 49);
    aButton.contentMode = UIViewContentModeScaleAspectFill;
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ClassDraftEventImage ofType:@"png"]];
    [aButton setImage:image forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(moduleDraftAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:view];
    
    category = [ClassDataManager categaoryWithId:SYSMSGMODULE];
    if([category.bShow boolValue]) {
        // 系统消息
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        NSString *buttonTitle = NSLocalizedString(@"ClassCategorySysinfoTitle", nil);
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49 + 3, viewWidth, 12)];
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
        [aButton addTarget:self action:@selector(moduleSystemMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:view];
    }
    
    // 重置九宫格2
    [self setupGridView2];
    self.iconGridView2.icons = buttons;
    [self.iconGridView2 setNeedsLayout];
}
- (void)reloadTabbarItem {
    KKTabBarItem *item = (KKTabBarItem *)self.tabBarItem;
    item.badgeNum = [ClassDataManager getUnReadCount];
    [UIApplication sharedApplication].applicationIconBadgeNumber = item.badgeNum;
}
- (void)reloadData:(BOOL)isReloadView {
    // 主tableView
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    // 分类标题栏，搜索和收藏
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [ClassCategoryTitleCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeCategoryTitle] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 通告分类九宫格
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, self.iconGridView.frame.size.height);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeCategory] forKey:ROW_TYPE];
    [array addObject:dictionary];

    if(LoginManagerInstance().userType == UserTypeTeacher) {
        // 教师登陆
        // 新建通告标题栏
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [ClassNewEventTitleCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeNewEventTitle] forKey:ROW_TYPE];
        [array addObject:dictionary];
        
        // 本地功能(已发通告\草稿\系统信息)
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, self.iconGridView2.frame.size.height);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeNewEvent] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }

    self.tableViewArray = array;
    
    if(isReloadView) {
        [self.tableView reloadData];
    }
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 0;
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        count = 1;
    }
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        number = self.tableViewArray.count;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        NSDictionary *dictionarry = [self.tableViewArray objectAtIndex:indexPath.row];
        CGSize viewSize;
        NSValue *value = [dictionarry valueForKey:ROW_SIZE];
        [value getValue:&viewSize];
        height = viewSize.height;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        NSDictionary *dictionarry = [self.tableViewArray objectAtIndex:indexPath.row];
        
        // TODO:大小
        CGSize viewSize;
        NSValue *value = [dictionarry valueForKey:ROW_SIZE];
        [value getValue:&viewSize];
        
        // TODO:类型
        RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
        switch (type) {
            case RowTypeCategoryTitle:{
                // 分类标题栏，搜索和收藏
                ClassCategoryTitleCell *cell = [ClassCategoryTitleCell getUITableViewCell:tableView];
                result = cell;
                [cell.button addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.button2 addTarget:self action:@selector(bookmarkAction:) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            case RowTypeCategory:{
                // 通告分类九宫格
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RowTypeCategory"];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RowTypeCategory"];
                    cell.backgroundColor = [UIColor clearColor];
                    [self.iconGridView removeFromSuperview];
                    [cell addSubview:self.iconGridView];
                }
                result = cell;
                break;
            }
            case RowTypeNewEventTitle:{
                ClassNewEventTitleCell *cell = [ClassNewEventTitleCell getUITableViewCell:tableView];
                result = cell;
                
                [cell.button addTarget:self action:@selector(newEventAction:) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            case RowTypeNewEvent:{
                // 本地功能(已发通告\草稿\系统信息)
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RowTypeNewEvent"];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RowTypeNewEvent"];
                    cell.backgroundColor = [UIColor clearColor];
                    [self.iconGridView2 removeFromSuperview];
                    [cell addSubview:self.iconGridView2];
                }
                result = cell;
                break;
            }
            default:break;
        }
    }
    return result;
}
- (void)iconGridFrameDidChange:(IconGrid *)iconGrid {
    [self reloadData:YES];
}
#pragma mark - 协议请求
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)loadCategoryFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[CommonRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    return [self.requestOperator getLastUpdate];
}
#pragma mark - 协议回调 (CommonRequestOperatorDelegate)
-(void)requestFinish:(id)data requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case CommonRequestOperatorStatus_GetLastUpdate: {
            [LastUpdateDataManager updateLastUpdateWithCategory:Category_ClassMain lastupdate:[NSDate date] hasUser:YES];
            self.needGetUnreadCount = NO;
            MainTabBarController *tvc = (MainTabBarController *)self.tabBarController;
            [tvc updateViewControllers];
            [self reloadIconGrid];
            [self reloadData:YES];
        }break;
        default:break;
    }
}
-(void)requestFail:(NSString*)error requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case CommonRequestOperatorStatus_GetLastUpdate:{
            //[self setTopStatusText:CommonUpdateFailed];
        }break;
        default:break;
    }
}
@end
