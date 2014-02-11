//
//  CommunicateDetailViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommunicateDetailViewController.h"
#import "CommunicateDataManager.h"
#import "ClassRequestOperator.h"

#import "CommentCell.h"
#import "CommentCell2.h"

@interface CommunicateDetailViewController () <ClassRequestOperatorDelegate, RequestImageViewDelegate> {
    BOOL _reloading;
    
    CGRect _orgTableViewFrame;
    CGRect _orgToolBarFrame;
}
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation CommunicateDetailViewController
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
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 添加键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _orgTableViewFrame = self.tableView.frame;
    _orgToolBarFrame = self.toolBar.frame;
    
    [self loadFromServer];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancel];
    [self closeKeyBoard];
    // 去除键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView.delegate = nil;
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
    titleLabel.text = NSLocalizedString(@"CommunicateDetailNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (IBAction)sendAction:(id)sender {
    [self closeKeyBoard];
    if(self.textField.text.length > 0) {
        [self sendAnswer];
    }
    else {
        // show error tips here
    }
}
- (void)reloadData:(BOOL)isReloadView {
    self.item = [CommunicateDataManager manWithId: self.item.contact_id];
    self.itemArray = [CommunicateDataManager contentListWithManId:self.item.contact_id];
    if(isReloadView) {
        [self.tableView reloadData];
        if(self.itemArray.count > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.itemArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}
- (void)closeKeyBoard {
    [self.textField resignFirstResponder];
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = self.item.contactName;
    return title;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 1;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    number = self.itemArray.count;
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    CommunicateList *item = [self.itemArray objectAtIndex:indexPath.row];
    height = [CommentCell cellHeight:tableView content:item.body];
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if(indexPath.row < self.itemArray.count) {
        
        CommunicateList *preContent = nil;
        CommunicateList *item = [self.itemArray objectAtIndex:indexPath.row];
        
        NSString *name = [[LoginManagerInstance() accountName] lowercaseString];
        NSString *sender = [item.send_cid lowercaseString];
        
        if(![sender isEqualToString:name]) {
            // TODO:发送人不是自己
            CommentCell *cell = [CommentCell getUITableViewCell:tableView];
            result = cell;
            
            // 时间
            if(indexPath.row > 0){
                preContent = [self.itemArray objectAtIndex:indexPath.row - 1];
                NSTimeInterval interval = [item.lastupdate timeIntervalSinceDate:preContent.lastupdate];
                if(interval > 60.0){
                    NSString *dateString = [item.lastupdate toStringYMDHM];
                    cell.labelTime.text = dateString;
                }
                else {
                    cell.labelTime.text = @"";
                }
            }
            cell.labelContent.text = item.body;
            
            cell.requestImageView.contentType = self.item.headImage.contentType;
            cell.requestImageView.imageUrl = self.item.headImage.path;
            cell.requestImageView.imageData = self.item.headImage.data;
            cell.requestImageView.delegate = self;
            [cell.requestImageView loadImage];
        }
        else {
            CommentCell2 *cell = [CommentCell2 getUITableViewCell:tableView];
            result = cell;
            
            // 时间
            if(indexPath.row > 0){
                preContent = [self.itemArray objectAtIndex:indexPath.row - 1];
                NSTimeInterval interval = [item.lastupdate timeIntervalSinceDate:preContent.lastupdate];
                if(interval > 60.0){
                    NSString *dateString = [item.lastupdate toStringYMDHM];
                    cell.labelTime.text = dateString;
                }
                else {
                    cell.labelTime.text = @"";
                }
            }
            cell.labelContent.text = item.body;
            
            cell.requestImageView.imageUrl = UserInfoManagerInstance().userInfo.headimage.url;
            cell.requestImageView.imageData = UserInfoManagerInstance().userInfo.headimage.data;
            cell.requestImageView.delegate = self;
            [cell.requestImageView loadImage];
        }
    }
    return result;
}
#pragma mark - (输入栏回调)
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
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
    //    UIView *navView = self.navigationController.view;
    //    UIToolbar *toolBar = self.navigationController.toolbar;
    
    if(height > 0) {
        //        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, 0, self.tableView.frame.size.width, self.view.frame.size.height - height);
        //self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, 0-height, self.tableView.frame.size.width, self.view.frame.size.height);
        self.tableView.frame = CGRectMake(_orgTableViewFrame.origin.x, _orgTableViewFrame.origin.y, _orgTableViewFrame.size.width, _orgTableViewFrame.size.height - height);
        self.toolBar.frame = CGRectMake(_orgToolBarFrame.origin.x, _orgToolBarFrame.origin.y - height, _orgToolBarFrame.size.width, _orgToolBarFrame.size.height);
    }
    else {
        //        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, 0, self.tableView.frame.size.width, self.view.frame.size.height);
        self.tableView.frame = _orgTableViewFrame;
        self.toolBar.frame = _orgToolBarFrame;
    }
    //    self.navigationController.toolbar.frame = CGRectMake(toolBar.frame.origin.x, navView.frame.size.height - toolBar.frame.size.height - height, toolBar.frame.size.width, toolBar.frame.size.height);
    //    self.navigationController.view.frame = CGRectMake(fullFrame.origin.x, fullFrame.origin.y - height, fullFrame.size.width, fullFrame.size.height);
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
    if(self.itemArray.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.itemArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}
#pragma mark - 异步下载图片控件回调
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    CommunicateFile *file = [CommunicateDataManager fileWithUrl:imageView.imageUrl isLocal:NO];
    if(file) {
        file.data = imageView.imageData;
        file.contentType = imageView.contentType;
        [CoreDataManager saveData];
        [self reloadData:NO];
    }
}
- (UIImage *)imageForDefault:(RequestImageView *)imageView {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ClassCommentHeadDefaultImage ofType:@"png"]];
    return image;
}
#pragma mark - 协议请求
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
        self.requestOperator = nil;
    }
}
- (BOOL)loadFromServer {
    // TODO:取回复内容列表
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    NSInteger lastupdate = 0;
    if(self.itemArray.count > 0)
    {
        CommunicateList* content = [self.itemArray lastObject];
        lastupdate = [content.lastupdate timeIntervalSince1970];
    }
    return [self.requestOperator getContactMsgs:self.item.contact_id lastupdate:lastupdate];
}

- (BOOL)sendAnswer {
    // TODO:反馈发送
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    return [self.requestOperator sentContactMsg:self.item.contact_id body:self.textField.text];
}
#pragma mark - 协议回调 (ClassRequestOperatorDelegate)
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case Classrequestoperator_SendContactMsgs: {
            self.textField.text = @"";
            [self loadFromServer];
        }break;
        case ClassRequestOperator_GetContactMsgs: {
            [self reloadData:YES];
        }break;
        default:break;
    }
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case Classrequestoperator_SendContactMsgs: {
            [self setTopStatusText:error];
        }break;
        case ClassRequestOperator_GetContactMsgs: {
            [self setTopStatusText:error];
        }break;
        default:break;
    }
}

@end
