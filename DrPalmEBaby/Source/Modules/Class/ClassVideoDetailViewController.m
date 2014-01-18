//
//  ClassVideoDetailViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassVideoDetailViewController.h"
#import "ClassCommentDetailViewController.h"
#import "VLCMovieViewController.h"
#import "ClassAttachmentDownloader.h"
#import "ClassCommonDef.h"

#define DETAIL_VIEW_MIN_HEIGHT 44

@interface ClassVideoDetailViewController () <RequestImageViewDelegate, ClassRequestOperatorDelegate>  {
}
@property (nonatomic, retain) NSArray *itemArray;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@property (nonatomic, strong) ClassRequestOperator *bookmarkRequestOperator;
@end

@implementation ClassVideoDetailViewController

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
    [self setupKKButtonBar];
    self.playButton.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.requestImageView.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated {
    if(!self.viewDidAppearEver) {
        [self setupDynamicView];
    }
    
    [self reloadData:YES];
    [self loadFromServer];
    [super viewDidAppear:animated];
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
    
    self.item = [ClassDataManager eventWithId:self.item.event_id];
    self.itemArray = [ClassDataManager filesWithClassEventId:self.item.event_id];
    
    self.isLoadFromServer = [self.item.isReadforServer boolValue];
    
    if(isReloadView) {
        if(self.itemArray.count > 0) {
            self.playButton.hidden = NO;
            
            // TODO:加载预览图片
            ClassFile *file = [[self.item.attachments allObjects] objectAtIndex:0];
            self.requestImageView.imageUrl = file.path;
            self.requestImageView.imageData = file.data;
            [self.requestImageView loadImage];
        }
        // TODO:加载描述栏
        self.tableView.item = self.item;
        [self.tableView reloadData];
        [self.dynamicContainView hide:NO];
        [_dynamicContainView reLoadView];
        
        // TODO:加载工具栏
        [self setupKKButtonBar];
    }
}
- (void)setupNavigationBar {
    [super setupNavigationBar];

    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"ClassVieoDetailNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupKKButtonBar {
    UIImage *image = nil;
    
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
        self.tableView = [[ClassDetailInfoTableView alloc] initWithFrame:rtTableView style:UITableViewStylePlain];
        self.tableView.tableViewDelegate = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor colorWithIntRGB:231 green:231 blue:231 alpha:255];
    }
    self.tableView.frame = CGRectMake(0, 0, self.dynamicContainView.frame.size.width, height);
}
- (IBAction)bookmarkAction:(id)sender {
//    self.item.bookmarked = [NSNumber numberWithBool:![self.item.bookmarked boolValue]];
//    [CoreDataManager saveData];
    [ClassDataManager bookmarkEvent:self.item.event_id bookmark:![self.item.bookmarked boolValue]];
    [self reloadData:YES];
    [self setupKKButtonBar];
    [self submitBookmarkEvent];
}
- (IBAction)commentAction:(id)sender {
    // 点击评论
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    ClassCommentDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassCommentDetailViewController"];
    vc.item = self.item;
    vc.classAnwserMan = (ClassAnwserMan*)[[ClassDataManager anwserListWithEventId:self.item.event_id] lastObject];
    [nvc pushViewController:vc animated:YES gesture:NO];
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
- (void)notifyMainViewUnreadCountDec {
    [AppDelegate() unReadCountDesc:[[self.item.categories allObjects] lastObject]];
}
#pragma mark - (动态tableview回调)
- (void)reSizetableViewHeight:(ClassDetailInfoTableView *)tableView newHeight:(CGFloat)newHeight {
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
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    switch(type){
        case ClassRequestOperator_GetEventDetail: {
            [self cancel];
            //后台认为没读，未读条数--
            if(!self.isLoadFromServer)
            {
                [self notifyMainViewUnreadCountDec];
                self.item.isReadforServer = [NSNumber numberWithBool:YES];
                [CoreDataManager saveData];
            }
            [self reloadData:YES];
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
@end
