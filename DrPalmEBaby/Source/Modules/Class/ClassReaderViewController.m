//
//  ClassReaderViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-19.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ClassReaderViewController.h"
#import "ClassCommonDef.h"
@interface ClassReaderViewController () <ClassRequestOperatorDelegate>
@property (nonatomic, retain) ClassRequestOperator *requestOperator;
@end

@implementation ClassReaderViewController

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
    [self reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadFromServer];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark － 界面逻辑
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    // TODO: 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = NSLocalizedString(@"ReaderStatus", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)reloadData {
    self.item = [ClassDataManager eventSentWithId:self.item.event_id];

    self.textViewUnReader.text = self.item.unreader;
    self.textViewReader.text = self.item.reader;
}
#pragma mark - (协议请求)
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
        self.requestOperator = nil;
    }
}
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ClassRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    return [self.requestOperator getEventReadInfo:self.item.event_id];
}
- (void)operateFinish:(id)data requestType:(ClassRequestOperatorStatus)type {
    [self reloadData];
    return;
}
- (void)operateFail:(NSString*)error requestType:(ClassRequestOperatorStatus)type {
    return;
}
@end
