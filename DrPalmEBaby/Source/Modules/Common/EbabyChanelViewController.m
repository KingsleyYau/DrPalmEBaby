//
//  EbabyChanelViewController.m
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-8.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "EbabyChanelViewController.h"

#define NEW_PAGE_TAG @"newwindow=true"

@interface EbabyChanelViewController ()
@property (nonatomic, retain) NSURLRequest *curRequest;
@end

@implementation EbabyChanelViewController

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
    [self.webView loadRequest:self.curRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setWebView:(UIWebView *)webView {
    _webView = webView;
    _webView.delegate = self;
}
#pragma mark - 界面逻辑
- (void)loadUrl:(NSURL *)webUrl {
    NSLog(@"EbabyChannel loadUrl:%@", webUrl);
    self.curRequest = [NSURLRequest requestWithURL:webUrl];
    
    // 如果加载的是错误页面，不需要返回错误处理
//    NSString *fileString = [[ResourceManager resourceFilePath:DrPalmLoadErrorDefaultFile] UrlDecode];
//    NSURL *fileUrl =[NSURL fileURLWithPath:fileString];
//    if([self.curRequest.URL.absoluteString isEqualToString:fileUrl.absoluteString]) {
//        self.isNeedErrorPage = NO;
//    }
//    else {
//        self.isNeedErrorPage = YES;
//    }
    [_webView loadRequest:self.curRequest];
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // 同一次请求,过虑本页url
    if(request.URL.absoluteString.length > 0) {
        NSRange range = [self.curRequest.URL.absoluteString rangeOfString:[request.URL.absoluteString substringFromIndex:7]];
        if (NSNotFound == range.location) {
            NSRange range2 = [[request.URL absoluteString] rangeOfString:NEW_PAGE_TAG];
            if (NSNotFound != range2.location) {
                // 开新页面
                NSLog(@"加载开新页面");
                UIStoryboard *storyBoard = AppDelegate().storyBoard;
                
                KKNavigationController *nvc = (KKNavigationController *)self.myNavigationController;
                EbabyChanelViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"EbabyChanelViewController"];
               
                vc.myNavigationController = self.myNavigationController;
                [vc loadUrl:request.URL];
                [nvc pushViewController:vc animated:YES gesture:NO];
                return NO;
            }
        }
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    if(self.isNeedErrorPage) {
//        NSLog(@"加载本地错误页面");
//        NSString *fileString = [[ResourceManager resourceFilePath:DrPalmLoadErrorDefaultFile] UrlDecode];
//        NSURL *fileUrl =[NSURL fileURLWithPath:fileString];
//        [self loadUrl:fileUrl];
//    }
}

@end
