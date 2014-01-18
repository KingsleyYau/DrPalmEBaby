//
//  AccountManageViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-11.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "AccountManageViewController.h"
#import "GrowupListViewController.h"
#import "PrivateAlbumViewController.h"


#import "AccountImageTableViewCell.h"
#import "CommonLabelTableViewCell.h"
#import "CommonSwitchTableViewCell.h"
#import "CommonTableViewCell.h"

#import "CommonRequestOperator.h"

#define ImagePickerReferenceURLKey  @"UIImagePickerControllerReferenceURL"
#define ImagePickerOriginalImageKey @"UIImagePickerControllerOriginalImage"
typedef enum {
    RowTypeAccountImage,
    RowTypeAccountLabel,
    RowTypeRememberPassword,
    RowTypeAutoLogin,
    
    RowTypeLevel,
    RowTypeScore,
    RowTypeScoreLevelUp,
    
    RowTypeGrowUp,
    RowTypeMyAlbumn,
} RowType;
@interface AccountManageViewController () <CommonRequestOperatorDelegate>
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) CommonRequestOperator *requestOperator;
@end

@implementation AccountManageViewController

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
    
    self.isRememberPassword = [UserInfoManagerInstance().userInfo.isrememberme boolValue];
    self.isAutoLogin = [UserInfoManagerInstance().userInfo.isautologin boolValue];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadAccountInfo];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancel];
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
    titleLabel.text = NSLocalizedString(@"PersonalConfig", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)reloadData:(BOOL)isReloadView {
    NSMutableArray *sectionArray = [NSMutableArray array];
    
    // section 1
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    // 用户头像
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [AccountImageTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeAccountImage] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 用户名字
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonLabelTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeAccountLabel] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 记住密码
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonSwitchTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeRememberPassword] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    if(self.isRememberPassword) {
        // 自动登录
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [CommonSwitchTableViewCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeAutoLogin] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }

    [sectionArray addObject:array];
    
    // section 2
    array = [NSMutableArray array];
    
    // 等级
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonLabelTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeLevel] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 当前积分
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonLabelTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeScore] forKey:ROW_TYPE];
    [array addObject:dictionary];

    // 用户升级积分
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonLabelTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeScoreLevelUp] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    // section 3
    array = [NSMutableArray array];
    
    // 成长点滴
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeGrowUp] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 个人相册
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeMyAlbumn] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    self.sectionArray = sectionArray;
    
    if(isReloadView) {
        [self.tableView reloadData];
    }
}
- (IBAction)rememberPasswordSwitchChanged:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    self.isRememberPassword = aSwitch.on;
    UserInfoManagerInstance().userInfo.isrememberme = [NSNumber numberWithBool:self.isRememberPassword];
    [UserInfoManagerInstance() saveUserInfo];
    [self reloadData:YES];
}
- (IBAction)autoLoginSwitchChanged:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    self.isAutoLogin = aSwitch.on;
    UserInfoManagerInstance().userInfo.isautologin = [NSNumber numberWithBool:self.isAutoLogin];
    [UserInfoManagerInstance() saveUserInfo];
    [self reloadData:YES];
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
            case RowTypeAccountImage:{
                // 用户头像
                AccountImageTableViewCell *cell = [AccountImageTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = [LoginManagerInstance() userName];
                
                cell.requestImageView.imageUrl = UserInfoManagerInstance().userInfo.headimage.url;
                cell.requestImageView.imageData = UserInfoManagerInstance().userInfo.headimage.data;
                cell.requestImageView.delegate = self;
                [cell.requestImageView loadImage];
            }break;
            case RowTypeAccountLabel:{
                // 用户名字
                CommonLabelTableViewCell *cell = [CommonLabelTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"Account", nil);
                cell.nameLabel.text = UserInfoManagerInstance().userInfo.username;
            }break;
            case RowTypeRememberPassword:{
                // 记住密码
                CommonSwitchTableViewCell *cell = [CommonSwitchTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"SavePassword", nil);
                [cell.rightSwitch setOn:self.isRememberPassword];
                [cell.rightSwitch addTarget:self action:@selector(rememberPasswordSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            }break;
            case RowTypeAutoLogin:{
                // 自动登录
                CommonSwitchTableViewCell *cell = [CommonSwitchTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"AutoLogin", nil);
                [cell.rightSwitch setOn:self.isAutoLogin];
                [cell.rightSwitch addTarget:self action:@selector(autoLoginSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            }break;
            case RowTypeLevel:{
                // 等级
                CommonLabelTableViewCell *cell = [CommonLabelTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"Level", nil);
                cell.nameLabel.text = [UserInfoManagerInstance().userInfo.level stringValue];
            }break;
            case RowTypeScore:{
                // 当前积分
                CommonLabelTableViewCell *cell = [CommonLabelTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"CurrentPoint", nil);
                cell.nameLabel.text = [UserInfoManagerInstance().userInfo.curscore stringValue];
            }break;
            case RowTypeScoreLevelUp:{
                // 升级积分
                CommonLabelTableViewCell *cell = [CommonLabelTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text = NSLocalizedString(@"LevelUpPoint", nil);
                cell.nameLabel.text = [UserInfoManagerInstance().userInfo.levelupscore stringValue];
            }break;
            case RowTypeGrowUp:{
                // 成长点滴
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = NSLocalizedString(@"GrowUp", nil);
            }break;
            case RowTypeMyAlbumn:{
                // 个人相册
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = NSLocalizedString(@"PersonalAlbumn", nil);
            }break;
            default:break;
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = [self.sectionArray objectAtIndex:indexPath.section];
    NSDictionary *dictionarry = [array objectAtIndex:indexPath.row];
    // TODO:类型
    RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
    switch (type) {
        case RowTypeGrowUp:{
            // 成长点滴
            UIStoryboard *storyBoard = AppDelegate().storyBoard;
            
            KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
            GrowupListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"GrowupListViewController"];
            [nvc pushViewController:vc animated:YES gesture:NO];
        }break;
        case RowTypeMyAlbumn:{
            // 个人相册
            UIStoryboard *storyBoard = AppDelegate().storyBoard;
            
            KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
            PrivateAlbumViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"PrivateAlbumViewController"];
            [nvc pushViewController:vc animated:YES gesture:NO];
        }break;
        default:break;
    }
}
#pragma mark - 异步下载图片控件回调
- (UIImage *)imageForDefault:(RequestImageView *)imageView {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:LoginUserDefaultImage ofType:@"png"]];
    return image;
}
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    UserInfoManagerInstance().userInfo.headimage.data = imageView.imageData;
    [CoreDataManager saveData];
}
- (void)photoViewDidSingleTap:(RequestImageView *)imageView {
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
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 淡出UIImagePickerController
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *resizeImage = (UIImage*)[info objectForKey:ImagePickerOriginalImageKey];
    CGFloat scale = resizeImage.size.width / resizeImage.size.height;
    NSInteger maxSize = 1024.0f;
    if (scale > 1.0f){
        resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize, maxSize / scale) interpolationQuality:kCGInterpolationDefault];
    }
    else {
        resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize * scale, maxSize) interpolationQuality:kCGInterpolationDefault];
    }
    NSData* headImageDate = UIImageJPEGRepresentation(resizeImage, 0.3f);
    
    //提交头像
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[CommonRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    [self.requestOperator submitAccountInfo:headImageDate];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark - 协议请求
- (void)cancel {
    [self.loadingView hideLoading:YES];
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)loadAccountInfo {
    NSInteger lastupdate = [UserInfoManagerInstance().userInfo.lastupdate timeIntervalSince1970];
    return [self.requestOperator getAccountInfo:[NSString stringWithFormat:@"%d",lastupdate,nil]];
}
#pragma mark - CommonRequestOperatorDelegate
- (void)requestFinish:(id)data requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    //提交头像成功
    if(type == CommonRequestOperatorStatus_SubmitAccountInfo){
        [self loadAccountInfo];
    }
    else if(type == CommonRequestOperatorStatus_GetAccountInfo){
        [self reloadData:YES];
    }
}
- (void)requestFail:(NSString*)error requestType:(CommonRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:error];
}
@end
