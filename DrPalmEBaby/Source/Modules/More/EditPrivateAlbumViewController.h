//
//  EditPrivateAlbumViewController.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-7.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
@class PrivateAlbumForSent;
@interface EditPrivateAlbumViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet KKTextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, retain) PrivateAlbumForSent *item;


- (IBAction)sendAction:(id)sender;
- (IBAction)addAction:(id)sender;
@end
