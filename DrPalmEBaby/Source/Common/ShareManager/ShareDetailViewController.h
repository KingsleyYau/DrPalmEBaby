#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "BaseViewController.h"
@protocol ShareItemDelegate <NSObject>
@optional
- (NSString *)actionSheetTitle;
- (NSString *)emailSubject;
- (NSString *)emailBody;
- (BOOL)isHtmlBody;

- (NSString *)urlBody;

- (NSString *)contentBody;
- (UIImage *)imageBody;
- (NSString *)webUrlBody;
@end


@interface ShareDetailViewController : BaseViewController <UIActionSheetDelegate,  MFMessageComposeViewControllerDelegate> {
    NSMutableArray  *_shares;
	id<ShareItemDelegate> shareDelegate;

}

@property (nonatomic, assign) id<ShareItemDelegate> shareDelegate;
- (IBAction)share:(id)sender;
@end
