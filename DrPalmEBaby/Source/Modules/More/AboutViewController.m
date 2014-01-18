//
//  SystemConfigViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-11.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "AboutViewController.h"

#import "CommonLabelTableViewCell.h"
#import "CommonDynamicLabelTableViewCell.h"
#import "CommonTableViewCell.h"


typedef enum {
    RowType2Version,
    RowType2Presentation,
} RowType;

@interface AboutViewController () {
}
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *sectionArray2;
@end

@implementation AboutViewController

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
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    titleLabel.text = NSLocalizedString(@"MoreAbout", nil);
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
    
    // 版本
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonLabelTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowType2Version] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 简介
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonDynamicLabelTableViewCell cellHeight:self.tableView content:NSLocalizedString(@"AboutAppText", nil)]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowType2Presentation] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    [sectionArray addObject:array];
    
    self.sectionArray = sectionArray;
    
    if(isReloadView) {
        [self.tableView reloadData];
    }
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width - 2 * 20, 88)];
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:view.frame];
    [view addSubview:footerLabel];
    
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.text = NSLocalizedString(@"AboutTableViewFooter", nil);
    footerLabel.font = [UIFont systemFontOfSize:15.0];
    footerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    footerLabel.numberOfLines = 0;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 88;
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
            case RowType2Version:{
                // 版本
                CommonLabelTableViewCell *cell = [CommonLabelTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.tipsLabel.text =  NSLocalizedString(@"AboutVersion", nil);;
                NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                cell.nameLabel.text = [infoDict objectForKey:@"CFBundleVersion"];
            }break;
            case RowType2Presentation:{
                // 简介
                CommonDynamicLabelTableViewCell *cell = [CommonDynamicLabelTableViewCell getUITableViewCell:tableView];
                result = cell;
                cell.contentLabel.text = NSLocalizedString(@"AboutAppText", nil);
            }break;
            default:break;
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
