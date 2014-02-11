//
//  DrClientModule.h
//  DrPalm
//
//  Created by fgx_lion on 12-3-19.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITModule.h"

@class DrCOMClientWSViewController;

@interface DrClientModule : MITModule {
	DrCOMClientWSViewController *_homeController;
}

@property (nonatomic, retain) DrCOMClientWSViewController *homeController;

@end