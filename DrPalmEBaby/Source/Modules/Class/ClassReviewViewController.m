//
//  ClassReviewViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-12.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassReviewViewController.h"

#import "ClassReviewSelectorCell.h"
#import "ClassReviewTxtEditCell.h"

#import "ClassCommonDef.h"

@interface ClassReviewViewController () <ClassRequestOperatorDelegate, KKRankSelectorDelegete> {
    CGRect _orgTableViewFrame;
}
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSMutableArray *itemDraftArray;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation ClassReviewViewController

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
    [self setupTableView];
    self.itemDraftArray = [NSMutableArray array];
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
    [self cancel];
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
    titleLabel.text = NSLocalizedString(@"ClassReviewNavigationTitle", nil);
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
- (void)setupTableView {
    self.tableView.backgroundView = nil;
}
- (void)reloadData:(BOOL)isReloadView {
    NSMutableArray *sectionArray = [NSMutableArray array];
    
    // section 1
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    self.itemArray = [ClassDataManager reviewTempWithEventID:self.item.event_id];
    for(int i = 0; i<self.itemArray.count; i++) {
        ClassEventReviewTemp *item = [self.itemArray objectAtIndex:i];
        if([item.type isEqualToString:ReviewTypeCount]) {
            // 评分
            dictionary = [NSMutableDictionary dictionary];
            viewSize = CGSizeMake(_tableView.frame.size.width, [ClassReviewSelectorCell cellHeight]);
            rowSize = [NSValue valueWithCGSize:viewSize];
            [dictionary setValue:rowSize forKey:ROW_SIZE];
            [array addObject:dictionary];
        }
        else if([item.type isEqualToString:ReviewTypeText]) {
            // 文本
            dictionary = [NSMutableDictionary dictionary];
            viewSize = CGSizeMake(_tableView.frame.size.width, [ClassReviewTxtEditCell cellHeight]);
            rowSize = [NSValue valueWithCGSize:viewSize];
            [dictionary setValue:rowSize forKey:ROW_SIZE];
            [array addObject:dictionary];
        }
        
        ReviewDraft *draft = nil;
        if(i < self.itemDraftArray.count) {
            draft = [self.itemDraftArray objectAtIndex:i];
        }
        else {
            draft = [[ReviewDraft alloc] init];
            [self.itemDraftArray addObject:draft];
        }
        
        draft.itemID = item.itemID;
        draft.title = item.name;
        draft.type = item.type;
        if(draft.value.length == 0 && [item.type isEqualToString:ReviewTypeCount]) {
            draft.value = [NSString stringWithFormat:@"%d", [item.iDefault integerValue] - 1];
        }
    }
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
}
- (void)viewToData {
}
- (BOOL)inputCheck {
    // 检查输入
    BOOL bReturn = YES;
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
    return number;
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
        
        if(indexPath.row < self.itemArray.count && self.itemDraftArray.count) {
            ClassEventReviewTemp *item = [self.itemArray objectAtIndex:indexPath.row];
            ReviewDraft *draft = [self.itemDraftArray objectAtIndex:indexPath.row];

            if([item.type isEqualToString:ReviewTypeCount]) {
                // 评分
                ClassReviewSelectorCell *cell = [ClassReviewSelectorCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = item.name;
                cell.kkRankSelector.numberOfRank = [item.iMax integerValue];
                cell.kkRankSelector.curRank = [draft.value integerValue];
                cell.kkRankSelector.delegate = self;
                cell.kkRankSelector.tag = indexPath.row;
                
            }
            else if([item.type isEqualToString:ReviewTypeText]) {
                // 文本
                ClassReviewTxtEditCell *cell = [ClassReviewTxtEditCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = item.name;
                cell.textField.placeholder = NSLocalizedString(@"请输入", nil);
                cell.textField.tag = indexPath.row;
                cell.textField.delegate = self;
            }
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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger tag = textField.tag;
    if(tag < self.itemDraftArray.count) {
        ReviewDraft *item = [self.itemDraftArray objectAtIndex:tag];
        item.value = textField.text;
    }
    [self viewToData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
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
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.itemArray.count - 1  inSection:self.sectionArray.count - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    [self.loadingView showLoading:self.view animated:YES];
    
    return [self.self.requestOperator submitEventReview:self.itemDraftArray eventID:self.item.event_id];
}
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"AdviceSucceed", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
    [alert show];
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    NSString* tips = [NSString stringWithFormat:@"%@,%@",NSLocalizedString(@"AdviceFailed", nil),error];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:tips delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil,nil];
    [alert show];
}
#pragma mark - 选择评分
- (void)didChangeRank:(KKRankSelector *)kkRankSelector curRank:(NSInteger)curRank {
    ReviewDraft *draft = [self.itemDraftArray objectAtIndex:kkRankSelector.tag];
    draft.value = [NSString stringWithFormat:@"%d", curRank + 1];
}
@end
