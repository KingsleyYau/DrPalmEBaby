//
//  ClassSentVideoDetailViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassSentVideoDetailViewController.h"
#import "ClassCommentManListViewController.h"
#import "ClassReaderViewController.h"
#import "VLCMovieViewController.h"
#import "ClassNewEventViewController.h"

#import "ClassAttachmentDownloader.h"
#import "ClassCommonDef.h"

#define DETAIL_VIEW_MIN_HEIGHT 44

@interface ClassSentVideoDetailViewController () <RequestImageViewDelegate, ClassRequestOperatorDelegate>  {
}
@property (nonatomic, retain) NSArray *itemArray;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation ClassSentVideoDetailViewController

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
    //[self setupPZPagingScrollView];
    [self setupTableView:0];
    [self setupRequestView];
    self.playButton.hidden = YES;
    self.commentButton.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.requestImageView.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupDynamicView];
    [self reloadData:YES];
    [self loadFromServer];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.requestImageView.delegate = nil;
    [self.dynamicContainView hide:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - (界面逻辑)
- (void)reloadData:(BOOL)isReloadView{
    self.item = [ClassDataManager eventSentWithId:self.item.event_id];
    self.itemArray = [ClassDataManager filesWithClassEventSentId:self.item.event_id];
    if(isReloadView) {
        // 加载已读
        NSString *report = [NSString stringWithFormat:@"%@(%@/%@)", NSLocalizedString(@"ReaderStatus", nil), self.item.readCount,self.item.readTotal];
        self.reportLabel.text = report;
        
        if(self.itemArray.count > 0) {
            self.playButton.hidden = NO;
            // TODO:加载预览图片
            ClassFile *file = [self.itemArray objectAtIndex:0];
            self.requestImageView.imageUrl = file.path;
            self.requestImageView.imageData = file.data;
            [self.requestImageView loadImage];
        }

        // TODO:加载描述栏
        self.tableView.item = self.item;
        [self.tableView reloadData];
        [_dynamicContainView reLoadView];
        
        // TODO:加载工具栏
        [self setupKKButtonBar];
    }
}
- (void)pushIntoNewEventVC:(NSString*)oristatus {
    // TODO: 打开新建通告界面
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    
    ClassNewEventViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassNewEventViewController"];
    
    vc.eventCategory = [[self.item.categories allObjects] lastObject];
    vc.eventContent = self.item.body;
    vc.eventTitle = self.item.title;
    vc.eventLocation = self.item.location;
    vc.eventStart = self.item.startDate;
    vc.eventEnd = self.item.endDate;
    vc.eventOriEventID = self.item.event_id;
    vc.eventOriStatus = oristatus;
    vc.isEmergent = [self.item.ifshow boolValue];
    
    // 分析接收者, 若没有就创建
    NSMutableArray *eventOrgs = [NSMutableArray array];
    NSArray *ownersId = [self.item.ownerid componentsSeparatedByString:@","];
    NSArray *ownersName = [self.item.owner componentsSeparatedByString:@","];
    if ([ownersId count] == [ownersName count]){
        for (int i = 0; i < [ownersId count]; i++){
            NSString *ownerId = [ownersId objectAtIndex:i];
            ClassOrg *eventOrg = [ClassDataManager orgWithID:ownerId];
            if ([eventOrg.orgName length] == 0){
                eventOrg.orgName = [ownersName objectAtIndex:i];
            }
            [eventOrgs addObject:eventOrg];
        }
        [CoreDataManager saveData];
    }
    vc.eventAddressees = eventOrgs;
    
    // 附件
    NSMutableArray *attachments = [NSMutableArray array];
    for (ClassFile *attachment in self.item.attachments){
        ClassAttachmentItem *attachmentItem = [[ClassAttachmentItem alloc] init];
        attachmentItem.attid = attachment.attid;
        attachmentItem.url = attachment.path;
        attachmentItem.type = attachment.contenttype;
        attachmentItem.data = attachment.data;
        attachmentItem.desc = attachment.caption;
        [attachments addObject:attachmentItem];
    }
    vc.eventAttachments = attachments;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];

    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"ClassSentDetailNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *barButtonItem = nil;
    UIButton *button = nil;
    UIImage *image = nil;
    
    // TODO:右边按钮
    NSMutableArray *array = [NSMutableArray array];
    
    // 编辑按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationEditButton ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.rightBarButtonItems = array;
}
- (void)setupKKButtonBar {
    UIImage *image = nil;
    
    // 评论
    if([self.item.anwserMans allObjects].count > 0) {
        self.commentButton.hidden = NO;
        if([ClassDataManager hasAnwserWithEventId:self.item.event_id]) {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonDetailCommentNewButton ofType:@"png"]];
        }
        else {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonDetailCommentButton ofType:@"png"]];
        }
        [self.commentButton setImage:image forState:UIControlStateNormal];
    }
    else {
        self.commentButton.hidden = YES;
    }

}
- (void)setupDynamicView {
    [self.dynamicContainView initialize];
    self.dynamicContainView.isDown = NO;
}
- (void)setupRequestView {
    self.requestImageView.contentMode = UIViewContentModeScaleAspectFit;
}
- (void)setupTableView:(CGFloat)height {
    if(!self.tableView) {
        CGRect rtTableView = CGRectMake(0, 0, self.dynamicContainView.frame.size.width, height);
        self.tableView = [[ClassDetailSentInfoTableView alloc] initWithFrame:rtTableView style:UITableViewStylePlain];
        self.tableView.tableViewDelegate = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor colorWithIntRGB:231 green:231 blue:231 alpha:255];
    }
    self.tableView.frame = CGRectMake(0, 0, self.dynamicContainView.frame.size.width, height);
}
- (IBAction)commentAction:(id)sender {
    // TODO: 点击评论
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    
    ClassCommentManListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassCommentManListViewController"];
    vc.item = self.item;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)editAction:(id)sender {
    // TODO: 点击编辑
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    [sheet addButtonWithTitle:NSLocalizedString(@"Relay", nil)];
    //自己发送
    if([self.item.pub_id isEqualToString:UserInfoManagerInstance().userInfo.username ]) {
        [sheet addButtonWithTitle:NSLocalizedString(@"Relpace", nil)];
        [sheet addButtonWithTitle:NSLocalizedString(@"Delete", nil)];
    }
    [sheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    sheet.delegate = self;
    [sheet showInView:self.view];
}
- (IBAction)readerStatusAction:(id)sender {
    // TODO: 点击已读人数
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    
    ClassReaderViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassReaderViewController"];
    vc.item = self.item;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)playAction:(id)sender {
    UIView *view = (UIView *)sender;
    CGFloat alpha = view.alpha;
    CGRect frame = view.frame;
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(frame.origin.x - 40, frame.origin.y - 40, frame.size.width + 80, frame.size.height + 80);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        if(self.item.rtspurl.length > 0) {
            VLCMovieViewController *vc = [[VLCMovieViewController alloc] initWithNibName:nil bundle:nil];
            vc.url = [NSURL URLWithString:self.item.rtspurl];//[NSURL URLWithString:@"rtsp://192.168.42.189/my.ts"];
            ClassFile *file = [[self.item.attachments allObjects] objectAtIndex:0];
            vc.displayImage = [UIImage imageWithData:file.data scale:1.0];
            NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"];
            vc.resourcePath = resourcePath;
            UINavigationController *nvc = self.navigationController;
            [nvc pushViewController:vc animated:YES];
        }
        view.frame = frame;
        view.alpha = alpha;
    }];
}
#pragma mark - (动态tableview回调)
- (void)reSizetableViewHeight:(ClassDetailSentInfoTableView *)tableView newHeight:(CGFloat)newHeight {
    [self setupTableView:newHeight];
}
#pragma mark - (全屏显示)
- (void)toggleFullScreen {
    [self setupNavigationBar];
}
#pragma mark - (伸缩图界面回调 DynamicContainViewDelegete)
- (UIView *)viewForDetail:(DynamicContainView *)dynamicContainView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    [self.tableView removeFromSuperview];
    [view addSubview:self.tableView];
    return view;
}
- (UIView *)dynamicContainView:(DynamicContainView *)dynamicContainView viewForPithy:(CGRect)frame wholeFrame:(CGRect)wholeFrame{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wholeFrame.size.width, wholeFrame.size.height)];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    if(self.itemArray && self.itemArray.count > 0) {
        //SchoolImage *image = [self.itemArray objectAtIndex:_curIndex];
        UIColor *fontColor = [UIColor colorWithIntRGB:50 green:149 blue:170 alpha:255];
        
        CGRect titleFrame = CGRectMake(5, 5, frame.size.width *3/4  - 5, frame.size.height - 2 * 5);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        [view addSubview:titleLabel];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = self.item.title;
        titleLabel.textColor = fontColor;
        
//        CGRect countFrame = CGRectMake(titleFrame.origin.x + titleFrame.size.width + 5, 5, frame.size.width / 4 - 2 * 5, frame.size.height - 2 * 5);
//        UILabel *countLabel = [[UILabel alloc] initWithFrame:countFrame];
//        [view addSubview:countLabel];
//
//        countLabel.backgroundColor = [UIColor clearColor];
//        countLabel.textAlignment = NSTextAlignmentRight;
//        countLabel.text = [NSString stringWithFormat:@"%d/%d", _curIndex + 1, self.itemArray.count, nil];
//        countLabel.textColor = fontColor;
    }
    return view;
}

#pragma mark - (异步下载图片控件回调)
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    ClassFile *file = [ClassDataManager fileWithUrl:imageView.imageUrl isLocal:NO];
    if(file) {
        file.data = imageView.imageData;
        file.contenttype = imageView.contentType;
        [CoreDataManager saveData];
    }
}
#pragma mark - 弹出选择器回调 UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *indexTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([indexTitle isEqualToString:NSLocalizedString(@"Relay", nil)]) {
        // 转发
        [self pushIntoNewEventVC:[ClassDataManager StatausStringWithEventStatusType:EventStatusType_Add]];
    }
    else if([indexTitle isEqualToString:NSLocalizedString(@"Relpace", nil)]){
        // 替换
        [self pushIntoNewEventVC:[ClassDataManager StatausStringWithEventStatusType:EventStatusType_Cancel]];
    }
    else if([indexTitle isEqualToString:NSLocalizedString(@"Delete", nil)]){
        // 删除
        [self.requestOperator delSendEvent:self.item.event_id];
    }
}
#pragma mark - (协议请求)
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
        self.requestOperator = nil;
    }
}
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    return [self.requestOperator getSentEventDetail:self.item.event_id];
}
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    self.item.isRead = [NSNumber numberWithBool:YES];
    [CoreDataManager saveData];
    [self cancel];
    [self reloadData:YES];
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
}
@end
