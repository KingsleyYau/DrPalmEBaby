//
//  DrPalmToursHomeController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-24.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "DrPalmToursHomeController.h"
#import "ResourceDownloadManager.h"

@interface DrPalmToursHomeController ()
@property (strong, nonatomic) NSURL *url;
@end

@implementation DrPalmToursHomeController

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
    [self setupWebView];
    [self reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (void)setupWebView {
    self.webView.scrollView.bounces = NO;
}
- (void)reloadData {
    NSURL *url = nil;
    
    // 当前学校资源包
    NSString *toursPath = [ResourceDownloadManager toursPathWithSchoolKey];
    toursPath = [toursPath stringByAppendingString:@"/tours"];
    
    // 默认资源包
    NSString *toursDefaultPath = [ResourceManager resourceFilePath:@"tours/tours"];
    
    NSString *lang = [UIImage getPreferredLanguage];
    if([lang isEqualToString:@"zh-Hans"]){
        toursPath = [toursPath stringByAppendingString:@"-s"];
        toursDefaultPath = [toursDefaultPath stringByAppendingString:@"-s"];
    }
    else if([lang isEqualToString:@"zh-Hant"]){
        toursPath = [toursPath stringByAppendingString:@"-t"];
        toursDefaultPath = [toursDefaultPath stringByAppendingString:@"-t"];
    }
    
    toursPath = [toursPath stringByAppendingString:DrPalmToursDefaultFile];
    toursDefaultPath = [toursDefaultPath stringByAppendingString:DrPalmToursDefaultFile];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:toursPath];
    if(isExist) {
        // 加载当前学校资源包
        url = [NSURL fileURLWithPath:toursPath];
    }
    else {
        // 加载默认资源包
        url = [NSURL fileURLWithPath:toursDefaultPath];
    }

    [self loadUrl:url];
}
- (void)loadUrl:(NSURL *)url {
    self.url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 过虑本页url
    NSRange range = [self.url.absoluteString rangeOfString:[request.URL.absoluteString substringFromIndex:7]];
    if (NSNotFound == range.location) {
        // 跳到其它页面url
//        CommonWebViewController *vc = [[[CommonWebViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//        [self.navigationController pushViewController:vc animated:YES];
//        [vc loadUrl:request.URL];
        return NO;
    }
    return YES;
}
@end
