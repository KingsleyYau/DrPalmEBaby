//
//  ClassDetailViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassDetailViewController.h"
#import "ClassAttachmentDownloader.h"
#import "ClassAttachmentViewController.h"
#import "ClassCommentDetailViewController.h"
#import "ClassReviewViewController.h"

#import "ClassCommonDef.h"

@interface ClassDetailViewController () <ClassRequestOperatorDelegate> {
    
}
@property (nonatomic, strong) ClassRequestOperator *requestOperator;
@property (nonatomic, strong) ClassRequestOperator *bookmarkRequestOperator;
@end

@implementation ClassDetailViewController

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
    [self setupKKButtonBar];
    self.shareDelegate = self;
    self.reviewButton.hidden = YES;
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
    titleLabel.text = NSLocalizedString(@"ClassDetailNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupWebView {
    self.webView.scrollView.bounces = NO;
}
- (void)setupTableView:(CGFloat)height {
    if(!self.tableView) {
        CGRect rtTableView = CGRectMake(0, 0, self.dynamicContainView.frame.size.width, height);
        self.tableView = [[ClassDetailInfoTableView alloc] initWithFrame:rtTableView style:UITableViewStylePlain];
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
        [self.attachmentButton setBadgeValue:[NSString stringWithFormat:@"%d", [self.item.attachments count]]];
    }
    else {
        self.attachmentButton.hidden = YES;
        [self.attachmentButton setBadgeValue:nil];
    }
    
    // 评论
    if([ClassDataManager hasAnwserWithEventId:self.item.event_id]) {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonDetailCommentNewButton ofType:@"png"]];
    }
    else {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonDetailCommentButton ofType:@"png"]];
    }
    [self.commentButton setImage:image forState:UIControlStateNormal];
    if([self.item.pub_id isEqualToString:LoginManagerInstance().accountName]) {
        // 发送人是自己则不能回复
        self.commentButton.hidden = YES;
    }
    else {
        self.commentButton.hidden = NO;
    }
    
    // 收藏
    if([self.item.bookmarked boolValue]) {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonDetailBookmarkOnButton ofType:@"png"]];
    }
    else {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonDetailBookmarkOffButton ofType:@"png"]];
    }
    [self.bookmarkButton setImage:image forState:UIControlStateNormal];
    
    //回评
    if([self.item.needreview boolValue] && [self.item.reviewTemp allObjects].count > 0) {
        self.reviewButton.hidden = NO;
    }
    else {
        self.reviewButton.hidden = YES;
    }
}
- (IBAction)attachmentAction:(id)sender {
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassAttachmentViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassAttachmentViewController"];
    vc.item = self.item;
    [nvc pushViewController:vc animated:YES gesture:NO];
}
- (IBAction)bookmarkAction:(id)sender {
//    self.item.bookmarked = [NSNumber numberWithBool:![self.item.bookmarked boolValue]];
//    [CoreDataManager saveData];
    [ClassDataManager bookmarkEvent:self.item.event_id bookmark:![self.item.bookmarked boolValue]];
    [self reloadData];
    [self setupKKButtonBar];
    [self submitBookmarkEvent];
}
- (IBAction)commentAction:(id)sender {
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassCommentDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassCommentDetailViewController"];
    vc.item = self.item;
    vc.classAnwserMan = (ClassAnwserMan*)[[ClassDataManager anwserListWithEventId:self.item.event_id] lastObject];
    [nvc pushViewController:vc animated:YES gesture:NO];
}
- (IBAction)reviewAction:(id)sender {
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassReviewViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassReviewViewController"];
    vc.item = self.item;
    [nvc pushViewController:vc animated:YES gesture:NO];
}
- (void)reloadData {
    self.item = [ClassDataManager eventWithId:self.item.event_id];
    self.isLoadFromServer = [self.item.isReadforServer boolValue];
    // 加载标题
    self.tableView.item = self.item;
    [self.tableView reloadData];
    [self.dynamicContainView reLoadView];

    // 加载内容
    if(self.item.body.length > 0)
        [self.webView loadHTMLString:[self htmlStringFromString:self.item.body] baseURL:nil];
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
- (void)notifyMainViewUnreadCountDec {
    [AppDelegate() unReadCountDesc:[[self.item.categories allObjects] lastObject]];
}
#pragma mark - (动态tableview回调)
- (void)reSizetableViewHeight:(ClassDetailInfoTableView *)tableView newHeight:(CGFloat)newHeight {
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
    return [self.requestOperator getEventDetail:self.item.event_id isAllField:self.needLoadAllDetail];
}
- (void)cancelBookmark {
    if(self.bookmarkRequestOperator) {
        [self.bookmarkRequestOperator cancel];
        self.bookmarkRequestOperator = nil;
    }
}
- (BOOL)submitBookmarkEvent {
    // TODO:同步本地修改收藏到服务器
    [self cancelBookmark];
    if(!self.bookmarkRequestOperator) {
        self.bookmarkRequestOperator = [[ClassRequestOperator alloc] init];
        self.bookmarkRequestOperator.delegate = self;
    }
    NSArray *array = [ClassDataManager eventListWithBookmarkSynchronize];
    return [self.bookmarkRequestOperator submitBookmarkEvent:array];
}
#pragma mark - 协议回调 (ClassRequestOperatorDelegate)
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    switch(type){
        case ClassRequestOperator_GetEventDetail: {
            [self cancel];
            // 后台认为没读，未读条数--
            if(!self.isLoadFromServer) {
                [self notifyMainViewUnreadCountDec];
            }
            [self reloadData];
        }break;
        case ClassRequestOperator_SubmitBookmarkEvent:{
            [self cancelBookmark];
            [ClassDataManager cancelEventListWithBookmarkSynchronize];
        }break;
        default:break;
    }
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    switch(type){
        case ClassRequestOperator_GetEventDetail: {
            [self cancel];
            [self setTopStatusText:error];
        }break;
        case ClassRequestOperator_SubmitBookmarkEvent:{
            [self cancelBookmark];
            [self setTopStatusText:error];
        }break;
        default:break;
    }
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
