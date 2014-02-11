//
//  MainListViewController.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-7.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MainListViewController : BaseViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    BOOL _isEverPushView;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundView;
@property (nonatomic, weak) IBOutlet UIWebView   *webview;

@property (nonatomic, retain) NSString *curLocalAreaId;
@property (nonatomic, assign) NSInteger tabItem;

- (IBAction)searchAction:(id)sender;
- (IBAction)refreshAction:(id)sender;
@end
