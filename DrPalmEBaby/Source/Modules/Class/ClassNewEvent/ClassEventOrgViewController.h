//
//  ClassEventOrgViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-6.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
@protocol ClassEventOrgTableViewDelegate <NSObject>
@optional
- (void)eventOrgConfirm:(NSMutableArray*)arrary;
@end

@interface ClassEventOrgViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UICheckBox *cbAllSelected;
@property (nonatomic, weak) IBOutlet UICheckBox *cbSendtoSelf;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet id <ClassEventOrgTableViewDelegate> delegate;

@property (nonatomic, retain) NSString  *parentOrgID;
@property (nonatomic, retain) UIViewController *rootVC;
@property (nonatomic, retain) NSString  *selfOrgId;


- (IBAction)allSeceletedChanged:(id)sender;
- (IBAction)send2SelfChanged:(id)sender;
- (IBAction)clickCellButton:(id)sender;

- (IBAction)cancelAction:(id)sender;
- (IBAction)saveAction:(id)sender;

- (void)initCheckedOrgs:(NSArray*)checkOrgs;
@end
