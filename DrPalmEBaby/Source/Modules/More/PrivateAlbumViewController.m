//
//  PrivateAlbumViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "PrivateAlbumViewController.h"
#import "SchoolAttachmentDownloader.h"
#import "EditPrivateAlbumViewController.h"
#import "CommonRequestOperator.h"

#define DETAIL_VIEW_MIN_HEIGHT 44

@interface PrivateAlbumViewController () <RequestImageViewDelegate, CommonRequestOperatorDelegate, SchoolAttachmentDownloaderDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
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
@property (nonatomic, retain) CommonRequestOperator* requestOperator;
@end

@implementation PrivateAlbumViewController

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

    [self setupLoadingView];
    _condition = [[NSCondition alloc] init];
    self.shareDelegate = self;
    self.buttonBar.hidden = YES;
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
    self.itemArray = [UserInfoManager getAlbumImageList];
    if(isReloadView && self.itemArray.count > 0) {
        _curIndex = 0;
        [self.pzPagingScrollView resetDisplay];
        [_dynamicContainView reLoadView];
        self.buttonBar.hidden = NO;
        [self setupKKButtonBar];
    }
    else {
        self.buttonBar.hidden = YES;
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
    titleLabel.text = NSLocalizedString(@"PersonalAlbumn", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    // TODO:右边按钮
    NSMutableArray *array = [NSMutableArray array];
    
    UIBarButtonItem *barButtonItem = nil;
    UIButton *button = nil;
    UIImage *image = nil;
    
    // 编辑按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlue ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [button addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlueC ofType:@"png"]];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
        
    self.navigationItem.rightBarButtonItems = array;
}
- (void)setupKKButtonBar {
    // 下载多个
    if(self.itemArray.count <= 1) {
        self.batDownloadButton.hidden = YES;
    }
    else {
        self.batDownloadButton.hidden = NO;
    }
}
- (void)setupDynamicView {
    [self.dynamicContainView initialize];
    self.dynamicContainView.isDown = NO;
}
- (void)setupPZPagingScrollView {
    self.pzPagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}
- (void)setupLoadingView {
    if(!self.loadingView) {
        self.loadingView = [[LoadingView alloc] init];
    }
}
- (IBAction)editAction:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    [sheet addButtonWithTitle:NSLocalizedString(@"Add", nil)];
    if(self.itemArray && self.itemArray.count > 0) {
        [sheet addButtonWithTitle:NSLocalizedString(@"Remark", nil)];
        [sheet addButtonWithTitle:NSLocalizedString(@"Delete", nil)];
    }
    [sheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    sheet.delegate = self;
    [sheet showInView:self.view];
}
#pragma mark - (批量下载逻辑)
- (IBAction)downloadBatAction:(id)sender {
    // 批量下载
    if(self.itemArray.count > 0) {
        downloadcount = 0;
        downloadsuccesscount = 0;
        downloadfailedcount  = 0;
        [_loadingView showLoading:self.navigationController.view animated:YES];
        
        for(PrivateAlbum *album in self.itemArray) {
            HeadImage *file= [UserInfoManager headImageWithUrl:album.image.url];
            if(file.data == nil) {
                downloadcount++;
                SchoolAttachmentDownloader* attachmentDownloader = [[SchoolAttachmentDownloader alloc] init];
                [attachmentDownloader startDownload:file.url delegate:self];
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
        for(PrivateAlbum *album in self.itemArray) {
            HeadImage *file= [UserInfoManager headImageWithUrl:album.image.url];
            if(file.data!=nil) {
                saveCount++;
                [savearray addObject:file.data];
            }
        }
    }
    else {
        PrivateAlbum *album = [self.itemArray objectAtIndex:index];
        HeadImage *file= [UserInfoManager headImageWithUrl:album.image.url];
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
- (void)attachmentDownloader:(SchoolAttachmentDownloader*)attachmentDownloader downloadFinish:(NSData*)data contentType:(NSString*)contentType
{
    downloadsuccesscount++;
    HeadImage *file = [UserInfoManager headImageWithUrl:attachmentDownloader.url];
    if(nil!= file)
    {
        file.data = data;
        [CoreDataManager saveData];
    }
    // 界面退出loading状态
    if(downloadsuccesscount+downloadfailedcount == downloadcount)
    {
        [self saveToImageAlbum:YES index:0];
    }
}
- (BOOL)attachmentDownloader:(SchoolAttachmentDownloader*)attachmentDownloader startDownload:(NSString*)contentType {
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
- (void)attachmentDownloader:(SchoolAttachmentDownloader *)attachmentDownloader downloadFail:(NSError*)error
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
                        tips = NSLocalizedString(@"AttachmentDownLoadOnlyPicutreSucceed", nil);
                    else
                        tips = NSLocalizedString(@"AttachmentDownLoadAllSucceed", nil);
                }
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:tips delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
                [alert show];
            }
        }
        [_condition signal];
    });
    return;
}
#pragma mark - (全屏显示)
- (void)toggleFullScreen {
    [self setupNavigationBar];
}
#pragma mark - (伸缩图界面回调 DynamicContainViewDelegete)
- (UIView *)viewForDetail:(DynamicContainView *)dynamicContainView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    if(self.itemArray && self.itemArray.count > 0) {
        PrivateAlbum *album = [self.itemArray objectAtIndex:_curIndex];
        NSString *commentString = album.des;
        CGSize viewSize = [commentString sizeWithFont:[UIFont boldSystemFontOfSize:17]
                                    constrainedToSize:CGSizeMake(self.view.frame.size.width - 4 * BLANKING_X, MAXFLOAT)
                                        lineBreakMode:NSLineBreakByTruncatingTail];
        NSInteger height = MAX(DETAIL_VIEW_MIN_HEIGHT, viewSize.height);
        CGRect frame = CGRectMake(0, 0, dynamicContainView.frame.size.width, height);
        view.frame = frame;
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLANKING_X, 0, frame.size.width - 2 * BLANKING_X, viewSize.height)];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.font = [UIFont boldSystemFontOfSize:17];
        commentLabel.text = commentString;
        commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        commentLabel.numberOfLines = 0;
        commentLabel.textColor = [UIColor lightGrayColor];
        [view addSubview:commentLabel];
    }
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
//        titleLabel.text = self.item.title;
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
    PrivateAlbum *album = [self.itemArray objectAtIndex:index];
    RequestImageView *requestView = (RequestImageView *)pageView;
    requestView.delegate = self;
    requestView.imageUrl = album.image.url;
    requestView.imageData = album.image.data;
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
    HeadImage *file = [UserInfoManager headImageWithUrl:imageView.imageUrl];
    if(file) {
        file.data = imageView.imageData;
        [CoreDataManager saveData];
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 != buttonIndex){
        [self submitToServer];
    }
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:NSLocalizedString(@"Add", nil)]) {
        // 超过20张
        if(self.itemArray.count >= 20) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"PrivateAlbum_Add_Error", nil)  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        UIStoryboard *storyBoard = AppDelegate().storyBoard;
        KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
        EditPrivateAlbumViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"EditPrivateAlbumViewController"];
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if([buttonTitle isEqualToString:NSLocalizedString(@"Remark", nil)]){
        UIStoryboard *storyBoard = AppDelegate().storyBoard;
        KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
        EditPrivateAlbumViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"EditPrivateAlbumViewController"];
        
        PrivateAlbum *album = [self.itemArray objectAtIndex:_curIndex];
        PrivateAlbumForSent *item = [[PrivateAlbumForSent alloc] init];
        item.imageId = album.imageid;
        item.desc = album.des;
        item.data = album.image.data;
        item.status = OperateStatus_Modify;
        vc.item = item;
        
        [nvc pushViewController:vc animated:YES gesture:YES];
    }
    else if([buttonTitle isEqualToString:NSLocalizedString(@"Delete", nil)]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"EnsureDelete?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Delete", nil), nil];
        [alert show];
    }
    else if([buttonTitle isEqualToString:NSLocalizedString(@"Cancel", nil)]) {
        
    }
}
#pragma mark - (协议请求)
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
        self.requestOperator = nil;
    }
}
- (BOOL)submitToServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[CommonRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    PrivateAlbum *album = [self.itemArray objectAtIndex:_curIndex];
    PrivateAlbumForSent *albumForSent = [[PrivateAlbumForSent alloc] init];
    albumForSent.imageId = album.imageid;
    albumForSent.status = OperateStatus_Del;
    
    NSMutableArray *sendArray = [NSMutableArray arrayWithObjects:albumForSent, nil];
    return [self.requestOperator submitUserAlbum:sendArray];
}
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[CommonRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    NSString* lastupdate = @"0";
    NSInteger time = [[UserInfoManager getAlbumLastupdate] timeIntervalSince1970];
    lastupdate = [NSString stringWithFormat:@"%d",time,nil];
    
    return [self.requestOperator getUserAlbum:lastupdate];
}
- (void)requestFinish:(id)data requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    if(type == CommonRequestOperatorStatus_GetUserAlbum) {
        [self reloadData:YES];
    }
    else if(type == CommonRequestOperatorStatus_SubmitUserAlbum) {
        [self loadFromServer];
    }
}
- (void)requestFail:(NSString *)error requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
}
@end
