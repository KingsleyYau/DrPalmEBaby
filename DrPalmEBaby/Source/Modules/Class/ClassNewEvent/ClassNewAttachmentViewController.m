//
//  ClassNewAttachmentViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-7.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassNewAttachmentViewController.h"

#define AttachmentsLimit            (15)
#define UnselectedDefaultValue      (-1)
#define CarouselHeightPercent       (0.7f)
#define CarouselItemWidthPercen     (0.8f)
#define ImagePickerReferenceURLKey  @"UIImagePickerControllerReferenceURL"
#define ImagePickerOriginalImageKey @"UIImagePickerControllerOriginalImage"

@implementation ClassAttachmentItem
@end

@interface ClassNewAttachmentViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, iCarouselDataSource, iCarouselDelegate, UITextFieldDelegate, UITextViewDelegate> {
    CGRect _orgTableViewFrame;
}

@end

@implementation ClassNewAttachmentViewController

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
    [self setupTextView];
    [self setupCarousel];
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
- (IBAction)addAction:(id)sender {
    [self closeKeyBoard];
    if ([self.attachments count] < AttachmentsLimit) {
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
    else {
        // 已经超过最大限制
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:NSLocalizedString(@"ClassAttachmentOverLimit", nil)
                                                        delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil)
                                               otherButtonTitles:nil];
        [alert show];
    }
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"ClassNewAttachmentNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *barButtonItem = nil;
    UIButton *button = nil;
    UIImage *image = nil;
    
    // TODO:右边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 新增按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundGreen ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundGreenC ofType:@"png"]];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.rightBarButtonItems = array;
}
- (void)setupTextView {
    self.textView.alpha = ([self.attachments count] > 0 ? 1.0f : 0.0f);
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
}
- (void)setupCarousel {
    self.carousel.type = iCarouselTypeCoverFlow;
    self.carousel.decelerationRate = 0.3f;
}
- (void)updateTitleLabelContent {
    // 更新标题Label内容
    NSString* titleString = [NSString stringWithFormat:@"%d / %d", [self.attachments count], AttachmentsLimit];
    self.titleLabel.text = titleString;
}
- (void)textViewToAttachmentDesc:(NSInteger)index {
    // 描述框内容填入附件中
    if (0 <= index && index < [self.attachments count]) {
        ClassAttachmentItem* item = [self.attachments objectAtIndex:index];
        item.desc = [self.textView.text copy];
    }
}
- (void)attachmentDescToTextView:(NSInteger)index {
    // 附件描述填入描述框中
    if (0 <= index && index < [self.attachments count]) {
        ClassAttachmentItem* item = [self.attachments objectAtIndex:index];
        self.textView.text = [item.desc copy];
    }
}
// 界面加载数据
- (void)reloadData {
    [self.carousel reloadData];
    [self updateTitleLabelContent];
    
    if(self.attachments.count > 0) {
        self.textView.alpha = 1.0;
        if(self.selectedIndex == 0) {
            [self attachmentDescToTextView:0];
        }
    }
    else {
        self.textView.alpha = 0;
    }
}
// 创建空白图片
- (void)createEmptyImage {
    
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
#pragma mark - iCarouselDataSource
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.attachments count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    // itemView大小
    NSInteger itemWidth = carousel.bounds.size.width * CarouselItemWidthPercen;
    
    // 创建image
    ClassAttachmentItem* item = [self.attachments objectAtIndex:index];
    UIImage* image = nil;
    if(item.data) {
        // 有图片
        image = [UIImage imageWithData:item.data];
    }
    else {
        // 只有id无图片
        image = [RequestImageView placeholderDefaultImage];
    }
    
    // 等比缩小
    CGSize transImageSize = [self getFitSize:image.size frameSize:CGSizeMake(itemWidth, itemWidth)];
    
    // 创建itemView
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, transImageSize.width, transImageSize.height)];
    
    // 创建imageView
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, transImageSize.width, transImageSize.height);
    [itemView addSubview:imageView];
    
    // 创建deleteButton
    UIButton* deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:DeleteIconButton ofType:@"png"]];
    [deleteButton setImage:buttonImage forState:UIControlStateNormal];
    // 删除按钮突出1/3
    const CGFloat deleteBtnOverSpace = 2.0f/3.0f;
    NSInteger deleteBtnLeft = itemView.bounds.size.width - (buttonImage.size.width * deleteBtnOverSpace);
    NSInteger deleteBtnTop = 0 - (buttonImage.size.height * (1 - deleteBtnOverSpace));
    deleteButton.frame = CGRectMake(deleteBtnLeft, deleteBtnTop, buttonImage.size.width, buttonImage.size.height);
    [itemView addSubview:deleteButton];
    [itemView bringSubviewToFront:deleteButton];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tag = (NSInteger)index;
    
    return itemView;
}

#pragma mark - iCarouselDelegate
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    [self textViewToAttachmentDesc:self.selectedIndex];
    [self attachmentDescToTextView:carousel.currentItemIndex];
    self.selectedIndex = carousel.currentItemIndex;
}

#pragma mark - Action
// 删除附件
- (void)deleteAction:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton* deleteButton = (UIButton*)sender;
        ClassAttachmentItem *item = [self.attachments objectAtIndex:deleteButton.tag];
        [self.attachments removeObject:item];
        
        [self reloadData];
    }
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
    
    // 判断附件是否已经存在 {
    BOOL exist = NO;
    NSURL *imageReferenceURL = [info objectForKey:ImagePickerReferenceURLKey];
    for (ClassAttachmentItem *item in _attachments) {
        if ([item.url isEqualToString:[imageReferenceURL relativeString]]){
            exist = YES;
            break;
        }
    }
    
    if (!exist){
        ClassAttachmentItem *item = [[ClassAttachmentItem alloc] init];
        // camera
        if(UIImagePickerControllerSourceTypeCamera == picker.sourceType) {
            NSLog(@"%@", [info objectForKey:UIImagePickerControllerMediaMetadata]);
            item.url = [[[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:@"{TIFF}"] objectForKey:@"DateTime"];
        }
        else {
            item.url = [[info objectForKey:ImagePickerReferenceURLKey] relativeString];
        }
        
        UIImage *resizeImage = (UIImage*)[info objectForKey:ImagePickerOriginalImageKey];
        CGFloat scale = resizeImage.size.width / resizeImage.size.height;
        NSInteger maxSize = 1024.0f;
        if (scale > 1.0f){
            resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize, maxSize / scale) interpolationQuality:kCGInterpolationDefault];
        }
        else {
            resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize * scale, maxSize) interpolationQuality:kCGInterpolationDefault];
        }
        item.data = UIImageJPEGRepresentation(resizeImage, 0.3f);
        item.type = @"jpg";
        [_attachments addObject:item];
        
        [self reloadData];
    }
    else{
        // 附件已经存在
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:NSLocalizedString(@"ClassAttachmentExists", nil)
                                                        delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil)
                                               otherButtonTitles:nil];
        [alert show];
    }
//    // 先保存当前在编辑的图片
//    [self textViewToAttachmentDesc:self.selectedIndex];
    // 重新加载
    [self reloadData];
    [self.carousel scrollToItemAtIndex:self.attachments.count animated:YES];
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
    [self textViewToAttachmentDesc:self.selectedIndex];
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
@end
