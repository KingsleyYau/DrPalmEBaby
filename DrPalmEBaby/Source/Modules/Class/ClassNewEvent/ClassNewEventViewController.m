//
//  ClassNewEventViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassNewEventViewController.h"
#import "ClassEventOrgViewController.h"


#import "ClassCommonDef.h"

#import "ClassNewEventOperatorCell.h"
#import "ClassNewEventTypeCell.h"
#import "ClassNewEventTitleEditCell.h"
#import "ClassNewEventReceiverCell.h"
#import "ClassNewEventLocationEditCell.h"
#import "ClassNewEventContentCell.h"
#import "ClassNewEventAttachmentTableViewCell.h"


#import "ClassCreateOrgHandler.h"

#define ActionSheetEventOperationTag   10001
#define ActionSheetEventTypeTag        (ActionSheetEventOperationTag + 1)

typedef enum {
    RowTypeEventOperation,
    RowTypeEventType,
    RowTypeEventTitle,
    RowTypeEventReceiver,
    RowTypeEventLocation,
    RowTypeEventContent,
    RowTypeEventAttachment,
} RowType;

@interface ClassNewEventViewController () <ClassRequestOperatorDelegate, ClassEventOrgTableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate>{
    CGRect _orgTableViewFrame;
    
    NSInteger  _cancelBtnIndex;
    NSInteger  _reSendBtnIndex;
    NSInteger  _replaceBtnIndex;
}
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSArray *categoriesArray;
@property (nonatomic, strong) ClassRequestOperator *requestOperator;
@end

@implementation ClassNewEventViewController
- (void)dealloc {
    NSLog(@"ClassNewEventViewController dealloc");
}
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
    [self setupTableView];
    
    // 初始化 table view 数据
    [self EventDraftTrans2ViewData];
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
#pragma mark - 界面逻辑
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveAction:(id)sender {
    [self viewDataTrans2EventDraft];
    [self setTopStatusText:NSLocalizedString(@"SaveToDraftSuccess", nil)];
    [self backAction:nil];
}
- (IBAction)sendAction:(id)sender {
//    [self closeKeyBoard];
    [self viewDataTrans2EventDraft];
    if(NO == [self checkDraftData]){
        return;
    }
    [self submitEvent];
}
- (IBAction)emergentAction:(id)sender {
    _isEmergent = !_isEmergent;
    [self reloadData:YES];
}
- (void)closeKeyBoard {
    [self.titleTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"ClassNewEventNavigationTitle", nil);
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
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundGreenC ofType:@"png"]];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    // 保存按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlue ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlueC ofType:@"png"]];
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
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    // section 1
    array = [NSMutableArray array];
    
    // 转发/替换(已发通告进入才显示)
    if(nil != self.eventOriEventID) {
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [ClassNewEventOperatorCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeEventOperation] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }

    // 通告分类
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [ClassNewEventTypeCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeEventType] forKey:ROW_TYPE];
    [array addObject:dictionary];

    // 标题
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [ClassNewEventTitleEditCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeEventTitle] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 收件人
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [ClassNewEventReceiverCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeEventReceiver] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
//    // 地点
//    dictionary = [NSMutableDictionary dictionary];
//    viewSize = CGSizeMake(_tableView.frame.size.width, [ClassNewEventLocationEditCell cellHeight]);
//    rowSize = [NSValue valueWithCGSize:viewSize];
//    [dictionary setValue:rowSize forKey:ROW_SIZE];
//    [dictionary setValue:[NSNumber numberWithInteger:RowTypeEventLocation] forKey:ROW_TYPE];
//    [array addObject:dictionary];
    
    // 内容(相册分类不显示)
    if(![self.eventCategory.category_id isEqualToString:ClassCategoryIdAlbum]) {
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [ClassNewEventContentCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeEventContent] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }

    // 附件
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [ClassNewEventAttachmentTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeEventAttachment] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    self.itemArray = sectionArray;
    if(isReloadView) {
        [self.tableView reloadData];
    }
}
#pragma mark - 转发和替换
- (NSString*)eventOperationStringWithEventStatus:(NSString*)eventStatus
{
    EventStatusType statusType = [ClassDataManager eventStatusTypeWithStatusString:eventStatus];
    NSString *result = @"";
    switch (statusType) {
        case EventStatusType_Add:
            result = NSLocalizedString(@"Relay", nil);
            break;
        case EventStatusType_Cancel:
            result = NSLocalizedString(@"Replace", nil);
            break;
        case EventStatusType_Normal:
        default:
            break;
    }
    return result;
}
#pragma mark - 检查输入数据
- (BOOL)checkDraftData {
    BOOL bFlag = YES;
    NSString *errMsg;
    if(nil == self.eventDraft.addressees || 0 >= [self.eventDraft.addressees count]){
        bFlag = NO;
        errMsg = NSLocalizedString(@"ClassTipsAddress", nil);
    }
    else if(nil == self.eventDraft.title || 0 >= [self.eventDraft.title length]){
        bFlag = NO;
        errMsg = NSLocalizedString(@"ClassTipsTitle", nil);
    }
    else if([self.eventCategory.category_id isEqualToString:ClassCategoryIdAlbum]) {
        // 相册至少有一个附件
        if(self.eventDraft.attachments.count == 0) {
            bFlag = NO;
            errMsg = NSLocalizedString(@"ClassTipsAttachments", nil);
        }
    }
    else if(nil == self.eventDraft.body || 0 >= [self.eventDraft.body length]){
        // 普通内容不能为空
        bFlag = NO;
        errMsg = NSLocalizedString(@"ClassTipsContent", nil);
    }
    if(!bFlag){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    return bFlag;
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = self.itemArray.count;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    NSArray *array = [self.itemArray objectAtIndex:section];
    number = array.count;
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    
    NSArray *array = [self.itemArray objectAtIndex:indexPath.section];
    NSDictionary *dictionarry = [array objectAtIndex:indexPath.row];
    CGSize viewSize;
    NSValue *value = [dictionarry valueForKey:ROW_SIZE];
    [value getValue:&viewSize];
    height = viewSize.height;
    
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    NSArray *array = [self.itemArray objectAtIndex:indexPath.section];
    
    NSDictionary *dictionarry = [array objectAtIndex:indexPath.row];

    // TODO:类型
    RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
    switch (type) {
        case RowTypeEventOperation:{
            // 转发/替换(已发通告进入才显示)
            ClassNewEventOperatorCell *cell = [ClassNewEventOperatorCell getUITableViewCell:tableView];
            result = cell;
            cell.titleLabel.text = [self eventOperationStringWithEventStatus:self.eventOriStatus];
        }break;
        case RowTypeEventType:{
            // 通告分类
            ClassNewEventTypeCell *cell = [ClassNewEventTypeCell getUITableViewCell:tableView];
            result = cell;
            cell.titleLabel.text = ToLocalizedString(self.eventCategory.title);
        }break;
        case RowTypeEventTitle:{
            // 标题
            ClassNewEventTitleEditCell *cell = [ClassNewEventTitleEditCell getUITableViewCell:tableView];
            result = cell;
            
            cell.textField.placeholder = NSLocalizedString(@"Title", nil);
            self.titleTextField = cell.textField;
            self.titleTextField.delegate = self;
            if(self.eventTitle) {
                self.titleTextField.text = self.eventTitle;
            }
            
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ClassNewEventEmergentButton ofType:@"png"]];
            if(!_isEmergent) {
                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ClassNewEventUnEmergentButton ofType:@"png"]];
            }
            [cell.button setImage:image forState:UIControlStateNormal];
            [cell.button addTarget:self action:@selector(emergentAction:) forControlEvents:UIControlEventTouchUpInside];
        }break;
        case RowTypeEventReceiver:{
            // 收件人
            ClassNewEventReceiverCell *cell = [ClassNewEventReceiverCell getUITableViewCell:tableView];
            result = cell;
            
            if(self.eventAddrNames.count > 0) {
                NSMutableString *addressString = [NSMutableString string];
                for(NSString *value in self.eventAddrNames) {
                    [addressString appendFormat:@"%@;", value];
                }
                cell.titleLabel.text = addressString;
            }
            else {
                cell.titleLabel.text = NSLocalizedString(@"Receiver", nil);
            }
        }break;
        case RowTypeEventLocation:{
            // 地点
            ClassNewEventLocationEditCell *cell = [ClassNewEventLocationEditCell getUITableViewCell:tableView];
            result = cell;
            self.locationTextField = cell.textField;
            self.locationTextField.delegate = self;
            if(self.eventLocation) {
                self.locationTextField.text = self.eventLocation;
            }
        }break;
        case RowTypeEventContent:{
            // 内容
            ClassNewEventContentCell *cell = [ClassNewEventContentCell getUITableViewCell:tableView];
            result = cell;
            self.contentTextView = cell.textView;
            self.contentTextView.delegate = self;
            if(self.eventContent) {
                self.contentTextView.text = self.eventContent;
            }
        }break;
        case RowTypeEventAttachment:{
            // 附件
            ClassNewEventAttachmentTableViewCell *cell = [ClassNewEventAttachmentTableViewCell getUITableViewCell:tableView];
            result = cell;
            NSString *title = [NSString stringWithFormat:@"%@:%d", NSLocalizedString(@"Attachment", nil), [_eventAttachments count]];
            cell.titleLabel.text = title;
        }break;
        default:break;
    }
    
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = [self.itemArray objectAtIndex:indexPath.section];
    
    NSDictionary *dictionarry = [array objectAtIndex:indexPath.row];
    
    // TODO:类型
    RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
    switch (type) {
        case RowTypeEventOperation:{
            // 转发和替换
            UIActionSheet* sheet = [[UIActionSheet alloc] init];
            sheet.tag = ActionSheetEventOperationTag;
            sheet.delegate = self;
            
            _reSendBtnIndex = [sheet addButtonWithTitle:NSLocalizedString(@"Relay", nil)];
            if(self.isSendBySelf)
                _replaceBtnIndex = [sheet addButtonWithTitle:NSLocalizedString(@"Replace", nil)];
            _cancelBtnIndex = [sheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
            sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            [sheet showInView:self.view];
        }break;
        case RowTypeEventType:{
            // 分类
            UIActionSheet* sheet = [[UIActionSheet alloc] init];
            sheet.tag = ActionSheetEventTypeTag;
            sheet.delegate = self;
            
            if (0 == indexPath.row){
                // ClassEventCategory
                int index = 0;
                for(ClassEventCategory *eventCategory in [ClassDataManager canSendcategoryList]){
                    // 标题
                    [sheet addButtonWithTitle:ToLocalizedString(eventCategory.title)];
                    
                    // 红色按钮
                    if(self.eventCategory == eventCategory) {
                        sheet.destructiveButtonIndex = index;
                    }
                    index++;
                }
                sheet.cancelButtonIndex = [sheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
                sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                [sheet showInView:self.view];
            }
        }break;
        case RowTypeEventTitle:{
            
        }break;
        case RowTypeEventReceiver:{
            // 收件人
            UIStoryboard *storyBoard = AppDelegate().storyBoard;
            
            KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
            ClassEventOrgViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassEventOrgViewController"];
            vc.rootVC = self;
            vc.delegate = self;
            vc.parentOrgID = OrgTopDefaultValue;
            [vc initCheckedOrgs:self.eventAddressees];
            [nvc pushViewController:vc animated:YES gesture:NO];
        }break;
        case RowTypeEventLocation:{
            
        }break;
        case RowTypeEventContent:{
            
        }break;
        case RowTypeEventAttachment:{
            // 选择附件
            UIStoryboard *storyBoard = AppDelegate().storyBoard;
            
            KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
            ClassNewAttachmentViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ClassNewAttachmentViewController"];
            vc.attachments = self.eventAttachments;
            [nvc pushViewController:vc animated:YES gesture:NO];
        }break;
        default:break;
    }
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
#pragma mark - 加载界面(LoadingViewMethod)
- (void)showLoading {
    if(!self.loadingView) {
        self.loadingView = [[LoadingView alloc] init];
    }
    [self.loadingView showLoading:self.view animated:YES];
}

- (void)hideLoading {
    [self.loadingView hideLoading:NO];
}
#pragma mark - 读取草稿和存储草稿
- (void)viewDataTrans2EventDraft {
    // 如果正在编辑，则把键盘收起
    [self closeKeyBoard];

    if (nil == self.eventDraft){
        [ClassDataManager insertEventDraft];
        self.eventDraft = [ClassDataManager lastEventDraft];
    }
    
    self.eventDraft.startDate = self.eventStart;
    
    self.eventDraft.endDate = self.eventEnd;
    if(nil == self.eventLocation || [self.eventLocation isEqualToString:@""]){
        self.eventDraft.location = @"";
    }
    else{
        self.eventDraft.location = self.eventLocation;
    }

    self.eventDraft.orieventid = self.eventOriEventID ;
    self.eventDraft.oristatus = self.eventOriStatus;
    self.eventDraft.body = self.eventContent;
    self.eventDraft.title = self.eventTitle;
    self.eventDraft.ifshow = [NSNumber numberWithBool:_isEmergent];
    
    NSMutableSet *addresses = [NSMutableSet set];
    for (ClassOrg *checkOrg in _eventAddressees){
        [addresses addObject:checkOrg];
    }
    self.eventDraft.addressees = addresses;

    self.eventDraft.categories = nil;
    if(nil != self.eventCategory) {
        self.eventDraft.categories = [NSSet setWithObject:self.eventCategory];
    }
    
    self.eventDraft.lastUpdated = [NSDate date];
    
    [ClassDataManager removeEventDraftAttachment:self.eventDraft];
    for (ClassAttachmentItem *item in _eventAttachments){
        ClassEventDraftAttachment *draftAttachment = [ClassDataManager draftAttachmentWithDraftAndUrl:self.eventDraft url:item.url];
        draftAttachment.data = item.data;
        draftAttachment.type = item.type;
        draftAttachment.title = item.desc;
        draftAttachment.attid = item.attid;
    }
    
    [CoreDataManager saveData];
}
- (void)EventDraftTrans2ViewData {
    // 初始化分类
    self.categoriesArray = [ClassDataManager canSendcategoryList];
    if(nil == self.eventCategory && self.categoriesArray.count > 0) {
        self.eventCategory = [self.categoriesArray objectAtIndex:0];
    }
    // 初始化有效时间
    self.eventStart = [NSDate date];
    self.eventEnd = [[NSDate date] dateAfterMonth:3];
    
    self.isEmergent = NO;
    
    // 初始化附件
    if(!self.eventAttachments)
        self.eventAttachments = [NSMutableArray array];
    
    // 从草稿读取
    if (nil != self.eventDraft){
        NSMutableArray *addressArray = [NSMutableArray array];
        [addressArray addObjectsFromArray:[self.eventDraft.addressees allObjects]];
        self.eventAddressees = addressArray;
        
        self.eventStart = [_eventDraft.startDate copy];
        self.eventEnd = [_eventDraft.endDate copy];
        self.eventLocation = [_eventDraft.location copy];
        self.eventContent = [_eventDraft.body copy];
        self.eventCategory = [[_eventDraft.categories allObjects] lastObject];
        self.eventTitle = [self.eventDraft.title copy];
        self.eventOriEventID = [self.eventDraft.orieventid copy];
        self.eventOriStatus = self.eventDraft.oristatus;
        _isEmergent = [self.eventDraft.ifshow boolValue];
        
        for (ClassEventDraftAttachment *attachment in _eventDraft.attachments){
            ClassAttachmentItem *item = [[ClassAttachmentItem alloc] init];
            item.url = attachment.path;
            item.data = attachment.data;
            item.type = attachment.type;
            item.desc = attachment.title;
            item.attid = attachment.attid;
            [self.eventAttachments addObject:item];
        }
    }
    self.eventAddrNames = [self orgNamesWithOrg:self.eventAddressees];
}
- (NSMutableArray *)orgNamesWithOrg:(NSArray *)checkDataArray {
    NSMutableArray *result = [NSMutableArray array];
    for (ClassOrg *checkedData in checkDataArray){
        [result addObject:checkedData.orgName];
    }
    return result;
}
#pragma mark - 收件人选择界面回调 (EventOrgTableViewDelegate)
-(void)eventOrgConfirm:(NSMutableArray*)arrary {
    self.eventAddressees = [NSMutableArray arrayWithArray:arrary];
    self.eventAddrNames = [self orgNamesWithOrg:_eventAddressees];
    [self.tableView reloadData];
}
#pragma mark - 收件人回调 ClassCreateOrgHandlerDelegate
- (void)createOrgFinish:(ClassCreateOrgHandler*)handler {
    [self hideLoading];
}
- (void)createOrgFail:(ClassCreateOrgHandler*)handler {
    [self hideLoading];
}
#pragma mark - 导航栏回调
- (void)backAction {
    // 退出前提示保存
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"IsSaveDraft", nil)  message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
    [alertView show];
    return;
}
#pragma mark - 弹出对话框回调
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            // 取消
        }break;
        case 1:{
            // 确定
            [self viewDataTrans2EventDraft];
            [self setTopStatusText:NSLocalizedString(@"SaveToDraftSuccess", nil)];
        }break;
        default:
            break;
    }
    [self backAction:nil];
}
#pragma mark - 弹出界面回调 (UIActionSheetDelegate)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (ActionSheetEventOperationTag == actionSheet.tag){
        if (_reSendBtnIndex == buttonIndex){
            // 新增并保留
            self.eventOriStatus = [ClassDataManager StatausStringWithEventStatusType:EventStatusType_Add];
        }
        else if (_replaceBtnIndex == buttonIndex){
            // 新增并删除
            self.eventOriStatus = [ClassDataManager StatausStringWithEventStatusType:EventStatusType_Cancel];
        }
    }
    else if (ActionSheetEventTypeTag == actionSheet.tag){
        // 选择分类
        for(ClassEventCategory *eventCategory in self.categoriesArray){
            if([ToLocalizedString(eventCategory.title) isEqualToString:[actionSheet buttonTitleAtIndex:buttonIndex]]){
                self.eventCategory = eventCategory;
            }
        }
    }

    [self reloadData:YES];
}
#pragma mark - 文本输入回调 (UITextViewDelegate)
- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.contentTextView){
        self.eventContent = textView.text;
    }
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
#pragma mark - 文本输入回调 (UITextFieldDelegate)
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.titleTextField) {
        // 标题
        NSString* textTrimed = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.eventTitle = textTrimed;
    }
    else if (textField == self.locationTextField) {
        // 地点
        self.eventLocation = textField.text;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.titleTextField) {
        [self.locationTextField becomeFirstResponder];
    }
    else if (textField == self.locationTextField) {
        [self.contentTextView becomeFirstResponder];
    }
    return YES;
}
#pragma mark - 协议请求
- (void)cancel {
    [self hideLoading];
    if(self.requestOperator) {
        [self.requestOperator cancel];
        self.requestOperator.delegate = nil;
        self.requestOperator = nil;
    }
}
- (BOOL)submitEvent {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    [self showLoading];
    return [self.requestOperator submitClass:_eventDraft];
}
#pragma mark - 协议回调 (EventRequestOperatorDelegate)
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    if (ClassRequestOperator_SubmitClassEvent == type){
        // 发送成功
        [ClassDataManager removeEventDraft:[ClassDataManager lastEventDraft]];
        [self backAction:nil];
    }
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    if (ClassRequestOperator_SubmitClassEvent == type){
        // 发送失败
        NSString* errorString = [NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"SendFail", nil), ErrorCodeToString(error)];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:nil cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:nil];
        [alertView show];
    }
}

@end
