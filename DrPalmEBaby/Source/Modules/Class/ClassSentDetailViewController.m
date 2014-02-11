//
//  ClassSentDetailViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassSentDetailViewController.h"
#import "ClassAttachmentDownloader.h"
#import "ClassSentAttachmentViewController.h"
#import "ClassCommentManListViewController.h"
#import "ClassReaderViewController.h"
#import "ClassNewEventViewController.h"

#import "ClassCommonDef.h"

@interface ClassSentDetailViewController () <ClassRequestOperatorDelegate> {
    
}
@property (nonatomic, strong) ClassRequestOperator *requestOperator;
@end

@implementation ClassSentDetailViewController

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
    [self setupDynamicContainView];
    [self setupTableView:0];
    [self setupWebView];
    self.commentButton.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadFromServer];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.dynamicContainView hide:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - (界面逻辑)
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
- (void)setupWebView {
    self.webView.scrollView.bounces = NO;
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
- (void)setupDynamicContainView {
    self.dynamicContainView.isDown = YES;
}
- (void)setupKKButtonBar {
    UIImage *image = nil;
    
    // 附件
    if([self.item.attachments count] > 0) {
        self.attachmentButton.hidden = NO;
    }
    else {
        self.attachmentButton.hidden = YES;
    }
    
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
- (IBAction)attachmentAction:(id)sender {
    // TODO: 点击附件
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    
    ClassSentAttachmentViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassSentAttachmentViewController"];
    vc.item = self.item;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)commentAction:(id)sender {
    // TODO: 点击评论
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;

    ClassCommentManListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassCommentManListViewController"];
    vc.item = self.item;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)readerStatusAction:(id)sender {
    // TODO: 点击已读人数
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    
    ClassReaderViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassReaderViewController"];
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
- (void)reloadData {
    self.item = [ClassDataManager eventSentWithId:self.item.event_id];
    
    // 加载标题
    self.tableView.item = self.item;
    [self.tableView reloadData];
    [self.dynamicContainView reLoadView];

    // 加载内容
    if(self.item.body.length > 0)
        [self.webView loadHTMLString:[self htmlStringFromString:self.item.body] baseURL:nil];
    
    // 加载已读
    NSString *report = [NSString stringWithFormat:@"%@(%@/%@)", NSLocalizedString(@"ReaderStatus", nil), self.item.readCount,self.item.readTotal];
    self.reportLabel.text = report;
    
    // 加载功能
    [self setupKKButtonBar];
}
- (NSString *)htmlStringFromString:(NSString *)source {
	NSURL *baseURL = [NSURL fileURLWithPath:[ResourceManager resourcePath] isDirectory:YES];
	NSURL *fileURL = [NSURL URLWithString:@"class_event_template.html" relativeToURL:baseURL];
	NSError *error;
	NSMutableString *target = [NSMutableString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
	if (!target) {
//		ELog(@"Failed to load template at %@. %@", fileURL, [error userInfo]);
        return @"";
	}
    
    NSString *maxWidth = [NSString stringWithFormat:@"%.0f", self.webView.frame.size.width];
    [target replaceOccurrencesOfString:@"__WIDTH__" withString:maxWidth options:NSLiteralSearch range:NSMakeRange(0, target.length)];
    
	[target replaceOccurrencesOfStrings:[NSArray arrayWithObject:@"__BODY__"]
							withStrings:[NSArray arrayWithObject:source]
								options:NSLiteralSearch];
    
	return target;
}
#pragma mark - (动态tableview回调)
- (void)reSizetableViewHeight:(ClassDetailSentInfoTableView *)tableView newHeight:(CGFloat)newHeight {
    [self setupTableView:newHeight];
}
#pragma mark - (伸缩图界面回调 DynamicContainViewDelegete)
- (void)didShowDynamicContainView:(DynamicContainView *)dynamicContainView boundsSize:(CGSize)boundsSize duration:(CGFloat)duration{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    if(self.webView) {
        self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y + boundsSize.height, self.webView.frame.size.width, self.view.frame.size.height - self.webView.frame.origin.y - boundsSize.height);
    }
    [UIView commitAnimations];
}
- (void)didHideDynamicContainView:(DynamicContainView *)dynamicContainView boundsSize:(CGSize)boundsSize duration:(CGFloat)duration{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    if(self.webView) {
        self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y - boundsSize.height, self.webView.frame.size.width, self.view.frame.size.height - self.webView.frame.origin.y + boundsSize.height);
    }
    [UIView commitAnimations];
}
- (UIView *)viewForDetail:(DynamicContainView *)dynamicContainView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    [self.tableView removeFromSuperview];
    [view addSubview:self.tableView];
    return view;
}
- (UIView *)dynamicContainView:(DynamicContainView *)dynamicContainView viewForPithy:(CGRect)frame wholeFrame:(CGRect)wholeFrame{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wholeFrame.size.width, wholeFrame.size.height)];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    CGRect titleFrame = CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 2 * 5);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [view addSubview:titleLabel];

    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor colorWithIntRGB:136 green:113 blue:105 alpha:255];
    
    if(self.item.title.length > 0) {
        titleLabel.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"Title", nil), self.item.title, nil];
    }
    return view;
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
    //[_loadingview hideLoading:YES];
    self.item.isRead = [NSNumber numberWithBool:YES];
    [CoreDataManager saveData];
    [self cancel];
    [self reloadData];
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    //[_loadingview hideLoading:YES];
    [self cancel];
}
#pragma mark -  (分享回调ShareItemDelegate)
- (NSString *)actionSheetTitle {
	return @"";
}
- (NSString *)emailSubject {
	return [NSString stringWithFormat:@"%@", self.item.title];
}
- (NSString *)emailBody{
    NSMutableString *body = [NSMutableString string];
    NSArray* files = [ClassDataManager filesWithClassEventId:self.item
                      .event_id];
    if(files!= nil && files.count>0) {
        ClassFile* file = (ClassFile*)[files objectAtIndex:0];
        [body appendFormat:@"%@\n%@", self.item.cleanbody,file.path];
    }
    else
        [body appendFormat:@"%@", self.item.cleanbody];
	return body;
}
- (NSString*)urlBody
{
    NSString *urlBody = @"";
    urlBody = [self emailBody];
    return urlBody;
}
- (BOOL)isHtmlBody {
    return NO;
}
- (NSString *)contentBody {
    return [self emailBody];
}
@end
