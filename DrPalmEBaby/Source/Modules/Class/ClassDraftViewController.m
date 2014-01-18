//
//  ClassDraftViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassDraftViewController.h"
#import "ClassNewEventViewController.h"
#import "ClassCommonDef.h"

#import "DraftTableViewCell.h"

@interface ClassDraftViewController () {
    NSInteger _delRow;
}

@property (nonatomic, retain) NSArray *items;
@end

@implementation ClassDraftViewController

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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark － 界面逻辑
- (IBAction)deleteAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    _delRow = button.tag;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"EnsureDeleteDraft", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Delete", nil), nil];
    [alert show];
}
- (void)reloadData:(BOOL)isReloadView{
    self.items = [ClassDataManager getEventDrafts];
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
    titleLabel.text = NSLocalizedString(@"ClassCategoryDraftTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
#pragma mark － 界面逻辑
- (NSString*)getLastUpdatedText {
    // TODO:最后更新时间
    NSString *text = nil;
//    if(self.category.lastUpdated && self.category.expectedCount) {
//        text = [NSString stringWithFormat:@"%@:%@", CommonLastUpdateTime, [self.category.lastUpdated toString2YMDHM], nil];
//    }
    return text;
}
#pragma mark - 列表界面回调
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 1;
    return count;
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
        
        ClassEventDraft* item = [self.items objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.title;
        cell.timeLabel.text = [item.lastUpdated toStringYMD];
        
        cell.button.tag = indexPath.row;
        [cell.button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.items count]) {
        UIStoryboard *storyBoard = AppDelegate().storyBoard;
        KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
        ClassNewEventViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassNewEventViewController"];
        ClassEventDraft *item = [self.items objectAtIndex:indexPath.row];
        vc.eventDraft = item;
        [nvc pushViewController:vc animated:YES gesture:NO];
        
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 != buttonIndex){
        ClassEventDraft *item = [self.items objectAtIndex:_delRow];
        if(item != nil)
        {
            [ClassDataManager removeEventDraft:item];
            [self reloadData:YES];
        }
    }
    
}
@end
