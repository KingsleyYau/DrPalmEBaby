//
//  SchoolModule.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-8.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "SchoolModule.h"
#import "SchoolCommonDef.h"
#import "SchoolMainViewController.h"
@interface SchoolModule () {
    
}
@property (nonatomic, strong) SchoolMainViewController *vc;
@end

@implementation SchoolModule
- (NSString*)moduleName {
    return @"school";
}
- (UIViewController *)viewController {
    SchoolMainViewController *vc = nil;
    if(!self.vc) {
        UIStoryboard *storyBoard = AppDelegate().storyBoard;
        vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolMainViewController"];
        self.vc = vc;
    }
    return self.vc;
}
@end
