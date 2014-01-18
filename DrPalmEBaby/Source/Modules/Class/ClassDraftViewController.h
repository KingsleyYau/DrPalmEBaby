//
//  ClassDraftViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
@interface ClassDraftViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;

- (IBAction)deleteAction:(id)sender;
@end
