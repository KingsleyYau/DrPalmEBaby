//
//  MainGuideViewController.h
//  DrPalm4EBaby2
//
//  Created by KingsleyYau on 13-9-16.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "BaseViewController.h"

@interface MainGuideViewController : BaseViewController <UIActionSheetDelegate> {
    BOOL _isEverPushView;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
- (IBAction)gardenAction:(id)sender;
- (IBAction)associationAction:(id)sender;
- (IBAction)clientAction:(id)sender;
- (IBAction)ebabyAction:(id)sender;
@end
