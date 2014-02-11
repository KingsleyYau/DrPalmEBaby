//
//  WelcomeViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-7.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareDetailViewController.h"
@interface WelcomeViewController : ShareDetailViewController <ShareItemDelegate, iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, weak) IBOutlet iCarousel *carousel;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *enterButton;
@property (nonatomic, assign) NSInteger selectedIndex;

- (IBAction)enterAction:(id)sender;
@end
