//
//  SystemConfigViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-11.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SystemConfigViewController.h"

#import "CommonLabelTableViewCell.h"
#import "CommonSwitchTableViewCell.h"
#import "CommonTableViewCell.h"

#import "ClassDataManager.h"
#import "SchoolDataManager.h"
#import "LastUpdateDataManager.h"
#import "CommonRequestOperator.h"

typedef enum {
    RowTypeWiFi,
    
    RowTypePush,
    RowTypeVoice,
    RowTypeVibration,
    RowTypePushTime,
    
    RowTypeCleanNews,
    RowTypeCleanEvent,
} RowType;

typedef enum
{
    TypeClean_PushTime,
    TypeClean_School,
    TypeClean_Class,
}TypeClean;

@interface SystemConfigViewController () <CommonRequestOperatorDelegate> {
    NSInteger _startTime;
    NSInteger _endTime;
    
    TypeClean typeclean;
    
    CGRect _orgPickerContainViewRect;
}
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) CommonRequestOperator *requestOperator;
@property (nonatomic, strong) LoadingView *loadingView;
@end

@implementation SystemConfigViewController

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
    _startTime = 0;
    _endTime = 24;
    
    [UserInfoManagerInstance() initWithLastLoginUser];
    
    if(UserInfoManagerInstance().userInfo.pushstart != nil &&
       UserInfoManagerInstance().userInfo.pushend != nil) {
        NSString *fromTime =UserInfoManagerInstance().userInfo.pushstart;
        int length = [fromTime length];
        _startTime = [[fromTime substringToIndex:length>3?length-3:length] intValue];
        NSString *toTime   = UserInfoManagerInstance().userInfo.pushend;
        length = [toTime length];
        _endTime = [[toTime substringToIndex:length>3?length-3:length] intValue];
    }
    
    self.isWifi = UserInfoManagerInstance().isOnlyWifi;
    self.isPush = [UserInfoManagerInstance().userInfo.ispush boolValue];
    self.isVoice = [UserInfoManagerInstance().userInfo.issound boolValue];
    self.isVibration = [UserInfoManagerInstance().userInfo.isshake boolValue];
    
    self.loadingView = [[LoadingView alloc] init];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _orgPickerContainViewRect = self.pickerContainView.frame;
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
    titleLabel.text = NSLocalizedString(@"SystemConfig", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    LoginManager *loginManager = LoginManagerInstance();
    if(LoginStatus_off != loginManager.loginStatus) {
        UIBarButtonItem *barButtonItem = nil;
        UIButton *button = nil;
        UIImage *image = nil;
        
        // TODO:右边按钮
        NSMutableArray *array = [NSMutableArray array];
        
        // 保存按钮
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlue ofType:@"png"]];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [button addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationButtonBackgroundBlueC ofType:@"png"]];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button sizeToFit];
        
        barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [array addObject:barButtonItem];
        
        self.navigationItem.rightBarButtonItems = array;
    }

}
- (void)reloadData:(BOOL)isReloadView {
    NSMutableArray *sectionArray = [NSMutableArray array];
    
    // section 1
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    // wifi
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonSwitchTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeWiFi] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    // section 2
    array = [NSMutableArray array];
    
    LoginManager *loginManager = LoginManagerInstance();
    if(LoginStatus_off != loginManager.loginStatus) {
        // 推送
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [CommonSwitchTableViewCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypePush] forKey:ROW_TYPE];
        [array addObject:dictionary];
        
        if(self.isPush) {
            // 声音
            dictionary = [NSMutableDictionary dictionary];
            viewSize = CGSizeMake(_tableView.frame.size.width, [CommonSwitchTableViewCell cellHeight]);
            rowSize = [NSValue valueWithCGSize:viewSize];
            [dictionary setValue:rowSize forKey:ROW_SIZE];
            [dictionary setValue:[NSNumber numberWithInteger:RowTypeVoice] forKey:ROW_TYPE];
            [array addObject:dictionary];
            
            // 震动
            dictionary = [NSMutableDictionary dictionary];
            viewSize = CGSizeMake(_tableView.frame.size.width, [CommonSwitchTableViewCell cellHeight]);
            rowSize = [NSValue valueWithCGSize:viewSize];
            [dictionary setValue:rowSize forKey:ROW_SIZE];
            [dictionary setValue:[NSNumber numberWithInteger:RowTypeVibration] forKey:ROW_TYPE];
            [array addObject:dictionary];
            
            // 推送时间
            dictionary = [NSMutableDictionary dictionary];
            viewSize = CGSizeMake(_tableView.frame.size.width, [CommonLabelTableViewCell cellHeight]);
            rowSize = [NSValue valueWithCGSize:viewSize];
            [dictionary setValue:rowSize forKey:ROW_SIZE];
            [dictionary setValue:[NSNumber numberWithInteger:RowTypePushTime] forKey:ROW_TYPE];
            [array addObject:dictionary];
        }
    }

    [sectionArray addObject:array];

    // section 3
    array = [NSMutableArray array];
    
    // 清除离线校园新闻
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeCleanNews] forKey:ROW_TYPE];
    [array addObject:dictionary];

    if(LoginStatus_off != loginManager.loginStatus) {
        // 清除离线班级通告
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeCleanEvent] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }
    
    [sectionArray addObject:array];

    self.sectionArray = sectionArray;
    
    if(isReloadView) {
        [self.tableView reloadData];
    }
}
- (IBAction)saveAction:(id)sender {
    [self saveToServer];
}
- (IBAction)wifiSwitchChanged:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    self.isWifi = aSwitch.on;
    UserInfoManagerInstance().isOnlyWifi = self.isWifi;
    [UserInfoManagerInstance() saveUserInfo];
    [self reloadData:YES];
}
- (IBAction)pushEventsSwitchChanged:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    self.isPush = aSwitch.on;
    UserInfoManagerInstance().userInfo.ispush = [NSNumber numberWithBool:self.isPush];
    [UserInfoManagerInstance() saveUserInfo];
    [self reloadData:YES];
}
- (IBAction)voiceSwitchChanged:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    self.isVoice = aSwitch.on;
    UserInfoManagerInstance().userInfo.issound = [NSNumber numberWithBool:self.isVoice];
    [UserInfoManagerInstance() saveUserInfo];
    [self reloadData:YES];
}
- (IBAction)vibrationSwitchChanged:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    self.isVibration = aSwitch.on;
    UserInfoManagerInstance().userInfo.isshake = [NSNumber numberWithBool:self.isVibration];
    [UserInfoManagerInstance() saveUserInfo];
    [self reloadData:YES];
}
#pragma mark - (列表界面回调)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat number = 0;
    switch (section) {
        case 0:{
            // 仅WiFi使用
            NSString *valueString = NSLocalizedString(@"SettingsWiFiFooter", nil);
            CGSize contentSize = [valueString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(tableView.frame.size.width - 2 * 15, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            number = contentSize.height + 30;
        }break;
        default:break;
    }
    return number;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;
    switch (section) {
        case 0:{
            // 仅WiFi使用
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, tableView.frame.size.width - 2 * 15, 44)];
            
            label.text = NSLocalizedString(@"SettingsWiFiFooter", nil);
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
        default:break;
    }
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int number = 0;
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        number = self.sectionArray.count;
    }
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
        
        // TODO:类型
        RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
        switch (type) {
            case RowTypeWiFi:{
                // wifi
                CommonSwitchTableViewCell *cell = [CommonSwitchTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = @"仅wifi启用";
                [cell.rightSwitch setOn:self.isWifi];
                [cell.rightSwitch addTarget:self action:@selector(wifiSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            }break;
            case RowTypePush:{
                // 推送
                CommonSwitchTableViewCell *cell = [CommonSwitchTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"Push", nil);
                [cell.rightSwitch setOn:self.isPush];
                [cell.rightSwitch addTarget:self action:@selector(pushEventsSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            }break;
            case RowTypeVoice:{
                // 声音
                CommonSwitchTableViewCell *cell = [CommonSwitchTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"Voice", nil);
                [cell.rightSwitch setOn:self.isVoice];
                [cell.rightSwitch addTarget:self action:@selector(voiceSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            }break;
            case RowTypeVibration:{
                // 震动
                CommonSwitchTableViewCell *cell = [CommonSwitchTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"Vibration", nil);
                [cell.rightSwitch setOn:self.isVibration];
                [cell.rightSwitch addTarget:self action:@selector(vibrationSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            }break;
            case RowTypePushTime:{
                // 推送时间
                CommonLabelTableViewCell *cell = [CommonLabelTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"PushTime", nil);
                cell.nameLabel.text = [NSString stringWithFormat:@"%d:00 - %d:00",_startTime,_endTime];;
            }break;
            case RowTypeCleanNews:{
                // 清除离线校园新闻
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = NSLocalizedString(@"ClearNews", nil);
            }break;
            case RowTypeCleanEvent:{
                // 清除离线通告
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = NSLocalizedString(@"ClearEvents", nil);
            }break;
            default:break;
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            case RowTypePushTime:{
                // 推送时间
                typeclean = TypeClean_PushTime;
                
                [self.timePicker selectRow:_startTime inComponent:0 animated:YES];
                [self.timePicker selectRow:_endTime - 1 inComponent:1 animated:YES];
                
                self.pickerContainView.frame = CGRectMake(0, self.view.frame.size.height - self.pickerContainView.frame.size.height, self.pickerContainView.frame.size.width, self.pickerContainView.frame.size.height);
            }break;
            case RowTypeCleanNews:{
                // 清除离线校园新闻
                typeclean = TypeClean_School;
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ClearNews", nil), nil];
                sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                [sheet showInView:self.view];
            }break;
            case RowTypeCleanEvent:{
                // 清除离线班级通告
                typeclean = TypeClean_Class;
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ClearEvents", nil), nil];
                sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                [sheet showInView:self.view];
            }break;
            default:break;
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        if(typeclean == TypeClean_School)
        {
            [SchoolDataManager removeAllNews:YES];
            [LastUpdateDataManager clearSchoolLastUpdate];
        }
        else if(typeclean == TypeClean_Class)
        {
            [ClassDataManager removeAllEvents:YES];
            [LastUpdateDataManager clearClassLastUpdate];
            [AppDelegate() unReadCountDesc:nil];
        }
    }
}
- (IBAction)clickDone:(id)sender {
    self.pickerContainView.frame = _orgPickerContainViewRect;
    [self reloadData:YES];
}
#pragma mark -  UIPickerViewDelegateAndSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 24;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width / 2 - 15;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2 - 15, 20)];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    if(0 == component)
        label.text = [NSString stringWithFormat:@"%d:00",row];
    else
        label.text = [NSString stringWithFormat:@"%d:00",row + 1];
    
    
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(0 == component)
        _startTime = row;
    else
        _endTime = row + 1;
    if(_startTime == _endTime)
    {
        if(0 == _startTime){
            _endTime++;
            [pickerView selectRow:_endTime inComponent:1 animated:YES];
        }
        else{
            _startTime--;
            [pickerView selectRow:_startTime inComponent:0 animated:YES];
        }
        [pickerView reloadAllComponents];
    }
}
#pragma mark -
- (NSDate*)getDate:(NSInteger)intDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%d:00",intDate]];
    return date;
}
- (NSString*)getHourMin:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"]; //设定时间格式,这里可以设置成自己需要的格式
    
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

- (NSString*)getTimeString:(NSInteger)time {
    return [NSString stringWithFormat:@"%.2d:00", time];
}
#pragma mark - 协议
- (void)cancel {
    [self.loadingView hideLoading:YES];
    [self.requestOperator cancel];
}
- (BOOL)saveToServer {
    [self cancel];
    if (!self.requestOperator){
        self.requestOperator = [[CommonRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }

    [self.loadingView showLoading:self.view animated:YES];
    return [self.requestOperator setPushInfo:self.isPush isVibrate:self.isVibration isSound:self.isVoice fromTime:[self getTimeString:_startTime] toTime:[self getTimeString:_endTime]];
}
#pragma mark - CommonRequestOperatorDelegate
- (void)requestFinish:(id)data requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    
    UserInfoManagerInstance().userInfo.pushstart = [self getTimeString:_startTime];
    UserInfoManagerInstance().userInfo.pushend = [self getTimeString:_endTime];
    [UserInfoManagerInstance() saveUserInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestFail:(NSString*)error requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
}
@end
