//
//  MoreMainViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-10-29.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ShareDetailViewController.h"
@interface MoreMainViewController : ShareDetailViewController <LoginManagerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, ShareItemDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIView *dynamicWebView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIImageView *drapImageView;

- (IBAction)logoutAction:(id)sender;

- (void)reloadTabbarItem;
@end
