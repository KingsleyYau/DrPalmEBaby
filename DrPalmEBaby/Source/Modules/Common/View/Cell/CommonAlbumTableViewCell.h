//
//  HomeTableViewCell.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonAlbumTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView  *containView1;
@property (nonatomic, weak) IBOutlet RequestImageView *requestImageView1;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *titleLabel1;

@property (nonatomic, weak) IBOutlet UIImageView *bookmarkView1;
@property (nonatomic, weak) IBOutlet UIImageView *attachmenttView1;
@property (nonatomic, weak) IBOutlet UIImageView *emergentView1;
@property (nonatomic, weak) IBOutlet UIImageView *commentView1;
@property (nonatomic, weak) IBOutlet UIImageView *reviewView1;

@property (nonatomic, weak) IBOutlet UIView  *containView2;
@property (nonatomic, weak) IBOutlet RequestImageView *requestImageView2;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *titleLabel2;

@property (nonatomic, weak) IBOutlet UIImageView *bookmarkView2;
@property (nonatomic, weak) IBOutlet UIImageView *attachmenttView2;
@property (nonatomic, weak) IBOutlet UIImageView *emergentView2;
@property (nonatomic, weak) IBOutlet UIImageView *commentView2;
@property (nonatomic, weak) IBOutlet UIImageView *reviewView2;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
