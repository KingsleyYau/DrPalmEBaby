//
//  SystemConfigViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-11.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface SystemConfigViewController : BaseViewController <RequestImageViewDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIView *pickerContainView;
@property (nonatomic, weak) IBOutlet UIPickerView *timePicker;

@property (nonatomic, assign) BOOL isWifi;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL isVoice;
@property (nonatomic, assign) BOOL isVibration;

- (IBAction)saveAction:(id)sender;
- (IBAction)wifiSwitchChanged:(id)sender;
- (IBAction)pushEventsSwitchChanged:(id)sender;
- (IBAction)voiceSwitchChanged:(id)sender;
- (IBAction)vibrationSwitchChanged:(id)sender;
@end
