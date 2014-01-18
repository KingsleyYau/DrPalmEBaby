//
//  SystemMessageDetailViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-8.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SystemMessageDetailViewController.h"
#import "ClassCommonDef.h"
#import "SystemMessageDataManager.h"

@interface SystemMessageDetailViewController () <ClassRequestOperatorDelegate>
@property (nonatomic, retain) ClassRequestOperator* requestOperator;
@end

@implementation SystemMessageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![self.item.isRead boolValue])
        [self loadFromServer];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"SystemMessageDetailNavigationTitle", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)reloadData {
    self.item = [SystemMessageDataManager messageWithId:self.item.system_id];
    NSString *bodyFormat = [self strFormat:self.item.body];
    [self.textView setText:bodyFormat];
}
- (NSString*)strFormat:(NSString*)str {
    NSString* formatString = [str stringByReplacingOccurrencesOfString:@":" withString:@":\n----------------------\n"];
    return [formatString stringByReplacingOccurrencesOfString:@";" withString:@";\n\n\n"];
}
#pragma mark - 协议k
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    return [self.requestOperator getSysMsgContent:self.item.system_id];
}
#pragma mark - 协议回调 ClassRequestOperatorDelegate
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    self.item.isRead = [NSNumber numberWithBool:YES];
    [CoreDataManager saveData];
    [self reloadData];
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:error];
}
@end
