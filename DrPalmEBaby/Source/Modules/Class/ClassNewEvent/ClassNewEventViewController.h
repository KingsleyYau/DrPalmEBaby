//
//  ClassNewEventViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassNewAttachmentViewController.h"

@class ClassEventCategory;
@class ClassEventDraft;
@interface ClassNewEventViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) KKTextField *titleTextField;
@property (nonatomic, weak) KKTextField *locationTextField;
@property (nonatomic, weak) KKTextView *contentTextView;
@property (nonatomic, strong) LoadingView *loadingView;



// 通告属性
@property (nonatomic, retain) NSMutableArray *eventAddressees;
@property (nonatomic, retain) NSMutableArray *eventAddrNames;
@property (nonatomic, retain) NSMutableArray *eventAttachments;
@property (nonatomic, retain) NSString *eventTitle;
@property (nonatomic, retain) NSString *eventLocation;
@property (nonatomic, retain) NSString *eventOriEventID;
@property (nonatomic, retain) NSString *eventOriStatus;
@property (nonatomic, retain) NSString *eventContent;
@property (nonatomic, retain) NSDate *eventStart;
@property (nonatomic, retain) NSDate *eventEnd;
@property (nonatomic, retain) UIImage *imageCache;
@property (nonatomic, assign) BOOL isEmergent;
@property (nonatomic, retain) ClassEventCategory *eventCategory;
@property (nonatomic, assign) BOOL isSendBySelf;
@property (nonatomic, retain) ClassEventDraft *eventDraft;

- (IBAction)saveAction:(id)sender;
- (IBAction)sendAction:(id)sender;
- (IBAction)emergentAction:(id)sender;

@end
