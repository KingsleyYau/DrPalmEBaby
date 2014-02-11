//
//  SystemMessageDetailViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-8.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
@class SystemMessage;
@interface SystemMessageDetailViewController : BaseViewController
@property (nonatomic, weak) IBOutlet KKTextView *textView;
@property (nonatomic, strong) SystemMessage *item;
@end
