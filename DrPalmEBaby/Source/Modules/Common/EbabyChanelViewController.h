//
//  EbabyChanelViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-8.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface EbabyChanelViewController : BaseViewController <UIWebViewDelegate> {
    UIWebView *_webView;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UINavigationController* myNavigationController;
@property (atomic, assign) BOOL isNeedErrorPage;
- (void)loadUrl:(NSURL *)webUrl;
@end
