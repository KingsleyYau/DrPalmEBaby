//
//  LatestClassTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-4-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LatestClassTableView;
@class ClassEventCategory;
@protocol LatestClassTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(LatestClassTableView *)tableView;
- (void)tableView:(LatestClassTableView *)tableView didSelectLatestEvent:(ClassEventCategory *)item;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@interface LatestClassTableView : UITableView <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (nonatomic, assign) IBOutlet id <LatestClassTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@end
