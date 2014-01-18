//
//  ClassSentAlbumnDetailViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassSentAlbumnDetailViewController.h"
#import "ClassCommentManListViewController.h"
#import "ClassReaderViewController.h"
#import "ClassNewEventViewController.h"

#import "ClassAttachmentDownloader.h"
#import "ClassCommonDef.h"

#define DETAIL_VIEW_MIN_HEIGHT 44

@interface ClassSentAlbumnDetailViewController () <RequestImageViewDelegate, ClassRequestOperatorDelegate, ClassAttachmentDownloaderDelegate>  {
    NSInteger _curIndex;
    BOOL _fullScreen;
    
    // 批量下载控制标志
    NSInteger     downloadcount;
    NSInteger     downloadsuccesscount;
    NSInteger     downloadfailedcount;
    NSInteger     saveCount;
    NSInteger     saveSuccessCount;
    BOOL  _saveSuccess;
    BOOL  _batSave;
    NSCondition *_condition;
}
@property (nonatomic, retain) NSArray *itemArray;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation ClassSentAlbumnDetailViewController

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
    [self setupLoadingView];
    
    self.commentButton.hidden = YES;
    _condition = [[NSCondition alloc] init];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pzPagingScrollView.pagingViewDelegate = self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupDynamicView];
    [self reloadData:YES];
    [self loadFromServer];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resetNavigationBar];
    self.pzPagingScrollView.pagingViewDelegate = nil;
    [self.dynamicContainView hide:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 横屏切换
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIDeviceOrientationIsValidInterfaceOrientation(interfaceOrientation);
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
#pragma mark - 横竖切换回调 (UIViewControllerRotation)
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        // 切换到横屏前隐藏工具栏
        [UIView animateWithDuration:0.4 animations:^{
            self.navigationController.navigationBar.alpha = 0.0;
            _dynamicContainView.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        // 切换到竖屏前显示状态栏
        //        [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationFade];
        [self toggleFullScreen];
    }
    // suspend tiling while rotating
    if(self.pzPagingScrollView)
        self.pzPagingScrollView.suspendTiling = TRUE;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if(self.pzPagingScrollView) {
        self.pzPagingScrollView.suspendTiling = FALSE;
        if(self.itemArray.count > 0) {
            [self.pzPagingScrollView resetDisplay];
            [self.pzPagingScrollView displayPagingViewAtIndex:_curIndex];
        }
    }
    //    if(UIInterfaceOrientationIsLandscape(fromInterfaceOrientation)) {
    //        // 由横屏横屏切换回来显示状态栏
    //        if(_fullScreen) {
    //            [UIApplication sharedApplication].statusBarHidden = YES;
    //        }
    //    }
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
            _curIndex = 0;
            [self.pzPagingScrollView resetDisplay];
        }
        self.tableView.item = self.item;
        [self.tableView reloadData];
        [_dynamicContainView reLoadView];
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
- (void)resetNavigationBar {
    self.navigationController.navigationBar.alpha = 1.0;
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    if (!_fullScreen) {
        //        [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationFade];
        // fade in navigation
        [UIView animateWithDuration:0.4 animations:^{
            self.navigationController.navigationBar.alpha = 0.8;
            self.navigationController.toolbar.alpha = 0.8;
            self.dynamicContainView.alpha = 0.8;
            self.reportView.alpha = 0.8;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        //        [[UIApplication sharedApplication] setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationFade];
        // fade out navigation
        [UIView animateWithDuration:0.4 animations:^{
            self.navigationController.navigationBar.alpha = 0.0;
            self.navigationController.toolbar.alpha = 0.0;
            _dynamicContainView.alpha = 0.0;
            self.reportView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
    }

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
    // 下载多个
    if(self.itemArray.count <= 1) {
        self.batDownloadButton.hidden = YES;
    }
    else {
        self.batDownloadButton.hidden = NO;
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
- (void)setupDynamicView {
    [self.dynamicContainView initialize];
    self.dynamicContainView.isDown = NO;
}
- (void)setupPZPagingScrollView {
    self.pzPagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
- (void)setupLoadingView {
    if(!self.loadingView) {
        self.loadingView = [[LoadingView alloc] init];
    }
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
#pragma mark - (批量下载逻辑)
- (IBAction)downloadBatAction:(id)sender {
    // 批量下载
    if(self.itemArray.count > 0) {
        downloadcount = 0;
        downloadsuccesscount = 0;
        downloadfailedcount  = 0;
        [_loadingView showLoading:self.navigationController.view animated:YES];
        for(ClassFile *file in self.itemArray) {
            if(file.data == nil) {
                downloadcount++;
                ClassAttachmentDownloader* attachmentDownloader = [[ClassAttachmentDownloader alloc] init];
                [attachmentDownloader startDownload:file.path delegate:self];
            }
        }
        
        if(downloadcount==0)
            [self saveToImageAlbum:YES index:0];
    }

}
- (IBAction)downloadAction:(id)sender {
    // 下载
    [_loadingView showLoading:self.navigationController.view animated:YES];
    [self saveToImageAlbum:NO index:_curIndex];
}
- (void)saveToImageAlbum:(BOOL)batsave index:(NSInteger)index
{
    // TODO:保存图片到相册(batsave,是否批量保存，  index,单张保存，仅batsave为no时有效)
    if(self.itemArray == nil || self.itemArray.count == 0)
        return;
    
    // NSString *tips = ClassAttachmentsDownLoadAllNotOK;
    _batSave = batsave;
    saveCount = 0;
    saveSuccessCount = 0;
    NSMutableArray* savearray = [NSMutableArray array];
    if(batsave) {
        for(ClassFile *file in self.itemArray) {
            if(file.data!=nil) {
                saveCount++;
                [savearray addObject:file.data];
            }
        }
    }
    else {
        ClassFile *file = [self.itemArray objectAtIndex:index];
        if(file.data != nil) {
            saveCount++;
            [savearray addObject:file.data];
        }
    }
    //下载
    if(savearray!=nil && savearray.count>0) {
        _saveSuccess = YES;
        [NSThread detachNewThreadSelector:@selector(saveImage:) toTarget:self withObject:savearray];
    }
    else {
        [_loadingView hideLoading:YES];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"PictureDownLoadFail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
        [alert show];
    }
    
}
#pragma mark - 下载控制器回调 (ClassAttachmentDownloaderDelegate)
- (void)attachmentDownloader:(ClassAttachmentDownloader*)attachmentDownloader downloadFinish:(NSData*)data contentType:(NSString*)contentType
{
    downloadsuccesscount++;
    ClassFile* file = [ClassDataManager fileWithUrl:attachmentDownloader.url isLocal:NO];
    if(nil!= file)
    {
        file.data = data;
        file.contenttype = contentType;
        [CoreDataManager saveData];
    }
    // 界面退出loading状态
    if(downloadsuccesscount+downloadfailedcount == downloadcount)
    {
        [self saveToImageAlbum:YES index:0];
    }
}
- (BOOL)attachmentDownloader:(ClassAttachmentDownloader*)attachmentDownloader startDownload:(NSString*)contentType {
    if([RequestImageView isImageType:contentType]) {
        return YES;
    }
    else {
        downloadsuccesscount++;
        if(downloadsuccesscount+downloadfailedcount == downloadcount)
        {
            [self saveToImageAlbum:YES index:0];
        }
        return NO;
    }
}
- (void)attachmentDownloader:(ClassAttachmentDownloader *)attachmentDownloader downloadFail:(NSError*)error
{
    downloadfailedcount++;
    // 界面退出loading状态
    if(downloadsuccesscount+downloadfailedcount == downloadcount)
    {
        [self saveToImageAlbum:YES index:0];
    }
}
- (void)saveImage:(NSMutableArray*)imagearray {
    for(NSData* data in imagearray) {
        [_condition lock];
        if(!_saveSuccess)
        {
            [_condition unlock];
            break;
        }
        NSLog(@"begin save!!");
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        [_condition wait];
        [_condition unlock];
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(error)
        {
            NSLog(@"save image failed!!");
            _saveSuccess = NO;
            [_loadingView hideLoading:YES];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"AttachmentDownLoadFail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSLog(@"save image success!");
            _saveSuccess = YES;
            saveSuccessCount++;
            if(saveSuccessCount==saveCount)
            {
                [_loadingView hideLoading:YES];
                NSString* tips = @"";
                if(!_batSave)
                    tips = NSLocalizedString(@"AttachmentDownLoadSucceed", nil);
                else
                {
                    if(saveSuccessCount != self.itemArray.count)
                        tips = NSLocalizedString(@"AttachmentDownLoadOnlyPicutreSucceed", nil);
                    else
                        tips = NSLocalizedString(@"AttachmentDownLoadAllSucceed", nil);
                }
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:tips delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
                [alert show];
            }
        }
        [_condition signal];
    });
    return;
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
        
        CGRect countFrame = CGRectMake(titleFrame.origin.x + titleFrame.size.width + 5, 5, frame.size.width / 4 - 2 * 5, frame.size.height - 2 * 5);
        UILabel *countLabel = [[UILabel alloc] initWithFrame:countFrame];
        [view addSubview:countLabel];

        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.textAlignment = NSTextAlignmentRight;
        countLabel.text = [NSString stringWithFormat:@"%d/%d", _curIndex + 1, self.itemArray.count, nil];
        countLabel.textColor = fontColor;
    }
    return view;
}
#pragma mark - (滑动界面回调)
- (Class)pagingScrollView:(PZPagingScrollView *)pagingScrollView classForIndex:(NSUInteger)index {
    return [RequestImageView class];
}
- (NSUInteger)pagingScrollViewPagingViewCount:(PZPagingScrollView *)pagingScrollView {
    //return self.images.count;
    return (nil == self.itemArray)?0:self.itemArray.count;
}
- (UIView *)pagingScrollView:(PZPagingScrollView *)pagingScrollView pageViewForIndex:(NSUInteger)index {
    UIView *view = nil;
    RequestImageView *requestView = [[RequestImageView alloc] initWithFrame:self.view.bounds];
    requestView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    requestView.contentMode = UIViewContentModeScaleAspectFit;
    requestView.backgroundColor = [UIColor clearColor];
    requestView.isPhotoView = YES;
    requestView.delegate = self;
    view = requestView;
    
    return view;
}
- (void)pagingScrollView:(PZPagingScrollView *)pagingScrollView preparePageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index {
    ClassFile *file = [self.itemArray objectAtIndex:index];
    RequestImageView *requestView = (RequestImageView *)pageView;
    requestView.delegate = self;
    requestView.imageUrl = file.path;
    requestView.imageData = file.data;
    [requestView loadImage];
}
- (void)pagingScrollView:(PZPagingScrollView *)pagingScrollView didShowPageViewForDisplay:(NSUInteger)index {
    _curIndex = index;
    [self.dynamicContainView hide:NO];
    [self.dynamicContainView reLoadView];
}
#pragma mark - (异步下载图片控件回调)
- (void)photoViewDidSingleTap:(RequestImageView *)imageView {
    // 竖屏才能显示工具栏
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        _fullScreen = !_fullScreen;
        [self toggleFullScreen];
    }
}
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
    //[_loadingview hideLoading:YES];
    self.item.isRead = [NSNumber numberWithBool:YES];
    [CoreDataManager saveData];
    [self cancel];
    [self reloadData:YES];
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    //[_loadingview hideLoading:YES];
    [self cancel];
}
@end
