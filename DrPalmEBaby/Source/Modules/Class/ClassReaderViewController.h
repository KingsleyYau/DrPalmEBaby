//
//  ClassReaderViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-19.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
@class ClassEventSent;
@interface ClassReaderViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UILabel *labelUnReader;
@property (nonatomic, weak) IBOutlet UITextView *textViewUnReader;
@property (nonatomic, weak) IBOutlet UILabel *labelReader;
@property (nonatomic, weak) IBOutlet UITextView *textViewReader;

@property (nonatomic, strong) ClassEventSent *item;
@end
