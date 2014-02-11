//
//  EditPrivateAlbumViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-7.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "EditPrivateAlbumViewController.h"
#import "CommonRequestOperator.h"

#define DELBTN_TAG_BASE      500
#define IMAGEVIEW_TOP        60

#define AttachmentsLimit            (15)
#define UnselectedDefaultValue      (-1)
#define CarouselHeightPercent       (0.7f)
#define CarouselItemWidthPercen     (0.8f)
#define ImagePickerReferenceURLKey  @"UIImagePickerControllerReferenceURL"
#define ImagePickerOriginalImageKey @"UIImagePickerControllerOriginalImage"

@interface EditPrivateAlbumViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate, CommonRequestOperatorDelegate> {
    CGRect _orgTableViewFrame;
}
@property (nonatomic, strong) CommonRequestOperator *requestOperator;
@end

@implementation EditPrivateAlbumViewController

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
    self.loadingView = [[LoadingView alloc] init];
    [self setupTextView];
    if(!self.item) {
        //新增
        [self addAction:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
    // 添加键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _orgTableViewFrame = self.scrollView.frame;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancel];
    [self closeKeyBoard];
    self.scrollView.frame = _orgTableViewFrame;
    // 去除键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (void)closeKeyBoard {
    [self.textView resignFirstResponder];
}
- (IBAction)sendAction:(id)sender {
    [self closeKeyBoard];
    self.item.desc = self.textView.text;
    [self submitPrivateAlbum];
}
- (void)addAction:(id)sender {
    UIActionSheet* sheet = [[UIActionSheet alloc] init];
    sheet.delegate = self;
    [sheet addButtonWithTitle:NSLocalizedString(@"PhotoAlbumn", nil)];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [sheet addButtonWithTitle:NSLocalizedString(@"Camera", nil)];
    }
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"PersonalAlbumn", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *barButtonItem = nil;
    UIButton *button = nil;
    UIImage *image = nil;
    
    // TODO:右边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 发送按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundGreen ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [button addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundGreenC ofType:@"png"]];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.rightBarButtonItems = array;
}
- (void)setupTextView {
    self.textView.alpha = ((self.item != nil) ? 1.0f : 0.0f);
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
}
// 界面加载数据
- (void)reloadData {
    if(self.item) {
        [self.imageView setImage:[UIImage imageWithData:self.item.data]];
        self.textView.text = self.item.desc;

        // 创建image
        UIImage *image = nil;
        if(self.item.data) {
            // 有图片
            image = [UIImage imageWithData:self.item.data];
        }
        else {
            // 只有id无图片
            image = [RequestImageView placeholderDefaultImage];
        }
    }
    self.textView.alpha = ((self.item != nil) ? 1.0f : 0.0f);
}
// 等比缩小（返回：缩小后的size，objectSize：要时行缩小的object size，frameSize：限定Size）
- (CGSize)getFitSize:(CGSize)objectSize frameSize:(CGSize)frameSize
{
    if (objectSize.width <= frameSize.width
        && objectSize.height <= frameSize.height)
    {
        return objectSize;
    }
    
    CGSize result = objectSize;
    // 以比例大的边为缩小基准
    if (objectSize.width / frameSize.width <= objectSize.height / frameSize.height) {
        // 以高为缩小基准
        CGFloat scale = objectSize.width / objectSize.height;
        result.height = frameSize.height;
        result.width = frameSize.width * scale;
    }
    else {
        // 以宽为缩小基准
        CGFloat scale = objectSize.height / objectSize.width;
        result.width = frameSize.width;
        result.height = frameSize.height * scale;
    }
    return result;
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 淡出UIImagePickerController
    [picker dismissModalViewControllerAnimated:YES];
    
    PrivateAlbumForSent *aItem = [[PrivateAlbumForSent alloc] init];
    aItem.status = OperateStatus_New;
    aItem.desc = @"";
    
    UIImage *resizeImage = (UIImage*)[info objectForKey:ImagePickerOriginalImageKey];
    CGFloat scale = resizeImage.size.width / resizeImage.size.height;
    NSInteger maxSize = 1024.0f;
    if (scale > 1.0f){
        resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize, maxSize / scale) interpolationQuality:kCGInterpolationDefault];
    }
    else {
        resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize * scale, maxSize) interpolationQuality:kCGInterpolationDefault];
    }
    aItem.data = UIImageJPEGRepresentation(resizeImage, 0.3f);
    
    self.item = aItem;
    [self reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark - 弹出界面回调 (UIActionSheetDelegate)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex || 1 == buttonIndex){
        // 附件
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = (0 == buttonIndex ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera);
        
        [self.navigationController presentModalViewController:imagePickerController animated:YES];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 文本输入回调 (UITextFieldDelegate)
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
}
- (void)textViewDidEndEditing:(UITextView *)textView {
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
}
#pragma mark - 处理键盘回调
- (void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:duration];
    if(height > 0) {
        self.scrollView.frame = CGRectMake(_orgTableViewFrame.origin.x, _orgTableViewFrame.origin.y - height, _orgTableViewFrame.size.width, _orgTableViewFrame.size.height);
    }
    else {
        self.scrollView.frame = _orgTableViewFrame;
    }
    //动画结束
    [UIView commitAnimations];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}
#pragma mark - 协议请求
- (void)cancel {
    [self.loadingView hideLoading:YES];
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }

}
- (BOOL)submitPrivateAlbum {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[CommonRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    if(!self.item) {
        return NO;
    }
    
    [self.loadingView showLoading:self.view animated:YES];
    
    NSMutableArray* sendArray = [NSMutableArray arrayWithObjects:self.item, nil];
    return [self.requestOperator submitUserAlbum:sendArray];
}
#pragma mark - CommonRequestOperatorDelegate
- (void)requestFinish:(id)data requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestFail:(NSString*)error requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:error];
}

@end
