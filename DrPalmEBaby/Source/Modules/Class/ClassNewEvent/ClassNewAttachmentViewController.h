//
//  ClassNewAttachmentViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-7.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface ClassAttachmentItem : NSObject {
    NSData      *_data;
    NSString    *_url;
    NSString    *_type;
    NSString    *_desc;
    NSString    *_attid;
}
@property (nonatomic, retain) NSData    *data;
@property (nonatomic, retain) NSString  *url;
@property (nonatomic, retain) NSString  *type;
@property (nonatomic, retain) NSString  *desc;
@property (nonatomic, retain) NSString  *attid;
@end

@interface ClassNewAttachmentViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet KKTextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet iCarousel *carousel;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, retain) NSMutableArray *attachments;

- (IBAction)addAction:(id)sender;
@end
