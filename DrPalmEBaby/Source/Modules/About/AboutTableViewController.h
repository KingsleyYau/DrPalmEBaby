#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutTableViewController : UIViewController <MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView* _tableView;
}

@property (nonatomic, retain) UITableView* tableView;
@end
