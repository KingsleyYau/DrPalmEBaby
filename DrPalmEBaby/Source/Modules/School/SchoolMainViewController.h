//
//  SchoolMainViewController.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-15.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface SchoolMainViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIImageView *titleImageView;
@property (nonatomic, weak) IBOutlet IconGrid *iconGridView;
@property (nonatomic, weak) IBOutlet UIButton *mailButton;
@property (nonatomic, assign) IBOutlet UILabel *mailLabel;

- (IBAction)latestAction:(id)sender;
- (IBAction)searchAction:(id)sender;
- (IBAction)bookmarkAction:(id)sender;
- (IBAction)mailAction:(id)sender;
@end
