//
//  PutConsultViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-12.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "PutConsultViewController.h"

#import "CommonLabelTableViewCell.h"
#import "CommonDynamicLabelTableViewCell.h"
#import "CommonTableViewCell.h"

#import "ContactTableViewCell.h"
#import "ClassNewEventContentCell.h"
#import "SchoolRequestOperator.h"

typedef enum {
    RowTypeName = 0,
    RowTypeContact,
    RowTypeEmail,
    RowTypeTitle,
    RowTypeContent,
} RowType;

@interface PutConsultViewController () <SchoolRequestOperatorDelegete> {
    CGRect _orgTableViewFrame;
}
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, retain) SchoolRequestOperator *requestOperator;
@end

@implementation PutConsultViewController

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
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
    
    // 添加键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _orgTableViewFrame = self.tableView.frame;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self closeKeyBoard];
    self.tableView.frame = _orgTableViewFrame;
    // 去除键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    titleLabel.text = NSLocalizedString(@"SchoolPrincipalMailbox", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    // TODO:右边按钮
    NSMutableArray *array = [NSMutableArray array];
    
    UIBarButtonItem *barButtonItem = nil;
    UIButton *button = nil;
    UIImage *image = nil;
    
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
- (void)reloadData:(BOOL)isReloadView {
    NSMutableArray *sectionArray = [NSMutableArray array];
    // section 1
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    // 您的称呼
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [ContactTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeName] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    // section 2
    array = [NSMutableArray array];
    // 联系方式
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [ContactTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeContact] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    // section 3
    array = [NSMutableArray array];
    // 电子邮箱
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [ContactTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeEmail] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    // section 4
    array = [NSMutableArray array];
    // 留言主题
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [ContactTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeTitle] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    // section 5
    array = [NSMutableArray array];
    // 意见反馈
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [ClassNewEventContentCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeContent] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    self.sectionArray = sectionArray;
    
    if(isReloadView) {
        [self.tableView reloadData];
    }
}
- (IBAction)sendAction:(id)sender {
    [self closeKeyBoard];
    [self viewToData];
    if([self inputCheck]) {
        [self submitAdvice];
    }
}
- (void)closeKeyBoard {
    [self.textFieldName resignFirstResponder];
    [self.textFieldPhone resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldTitle resignFirstResponder];
    [self.textView resignFirstResponder];
}
- (void)viewToData {
    if(self.textFieldName) {
        self.contactName = self.textFieldName.text;
    }
    if(self.textFieldPhone) {
        self.contactPhone = self.textFieldPhone.text;
    }
    if(self.textFieldEmail) {
        self.contactEmail = self.textFieldEmail.text;
    }
    if(self.textFieldTitle) {
        self.contactTitle = self.textFieldTitle.text;
    }
    if(self.textView) {
        self.contactContent = self.textView.text;
    }
}
- (BOOL)inputCheck {
    // 检查输入
    BOOL bReturn = YES;

    if(self.contactName.length == 0) {
        bReturn = NO;
        self.contactNameEmpty = YES;
    }
    if(self.contactPhone.length == 0) {
        bReturn = NO;
        self.contactPhoneEmpty = YES;
    }
    if(self.contactContent.length == 0) {
        bReturn = NO;
        self.contactContentEmpty = YES;
    }
    [self reloadData:YES];
    
    return bReturn;
}
#pragma mark - (列表界面回调)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int number = 0;
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        number = self.sectionArray.count;
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat number = 0;
    switch (section) {
        case 0:{
            // 您的称呼
            CGSize contentSize = [NSLocalizedString(@"ContactTips", nil) sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(tableView.frame.size.width - 2 * 15, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            number = contentSize.height + 30;
        }break;
        case 4:{
            // 留言内容
            number = 32;
        }break;
        default:break;
    }
    return number;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    switch (section) {
        case 0:{
            // 联系方式
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, tableView.frame.size.width - 2 * 15, 44)];
            
            label.text = NSLocalizedString(@"ContactTips", nil);
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:13];
            [label sizeToFit];
            
            UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, label.frame.size.height + 30)];
            [containView addSubview:label];
            containView.backgroundColor = [UIColor clearColor];
            view = containView;
        }break;
        case 4:{
            // 留言内容
            UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 32)];
            containView.backgroundColor = [UIColor clearColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width - 2 * 20, 32)];
            [containView addSubview:label];
            
            label.backgroundColor = [UIColor clearColor];
            label.text = NSLocalizedString(@"ContactContentTitle", nil);
            [label sizeToFit];
            
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:TextFieldWarnningIcon ofType:@"png"]];;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [containView addSubview:imageView];
            [imageView sizeToFit];
            imageView.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + 10, label.frame.origin.y, 16, 16);
            view = containView;
        }break;
        default:break;
    }
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if([tableView isEqual:self.tableView]) {
        NSArray *array = [self.sectionArray objectAtIndex:section];
        number = array.count;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if([tableView isEqual:self.tableView]) {
        NSArray *array = [self.sectionArray objectAtIndex:indexPath.section];
        NSDictionary *dictionarry = [array objectAtIndex:indexPath.row];
        CGSize viewSize;
        NSValue *value = [dictionarry valueForKey:ROW_SIZE];
        [value getValue:&viewSize];
        height = viewSize.height;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        NSArray *array = [self.sectionArray objectAtIndex:indexPath.section];
        NSDictionary *dictionarry = [array objectAtIndex:indexPath.row];
        
        // TODO:大小
        CGSize viewSize;
        NSValue *value = [dictionarry valueForKey:ROW_SIZE];
        [value getValue:&viewSize];
        
        // TODO:类型
        RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
        switch (type) {
            case RowTypeName:{
                // 您的称呼
                ContactTableViewCell *cell = [ContactTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"ContactName", nil);
                cell.textField.placeholder = NSLocalizedString(@"ContactNamePlaceholder", nil);
                cell.textField.delegate = self;
                cell.textField.tag = RowTypeName;
                if(self.contactName.length > 0) {
                    cell.textField.text = self.contactName;
                }
                self.textFieldName = cell.textField;
                
                // 错误提示图片
                cell.warningImageView.hidden = NO;
                if(self.contactNameEmpty) {
                    cell.wrongImageView.hidden = NO;
                    
                }
                self.textFieldNameWrongImageView = cell.wrongImageView;
            }break;
            case RowTypeContact:{
                // 联系电话
                ContactTableViewCell *cell = [ContactTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"ContactPhone", nil);
                cell.textField.placeholder = NSLocalizedString(@"ContactPhonePlaceholder", nil);
                cell.textField.delegate = self;
                cell.textField.tag = RowTypeContact;
                if(self.contactPhone.length > 0) {
                    cell.textField.text = self.contactPhone;
                }
                self.textFieldPhone = cell.textField;
                
                // 错误提示图片
                cell.warningImageView.hidden = NO;
                if(self.contactPhoneEmpty) {
                    cell.wrongImageView.hidden = NO;
                }
                self.textFieldPhoneWrongImageView = cell.wrongImageView;
            }break;
            case RowTypeEmail:{
                // 电子邮箱
                ContactTableViewCell *cell = [ContactTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"ContactEmail", nil);
                cell.textField.placeholder = NSLocalizedString(@"ContactEmailPlaceholder", nil);
                cell.textField.delegate = self;
                cell.textField.tag = RowTypeEmail;
                if(self.contactEmail.length > 0) {
                    cell.textField.text = self.contactEmail;
                }
                self.textFieldEmail = cell.textField;
            }break;
            case RowTypeTitle:{
                // 留言主题
                ContactTableViewCell *cell = [ContactTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"ContactTitle", nil);
                cell.textField.placeholder = NSLocalizedString(@"ContactTitlePlaceholder", nil);
                cell.textField.delegate = self;
                cell.textField.tag = RowTypeTitle;
                if(self.contactTitle.length > 0) {
                    cell.textField.text = self.contactTitle;
                }
                self.textFieldTitle = cell.textField;
            }break;
            case RowTypeContent:{
                // 留言内容
                ClassNewEventContentCell *cell = [ClassNewEventContentCell getUITableViewCell:tableView];
                result = cell;
                
                cell.textView.delegate = self;
                cell.textView.tag = RowTypeContent;
                if(self.contactContent.length > 0) {
                    cell.textView.text = self.contactContent;
                }
                self.textView = cell.textView;
                
                // 错误提示图片
                if(self.contactContentEmpty) {
                    cell.wrongImageView.hidden = NO;
                    self.textViewWrongImageView = cell.wrongImageView;
                }
            }break;
            default:break;
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - AlertViewDelegete
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 0)
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}
#pragma mark - 文本输入回调 (UITextViewDelegate)
- (void)textViewDidChange:(UITextView *)textView {
    if(textView.text.length > 0) {
        self.contactContentEmpty = NO;
        self.textViewWrongImageView.hidden = YES;
    }
    [self viewToData];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#define TEXTVIEW_HEIGHT   100
#define KEYBOART_HEIGHT  230

#pragma mark - 文本输入回调 (UITextFieldDelegate)
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect rect = self.tableView.frame;
//    rect.size.height -= KEYBOART_HEIGHT + TEXTVIEW_HEIGHT - 80;// + textView.inputAccessoryView.frame.size.height;
//    self.tableView.frame = rect;
//    
//    if(textField.tag == RowTypeName)
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:RowTypeName] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    else if(textField.tag == RowTypeEmail)
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:RowTypeEmail] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    else if(textField.tag == RowTypeTitle)
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:RowTypeTitle] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    else if(textField.tag == RowTypeContent)
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:RowTypeContent] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    CGRect rect = self.tableView.frame;
//    rect.size.height += KEYBOART_HEIGHT+TEXTVIEW_HEIGHT - 80;// + textView.inputAccessoryView.frame.size.height + 20;
//    self.tableView.frame = rect;
    
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.contactNameEmpty = NO;
    self.contactPhoneEmpty = NO;
    self.textFieldNameWrongImageView.hidden = YES;
    self.textFieldPhoneWrongImageView.hidden = YES;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self viewToData];
//    switch (textField.tag) {
//        case RowTypeName:{
//            self.contactName = textField.text;
//        }break;
//        case RowTypeContact:{
//            self.contactPhone = textField.text;
//        }break;
//        case RowTypeEmail:{
//            self.contactEmail = textField.text;
//        }
//        case RowTypeTitle:{
//            self.contactTitle = textField.text;
//        }break;
//        default:
//            break;
//    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self closeKeyBoard];
    return YES;
}
#pragma mark - 处理键盘回调
- (void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:duration];
    if(height > 0) {
        self.tableView.frame = CGRectMake(_orgTableViewFrame.origin.x, _orgTableViewFrame.origin.y, _orgTableViewFrame.size.width, _orgTableViewFrame.size.height - height);
    }
    else {
        self.tableView.frame = _orgTableViewFrame;
    }
    //动画结束
    [UIView commitAnimations];
//    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
- (BOOL)submitAdvice {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[SchoolRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    [self.loadingView showLoading:self.view animated:YES];
    
    return [self.self.requestOperator submitConsult:self.contactName email:self.contactEmail phone:self.contactPhone title:self.contactTitle
                              content:self.contactContent type:SUBMITCONSULT_TYPE_CONSULT];
}
- (void)operateFinish:(id)data requestType:(SchoolRequestOperatorStatus)type {
    [self cancel];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"AdviceSucceed", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
    [alert show];
}
- (void)operateFail:(NSString*)error requestType:(SchoolRequestOperatorStatus)type {
    [self cancel];
    NSString* tips = [NSString stringWithFormat:@"%@,%@",NSLocalizedString(@"AdviceFailed", nil),error];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:tips delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil,nil];
    [alert show];
}
@end
