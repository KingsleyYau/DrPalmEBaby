//
//  DrClientModule.m
//  DrPalm
//
//  Created by fgx_lion on 12-3-19.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "DrClientModule.h"
#import "DrCOMClientWSViewController.h"
#import "DrClientLanguageDef.h"
#import "KKTabBarItem.h"
@implementation DrClientModule
@synthesize homeController = _homeController;

+ (NSString*)moduleName
{
    return @"DrClient";
}

- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = DrClientTag;
        self.shortName = DrClientModuleTitle;
        self.longName = @"DrClient";
        self.iconName = @"drclient";
        
        //storyListChannelController = [[StoryListViewController alloc] init];
        //[self.tabNavController setViewControllers:[NSArray arrayWithObject:storyListChannelController]];
    }
    return self;
}

- (UIViewController *)moduleHomeController {
    KKTabBarItem *item = [[[KKTabBarItem alloc] initWithTitle:self.shortName image:self.tabBarIcon selectImage:self.tabBarSelectedIcon tag:2] autorelease];
    item.isFullItemImage = YES;
    if (!_homeController) {
        _homeController = [[DrCOMClientWSViewController alloc] init];
        _homeController.tabBarItem = item;
    }
    return _homeController;
}

- (void)dealloc {
    self.homeController = nil;
    [super dealloc];
}

@end

