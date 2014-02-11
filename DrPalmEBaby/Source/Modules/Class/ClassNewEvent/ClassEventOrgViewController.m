//
//  ClassEventOrgViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-6.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassEventOrgViewController.h"
#import "ClassOrgTableViewCell.h"

#import "ClassCreateOrgHandler.h"
#import "ClassEventOrgTVHandler.h"
#import "ClassCommonDef.h"

@interface ClassEventOrgViewController () <ClassCreateOrgHandlerDelegate, UICheckBoxDelegate> {
    BOOL  _getOrgInfoSuccess;
}
@property (nonatomic, retain) LoadingView *loadingView;
@property (nonatomic, retain) ClassCreateOrgHandler *createOrgHandler;
@property (nonatomic, retain) NSArray *orgs;
@property (nonatomic, retain) NSMutableArray *checkedOrgs;
@end

@implementation ClassEventOrgViewController

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
    // 加载loading界面
    self.loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.backgroundView = nil;
    self.tableView.hidden = YES;
    
    [self.cbAllSelected.label setText:NSLocalizedString(@"ClassPickAll", nil)];
    [self.cbSendtoSelf setChecked:NO];
    [self.cbSendtoSelf.label setText:NSLocalizedString(@"ClassPickSelf", nil)];
    [self.cbSendtoSelf setChecked:NO];
    
    [self refreshOrgsWithDB];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshOrgsWithDB];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (LoginStatus_online == LoginManagerInstance().loginStatus
        && [self.parentOrgID isEqualToString:OrgTopDefaultValue]
        && !_getOrgInfoSuccess)
    {
        _createOrgHandler = [[ClassCreateOrgHandler alloc] init];
        self.createOrgHandler.delegate = self;
        [self.createOrgHandler start];
    }
    self.tableView.hidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (IBAction)allSeceletedChanged:(id)sender {
    // TODO:全选
    if(_cbAllSelected.isChecked)
    {
        for(ClassOrg *eventOrg in self.orgs) {
            [ClassEventOrgTVHandler addToArray:_checkedOrgs eventOrg:eventOrg];
        }
    }
    else{
        for(ClassOrg *eventOrg in self.orgs) {
            [ClassEventOrgTVHandler removeToArray:_checkedOrgs eventOrg:eventOrg];
        }
    }
    [self reloadData];
}
- (IBAction)send2SelfChanged:(id)sender {
    // TODO:发给自己
    ClassOrg *selfOrg = [ClassDataManager orgWithID:self.selfOrgId];
    
    switch ([ClassEventOrgTVHandler cellStatusWithEventOrg:_checkedOrgs eventOrg:selfOrg]) {
        case NoChecked:
            [ClassEventOrgTVHandler addToArray:_checkedOrgs eventOrg:selfOrg];
            break;
        case Checked:
            [ClassEventOrgTVHandler removeToArray:_checkedOrgs eventOrg:selfOrg];
            break;
        case SubsChecked:
            break;
    }
    [self reloadData];
}
- (IBAction)cancelAction:(id)sender {
    // TODO:取消并返回新建通告列表
    [self.navigationController popToViewController:_rootVC animated:YES];
}
- (IBAction)saveAction:(id)sender {
    // TODO:保存并返回新建通告列表
    // must notice the newEventUI to reflash address first
    if(self.delegate) {
        NSMutableArray* combinedOrgs = [NSMutableArray array];
        [ClassEventOrgTVHandler combineSubOrg:self.checkedOrgs desCheckedOrgs:combinedOrgs];
        [self.delegate eventOrgConfirm:combinedOrgs];
    }
    // back to the newEventUI
    [self.navigationController popToViewController:_rootVC animated:YES];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"ClassEventOrgNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *barButtonItem = nil;
    UIButton *button = nil;
    UIImage *image = nil;
    
    // TODO:右边按钮
    NSMutableArray *array = [NSMutableArray array];
    
    // 保存按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlue ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlueC ofType:@"png"]];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    // 取消按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlue ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlueC ofType:@"png"]];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.rightBarButtonItems = array;
}
- (void)refreshOrgsWithDB {
    if ([self.parentOrgID isEqualToString:OrgTopDefaultValue]) {
        self.orgs = [ClassDataManager topLevelOrgs];
    }
    else {
        self.orgs = [ClassDataManager suborgsWithParentOrgID:_parentOrgID];
    }
    [self reloadData];
}
- (void)reloadData {
    if([ClassEventOrgTVHandler isAllOrgChecked:self.orgs checkedArray:_checkedOrgs]) {
        // 已经全选
        [_cbAllSelected setChecked:YES];
    }else
        [_cbAllSelected setChecked:NO];
    
    ClassOrg *selforg = [ClassDataManager orgWithID:self.selfOrgId ];
    
    switch ([ClassEventOrgTVHandler cellStatusWithEventOrg:_checkedOrgs eventOrg:selforg]) {
        case NoChecked:
            [_cbSendtoSelf setChecked:NO];
            break;
        case SubsChecked:
            break;
        case Checked:
            [_cbSendtoSelf setChecked:YES];
            break;
    }
    [self.tableView reloadData];
}
#pragma mark - 初始化函数
- (void)initCheckedOrgs:(NSArray*)checkOrgs
{
    self.checkedOrgs = [NSMutableArray array];
    
    // 把叶子节点加到已选节点表
    for (ClassOrg* org in checkOrgs) {
        [ClassEventOrgTVHandler addToArray:self.checkedOrgs eventOrg:org];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orgs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if(indexPath.row < self.orgs.count) {
        ClassOrgTableViewCell *cell = [ClassOrgTableViewCell getUITableViewCell:tableView];
        result = cell;
        
        ClassOrg *eventOrg = [self.orgs objectAtIndex:indexPath.row];
        cell.titleLabel.text = eventOrg.orgName;
        
        if([GetOrgInfo_OrgMemberType isEqualToString:eventOrg.orgType]) {
            // 叶子不显示下层箭头
            cell.accessoryView.hidden = YES;
        }
        else {
            cell.accessoryView.hidden = NO;
        }
        cell.button.tag = indexPath.row;
        [cell.button addTarget:self action:@selector(clickCellButton:) forControlEvents:UIControlEventTouchUpInside];
        
        OrgCellStatus status = [ClassEventOrgTVHandler cellStatusWithEventOrg:_checkedOrgs eventOrg:eventOrg];
        UIImage *image = nil;
        switch (status) {
            case NoChecked: {
                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CheckButtonUnChecked ofType:@"png"]];
            }break;
            case SubsChecked:{
                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CheckButtonSubChecked ofType:@"png"]];
            }break;
            case Checked:{
                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CheckButtonChecked ofType:@"png"]];
            }break;
            default:
                break;
        }
        [cell.button setImage:image forState:UIControlStateNormal];
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClassOrg *eventOrg = [self.orgs objectAtIndex:indexPath.row];
    if ([GetOrgInfo_OrgMemberType isEqualToString:eventOrg.orgType]) {
        return;
    }
    
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassEventOrgViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassEventOrgViewController"];
    vc.rootVC = self.rootVC;
    vc.delegate = self.delegate;
    vc.checkedOrgs = self.checkedOrgs;
    vc.parentOrgID = [eventOrg orgID];
    vc.selfOrgId = self.selfOrgId;
    [nvc pushViewController:vc animated:YES gesture:NO];
}
- (IBAction)clickCellButton:(id)sender
{
    UIButton *button = (UIButton*)sender;
    ClassOrg *eventOrg = [self.orgs objectAtIndex:button.tag ];
    
    switch ([ClassEventOrgTVHandler cellStatusWithEventOrg:_checkedOrgs eventOrg:eventOrg]) {
        case NoChecked:
            [ClassEventOrgTVHandler addToArray:_checkedOrgs eventOrg:eventOrg];
            break;
        case SubsChecked:
            [ClassEventOrgTVHandler addToArray:_checkedOrgs eventOrg:eventOrg];
            break;
        case Checked:
            [ClassEventOrgTVHandler removeToArray:_checkedOrgs eventOrg:eventOrg];
            break;
    }
    [self reloadData];
}
#pragma mark - ClassCreateOrgHandler
// 开始请求组织架构
- (void)startRequest:(ClassCreateOrgHandler*)handler
{
    //[self.loadingView showLoading:self.view animated:YES];
}
// 构建组织构架完成
- (void)createOrgFinish:(ClassCreateOrgHandler*)handler
{
    _getOrgInfoSuccess = YES;
    self.selfOrgId = handler.selfOrgId;
    [self refreshOrgsWithDB];
    //    [self.loadingView hideLoading:YES];
}
// 构建组织构架失败
- (void)createOrgFail:(ClassCreateOrgHandler*)handler error:(NSString*)error
{
    [self.loadingView hideLoading:YES];
}
// 开始下载组织架构
- (void)downloadStart:(ClassCreateOrgHandler*)handler
{
    [self.loadingView showLoading:self.view animated:YES];
}
// 正在下载组织架构
- (void)downloadProcess:(ClassCreateOrgHandler*)handler processed:(NSInteger)processed total:(NSInteger)total
{
    
}
// 下载完成
- (void)downloadFinish:(ClassCreateOrgHandler*)handler
{
    [self.loadingView hideLoading:YES];
}

// 下载失败
- (void)downloadFail:(ClassCreateOrgHandler*)handler error:(NSError*)error
{
    [self.loadingView hideLoading:YES];
}
- (void)checkBoxChange:(UICheckBox *)checkBox checked:(BOOL)checked {
    if(self.cbAllSelected ==  checkBox) {
        [self allSeceletedChanged:self.cbAllSelected];
    }
    else if(self.cbSendtoSelf == checkBox) {
        [self send2SelfChanged:self.cbSendtoSelf];
    }
}
@end
