//
//  ClassMainListViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassBookmarkListViewController.h"
#import "ClassDetailViewController.h"
#import "ClassAlbumnDetailViewController.h"
#import "ClassVideoDetailViewController.h"

#import "ClassCommonDef.h"

@interface ClassBookmarkListViewController () <ClassRequestOperatorDelegate> {
    LoadingView *_loadingView;
}

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation ClassBookmarkListViewController

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
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([ClassDataManager hasEventGetByBookMark])
        [self loadAllEventFromServer];
    else
        [self reloadData:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark － 界面逻辑
- (void)reloadData:(BOOL)isReloadView{
    self.items = [ClassDataManager eventWithBookmark];
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
    titleLabel.text = NSLocalizedString(@"ClassMainListViewNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
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
#pragma mark - 协议请求
- (void)cancel {
    [_loadingView hideLoading:YES];
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
//- (BOOL)loadFromServer {
//    [self cancel];
//    if(!self.requestOperator) {
//        self.requestOperator = [[ClassRequestOperator alloc] init];
//        self.requestOperator.delegate = self;
//    }
//    
//    NSInteger lastUpdate = 0;
//    ClassEvent *item = [ClassDataManager eventLastSynchronize];
//    if(item) {
//        lastUpdate = [item.favourLastUpdate timeIntervalSince1970];
//    }
//    return [self.requestOperator getBookmarkEvent:lastUpdate];
//}
- (BOOL)loadAllEventFromServer{
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    [_loadingView showLoading:self.view animated:YES];
    return [self.requestOperator getEventList:@"0" lastupdate:0 lastReadTime:0];
}
- (BOOL)synchronizeToServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    return [self.requestOperator submitBookmarkEvent:[ClassDataManager eventListWithBookmarkSynchronize]];
}

- (NSString*)getLastUpdatedText {
    NSString *text = nil;
    ClassEvent *item = [ClassDataManager eventLastSynchronize];
    if(item.favourLastUpdate) {
        text = [NSString stringWithFormat:@"%@:%@", CommonRequestLastUpdateTime, [item.favourLastUpdate toString2YMDHM], nil];
    }
    return text;
}
#pragma mark - (协议回调 ClassRequestOperatorDelegate)
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ClassRequestOperator_GetEventList: {
            // 刷新所有通告成功，开始刷新收藏通告
            //[self loadFromServer:NO];
            [self reloadData:YES];
            break;
        }
//        case ClassRequestOperator_GetBookmarkEvent:{
//            // 刷新收藏通告成功，开始同步本地收藏到服务器
//            [self reloadData:YES];
//            [self synchronizeToServer];
//            break;
//        }
        default:break;
    }
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ClassRequestOperator_GetEventList:{
            break;
        }
        case ClassRequestOperator_GetBookmarkEvent:{
            break;
        }
        default:break;
    }
}
@end
