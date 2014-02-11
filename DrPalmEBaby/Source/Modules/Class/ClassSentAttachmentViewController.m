//
//  ClassSentAttachmentViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassSentAttachmentViewController.h"
#import "ClassCommentDetailViewController.h"
#import "ClassAttachmentDownloader.h"
#import "ClassCommonDef.h"

#define DETAIL_VIEW_MIN_HEIGHT 44

@interface ClassSentAttachmentViewController () <RequestImageViewDelegate, ClassAttachmentDownloaderDelegate>  {
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
@end

@implementation ClassSentAttachmentViewController

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
    [self setupDynamicView];
    [self setupTableView:0];
    [self setupLoadingView];
    
    _condition = [[NSCondition alloc] init];
    self.shareDelegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pzPagingScrollView.pagingViewDelegate = self;
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self loadFromServer];
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
    if(isReloadView && self.itemArray.count > 0) {
        _curIndex = 0;
        [self.pzPagingScrollView resetDisplay];
        self.tableView.item = self.item;
        [self.tableView reloadData];
        [_dynamicContainView reLoadView];
        [self setupKKButtonBar];
    }
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
        } completion:^(BOOL finished) {
            
        }];
    }

    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"ClassSentAttachmentViewNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
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
    if([ClassDataManager hasAnwserWithEventId:self.item.event_id]) {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonDetailCommentNewButton ofType:@"png"]];
    }
    else {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonDetailCommentButton ofType:@"png"]];
    }
    [self.commentButton setImage:image forState:UIControlStateNormal];
}
- (void)setupDynamicView {
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
//    UIStoryboard *storyBoard = AppDelegate().storyBoard;
//    
//    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
//    ClassCommentDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassCommentDetailViewController"];
//    vc.item = self.item;
//    vc.classAnwserMan = (ClassAnwserMan*)[[ClassDataManager anwserListWithEventId:self.item.event_id] lastObject];
//    [nvc pushViewController:vc animated:YES gesture:NO];
}
- (void)notifyMainViewUnreadCountDec {
    [AppDelegate() unReadCountDesc:[[self.item.categories allObjects] lastObject]];
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
        NSString* tips = NSLocalizedString(@"AttachmentDownLoadNoPictureFail", nil);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:tips delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
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
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"AttachmentDownLoadFail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
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
                        tips = NSLocalizedString(@"AttachmentDownLoadAllSucceed", nil);
                    else
                        tips = NSLocalizedString(@"AttachmentDownLoadOnlyPicutreSucceed", nil);
                }
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:tips delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
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
@end
