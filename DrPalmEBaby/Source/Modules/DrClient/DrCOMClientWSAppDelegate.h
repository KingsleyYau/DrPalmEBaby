//
//  DrCOMClientWSAppDelegate.h
//  DrCOMClientWS
//
//  Created by Keqin Su on 11-4-15.
//  Copyright 2011 City Hotspot Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrCOMClientWSViewController;
@class HttpHandler;

@interface DrCOMClientWSAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DrCOMClientWSViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DrCOMClientWSViewController *viewController;

@end

