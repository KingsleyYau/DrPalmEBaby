//
//  CommonWebViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-8.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface CommonWebViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (atomic, assign) BOOL isNeedErrorPage;
- (void)loadUrl:(NSURL *)webUrl;
@end
