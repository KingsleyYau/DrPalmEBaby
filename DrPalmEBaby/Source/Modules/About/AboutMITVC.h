#import <UIKit/UIKit.h>


@interface AboutMITVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView* _tableView;
}

@property (nonatomic, retain) UITableView* tableView;

@end
