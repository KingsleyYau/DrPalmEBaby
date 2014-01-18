#import "ShareDetailViewController.h"

#import "AppEnviroment.h"
#import "ShareLanguageDef.h"
#import "NSString+UrlCode.h"

@interface ShareDetailViewController() <AWActionSheetDelegate>
@property (nonatomic, retain) NSMutableArray    *shares;
- (void)initSharesValue;
@end

@implementation ShareDetailViewController
@synthesize shareDelegate = _shareDelegate;
@synthesize shares = _shares;
/*
- (id)init
{
	self = [super init];
	if (self) {
		actionSheetTitle = nil;
		emailSubject = nil;
		emailBody = nil;
	}
	return self;
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    shareDelegate = nil;
    //[fbSession release];
    self.shares = nil;
    [super dealloc];
}

//- (void)loadView {
//    [super loadView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSharesValue];
}	

- (void)initSharesValue
{
    self.shares = [NSMutableArray array];
    for (ShareItemEntitlement *shareItem in AppEnviromentInstance().shareEntitlement.shares){
        if (shareItem.show){
            [self.shares addObject:shareItem];
        }
    }
}

#pragma mark Action Sheet

// subclasses should make sure actionSheetTitle is set up before this gets called
// or call [super share:sender] at the end of this
- (IBAction)share:(id)sender {
    
//	UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:[self.shareDelegate actionSheetTitle]
//															delegate:self
//												   cancelButtonTitle:nil
//											  destructiveButtonTitle:nil
//												   otherButtonTitles:nil];
//    
//    for (ShareItemEntitlement *shareItem in self.shares){
//        [shareSheet addButtonWithTitle:shareItem.name];
//    }
//    shareSheet.cancelButtonIndex = [shareSheet addButtonWithTitle:ShareCancel];
//    [shareSheet showFromAppDelegate];
//    [shareSheet release];
    
    AWActionSheet *shareSheet = [[AWActionSheet alloc] initwithIconSheetDelegate:self ItemCount:self.shares.count];
    if(self.tabBarController) {
        [shareSheet showInView:self.tabBarController.view];
    }
    else {
        [shareSheet showInView:self.view];
    }
    [shareSheet release];
}

// subclasses should make sure emailBody and emailSubject are set up before this gets called
// or call [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex] at the end of this
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex >= 0 && buttonIndex < [self.shares count]){
        ShareItemEntitlement *shareItem = [self.shares objectAtIndex:buttonIndex];
        if ([shareItem.type isEqualToString:@"email"]){
            BOOL isHtml = NO;
            if([self.shareDelegate respondsToSelector:@selector(isHtmlBody)]) {
                isHtml = [self.shareDelegate isHtmlBody];
            }
            [MITMailComposeController presentMailControllerWithEmail:self email:nil subject:[self.shareDelegate emailSubject] body:[self.shareDelegate emailBody] isHtml:isHtml];
        }
        else if ([shareItem.type isEqualToString:@"sms"]){
            MFMessageComposeViewController *messageVC = [[[MFMessageComposeViewController alloc] init] autorelease];
            messageVC.body = [self.shareDelegate urlBody];
            NSInteger bodyLength = 140 > [messageVC.body length] ? [messageVC.body length] : 140;
            messageVC.body = [messageVC.body substringWithRange:NSMakeRange(0, bodyLength)];
            messageVC.messageComposeDelegate = self;
            if(messageVC) {
                // messageVC may be nil in iPod Touch
                //[MITAppDelegate() presentAppModalViewController:messageVC animated:YES];
                [self presentModalViewController:messageVC animated:YES];
            }
        }
        else if ([shareItem.type isEqualToString:@"url"]){
            NSString *body = [self.shareDelegate urlBody];
            if ([shareItem.url length] > 0 && [body length] > 0){
                NSInteger bodyLength = 140 > [body length] ? [body length] : 140;
                body = [body substringWithRange:NSMakeRange(0, bodyLength)];
                NSString *url = [NSString stringWithFormat:shareItem.url, [body UrlEncode]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }
    }
}
- (int)numberOfItemsInActionSheet {
    return self.shares.count;
}
- (AWActionSheetCell *)cellForActionAtIndex:(NSInteger)index {
    AWActionSheetCell* cell = [[[AWActionSheetCell alloc] init] autorelease];
    ShareItemEntitlement *shareItem = [self.shares objectAtIndex:index];
//    cell.iconView.image = shareItem.logo;
    [cell.iconButton setBackgroundImage:shareItem.logo forState:UIControlStateNormal];
    cell.titleLabel.text = shareItem.name;
    cell.titleLabel.textColor = [UIColor lightTextColor];
    cell.index = index;
    return cell;
}

- (void)DidTapOnItemAtIndex:(NSInteger)index {
    ShareItemEntitlement *shareItem = [self.shares objectAtIndex:index];
    if ([shareItem.type isEqualToString:@"email"]){
        // 邮件
        BOOL isHtml = NO;
        if([self.shareDelegate respondsToSelector:@selector(isHtmlBody)]) {
            isHtml = [self.shareDelegate isHtmlBody];
        }
        if([self.shareDelegate respondsToSelector:@selector(emailSubject)] && [self.shareDelegate respondsToSelector:@selector(emailBody)]) {
            [MITMailComposeController presentMailControllerWithEmail:self email:nil subject:[self.shareDelegate emailSubject] body:[self.shareDelegate emailBody] isHtml:isHtml];
        }
    }
    else if ([shareItem.type isEqualToString:@"sms"]) {
        // 短信
        MFMessageComposeViewController *messageVC = [[[MFMessageComposeViewController alloc] init] autorelease];
        messageVC.body = [self.shareDelegate urlBody];
//        NSInteger bodyLength = 140 > [messageVC.body length] ? [messageVC.body length] : 140;
//        messageVC.body = [messageVC.body substringWithRange:NSMakeRange(0, bodyLength)];
//        messageVC.body = [self.shareDelegate urlBody];
        messageVC.messageComposeDelegate = self;
        if(messageVC) {
            // messageVC may be nil in iPod Touch
            [self presentModalViewController:messageVC animated:YES];
        }
    }
    else if ([shareItem.type isEqualToString:@"url"]) {
        // 链接
        NSString *body = [self.shareDelegate urlBody];
        if ([shareItem.url length] > 0 && [body length] > 0){
//            NSInteger bodyLength = 140 > [body length] ? [body length] : 140;
//            body = [body substringWithRange:NSMakeRange(0, bodyLength)];
            NSString *url = [NSString stringWithFormat:shareItem.url, [body UrlEncode]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
    else if ([shareItem.type isEqualToString:@"weixin"]) {
        NSString *body = @"";
//        UIImage *image = nil;
//        WXImageObject *obj = nil;
        if([self.shareDelegate respondsToSelector:@selector(contentBody)]) {
            body = [self.shareDelegate contentBody];
        }
        
//        if([self.shareDelegate respondsToSelector:@selector(imageBody)]) {
//            image = [self.shareDelegate imageBody];
//            obj = [WXImageObject object];
//            obj.imageData = UIImagePNGRepresentation(image);
//        }
        // 发送内容给微信
        GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
        resp.text = body;
        resp.bText = YES;
        //resp.message.mediaObject = obj;
        
        [WXApi sendResp:resp];
    }
    else if([shareItem.type isEqualToString:@"sinawb"]) {
        // 发送内容到新浪微博
        WBMessageObject *message = [WBMessageObject message];
        NSString *body = @"";
        if([self.shareDelegate respondsToSelector:@selector(contentBody)]) {
            body = [self.shareDelegate contentBody];
        }
        message.text = body;
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
//        WBProvideMessageForWeiboResponse *response = [WBProvideMessageForWeiboResponse responseWithMessage:message];
//        if ([WeiboSDK sendResponse:response]) {
//        }
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissModalViewControllerAnimated:YES];
}
@end
