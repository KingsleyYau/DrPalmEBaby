//
//  ClassCommentManListViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassCommentManListViewController.h"
#import "ClassCommentSentDetailViewController.h"
#import "ClassCommonDef.h"
#import "ClassCommentManCell.h"

@interface ClassCommentManListViewController () <RequestImageViewDelegate> {
    LoadingView *_loadingView;
}

@property (nonatomic, retain) NSArray *itemArray;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation ClassCommentManListViewController

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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark － 界面逻辑
- (void)reloadData:(BOOL)isReloadView {
    self.itemArray = [ClassDataManager anwserListWithEventSentId:self.item.event_id];
    if(isReloadView) {
        // 改变分隔符线颜色
        if(self.itemArray.count > 0) {
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
    titleLabel.text = NSLocalizedString(@"ClassCommentManListNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
#pragma mark - 列表界面回调
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    count = self.itemArray.count;
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [ClassCommentManCell cellHeight];
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if(indexPath.row < self.itemArray.count) {
        ClassCommentManCell *cell = [ClassCommentManCell getUITableViewCell:tableView];
        result = cell;
        
        ClassAnwserMan *item = [self.itemArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.awsermanName;
        cell.timeLabel.text = [item.lastawsTime toStringToday];
        
        // 有新回复显示图标
        if([ClassDataManager hasAnwserWithAnwserManIdEventSentId:item.anwserMan_id eventSentId:self.item.event_id]) {
            cell.noticeImageView.hidden = NO;
        }
        else {
            cell.noticeImageView.hidden = YES;
        }
        
        cell.requestImageView.delegate = self;
        [cell.requestImageView loadImage];
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    // TODO: 点击反馈人
    ClassCommentSentDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassCommentSentDetailViewController"];
    vc.item = self.item;
    vc.classAnwserMan = [self.itemArray objectAtIndex:indexPath.row];
    [nvc pushViewController:vc animated:YES gesture:YES];
}
#pragma mark - 异步下载图片控件回调
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    ClassFile *file = [ClassDataManager fileWithUrl:imageView.imageUrl isLocal:NO];
    if(file) {
        file.data = imageView.imageData;
        file.contenttype = imageView.contentType;
        [CoreDataManager saveData];
        [self reloadData:NO];
    }
}
- (UIImage *)imageForDefault:(RequestImageView *)imageView {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ClassCommentHeadDefaultImage ofType:@"png"]];
    return image;
}
@end
