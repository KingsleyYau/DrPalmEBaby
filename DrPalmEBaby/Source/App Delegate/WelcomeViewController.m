//
//  WelcomeViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-7.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController () {
}
@property (nonatomic, retain) NSArray *items;
@end

@implementation WelcomeViewController

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
    self.shareDelegate = self;
    [self initWelcomImage];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupCarousel];
    [self reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (void)initWelcomImage {
    NSMutableArray *mulArray = [NSMutableArray array];
    for(int i=1; i<=6; i++) {
        NSString *imagePath = [NSString stringWithFormat:@"welcome_%d", i];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imagePath ofType:@"jpg"]];
        [mulArray addObject:image];
    }
    self.items = mulArray;
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
}
- (void)setupCarousel {
    self.carousel.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.decelerationRate = 0.3f;
    self.carousel.bounces = NO;
}
// 界面加载数据
- (void)reloadData {
    [self.carousel reloadData];
}
- (IBAction)enterAction:(id)sender {
    [self.view removeFromSuperview];
}
#pragma mark - iCarouselDataSource
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    // 创建itemView
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.items objectAtIndex:index]];
  
    imageView.frame = CGRectMake(0, 0, carousel.frame.size.width, carousel.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    return imageView;
}

#pragma mark - iCarouselDelegate
- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carousel {
    
}
- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    self.shareButton.hidden = YES;
    self.enterButton.hidden = YES;
}
- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel {
    self.shareButton.hidden = YES;
    self.enterButton.hidden = YES;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    self.selectedIndex = carousel.currentItemIndex;
    
    if(carousel.currentItemIndex == self.items.count - 1) {
        // 最后一页
        self.shareButton.hidden = NO;
        self.enterButton.hidden = NO;
    }
    else {
        self.shareButton.hidden = YES;
        self.enterButton.hidden = YES;
    }
}
#pragma mark - 分享回调 (ShareItemDelegate)
- (NSString *)actionSheetTitle {
	return @"";
}
- (NSString *)emailSubject {
	return @"";
}

- (NSString *)contentBody {
    return  [self emailBody];
}

- (NSString *)emailBody {
    NSString* body = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"MoreShareContent", nil), NSLocalizedString(@"MoreDownloadUrl", nil)];
    return body;
}
- (NSString*)urlBody
{
    return [self emailBody];
}
@end
