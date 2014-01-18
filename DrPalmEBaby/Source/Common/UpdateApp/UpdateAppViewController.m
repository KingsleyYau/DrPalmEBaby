//
//  UpdateAppViewController.m
//  DrPalm
//
//  Created by Kingsley on 12-11-6.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "UpdateAppViewController.h"
#import "UpdateAppManager.h"
#import "UpdateAppManagerLanguageDef.h"

#define UPDATE_ALERT_TAG 0
@interface UpdateAppViewController () <UpdateAppManagerDelegate, DrPalmGateWayManagerDelegate, UIAlertViewDelegate> {
    
}
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *newestVersion;
@property (nonatomic, retain) UpdateAppManager *updateAppManager;
@end

@implementation UpdateAppViewController
@synthesize updateAppManager;
@synthesize urlString;
@synthesize newestVersion;

- (void)updateApp {
    [self.updateAppManager updateApp];
}

- (void)dealloc {
    self.updateAppManager = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.updateAppManager = [[[UpdateAppManager alloc] init] autorelease];
        self.updateAppManager.delegate = (id<UpdateAppManagerDelegate>*)self;
        [DrPalmGateWayManagerInstance() addDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - DrPalmGateWayManagerDelegate
-(void)getGateWaySuccess
{
    [self.updateAppManager updateApp];
}

#pragma mark - UpdateAppManagerDelegate
- (void)updateFinish:(NSString *)url version:(NSString *)version notes:(NSString *)notes {
    self.urlString = url;
    self.newestVersion = version;
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@%@", version, UpdateAppManagerTitle, nil]
                                                    message:notes
                                                   delegate:self
                                          cancelButtonTitle:UpdateAppManagerLater
                                          otherButtonTitles:UpdateAppManagerNow, UpdateAppManagerNever, nil] autorelease];
    alert.tag = UPDATE_ALERT_TAG;
    [alert show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:UpdateAppManagerNow]) {
        NSURL *appUrl = [NSURL URLWithString:self.urlString];
        if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {
            [[UIApplication sharedApplication] openURL:appUrl];
        }
    }
    else if ([buttonTitle isEqualToString:UpdateAppManagerNever]){
        [self.updateAppManager setUpdateVersionInfoBanned:self.newestVersion];
    }
    else if([buttonTitle isEqualToString:UpdateAppManagerLater]){
    }

}
@end
