//
//  LatestSchoolNewsTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-4-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LatestSchoolNewsTableView;
@class SchoolNewsCategory;
@protocol LatestSchoolNewsTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(LatestSchoolNewsTableView *)tableView;
- (void)tableView:(LatestSchoolNewsTableView *)tableView didSelectLatestNews:(SchoolNewsCategory *)item;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@interface LatestSchoolNewsTableView : UITableView <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (nonatomic, weak) IBOutlet id <LatestSchoolNewsTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@end
