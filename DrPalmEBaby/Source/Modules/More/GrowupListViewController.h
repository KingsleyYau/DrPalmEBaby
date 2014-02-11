//
//  GrowupListViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface GrowupListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;
- (IBAction)addAction:(id)sender;
- (IBAction)deleteAction:(id)sender;
@end
