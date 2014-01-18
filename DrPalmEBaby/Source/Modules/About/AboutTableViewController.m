#import "AboutTableViewController.h"
#import "MIT_MobileAppDelegate.h"
#import "UIKit+MITAdditions.h"
#import "AboutMITVC.h"
#import "AboutCreditsVC.h"
#import "UIKit+MITAdditions.h"
#import "MITUIConstants.h"
#import "MITMailComposeController.h"
#import "MITBuildInfo.h"
#import "AppEnviroment.h"
#import "CustomNavigationBar.h"
#import  <QuartzCore/CALayer.h>
#import "MITConstants.h"
#import "AboutLanguageDef.h"
#import "ResourceManager.h"
#import "UIImage+ResourcePath.h"

@implementation AboutTableViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [self.tableView applyStandardColors];
//    self.title = @"About";
    if (AppEnviromentInstance().globalUIEntitlement.navigationBarEntitlement.isShowImage && nil != AppEnviromentInstance().globalUIEntitlement.navigationBarEntitlement.titleImage){
        UIImageView *titleView = [[[UIImageView alloc] initWithImage:AppEnviromentInstance().globalUIEntitlement.navigationBarEntitlement.titleImage] autorelease];
        self.navigationItem.titleView = titleView;
    }
    else{
        self.navigationItem.title = AppEnviromentInstance().globalUIEntitlement.navigationBarEntitlement.titleString;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    // 设置背景图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedWithData:[ResourceManager resourceFilePath:DrPalmImageNameLoginBackground]]];
    imageView.frame = self.view.bounds;
    _tableView.backgroundView = imageView;
    [imageView release];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 45)];
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, footerView.frame.size.width, 30)];
    footerLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MITCopyright"];
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textAlignment = UITextAlignmentCenter;
    footerLabel.textColor = CELL_DETAIL_FONT_COLOR;
    footerLabel.font = [UIFont systemFontOfSize:12.0];
    footerLabel.lineBreakMode = UILineBreakModeWordWrap;
    footerLabel.numberOfLines = 0;
    [footerView addSubview:footerLabel];
    self.tableView.tableFooterView = footerView;
    [footerLabel release];
    [footerView release];
    
    UINavigationBar* navigationBar = [[self navigationController] navigationBar];
    navigationBar.tintColor = AppEnviromentInstance().globalUIEntitlement.navigationBarEntitlement.tintColor;
    [navigationBar setDefaultBackgroundImage];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
//            return 3;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSString *aboutText = AboutAppText;
        UIFont *aboutFont = [UIFont systemFontOfSize:14.0];
        CGSize aboutSize = [aboutText sizeWithFont:aboutFont constrainedToSize:CGSizeMake(270, 2000) lineBreakMode:UILineBreakModeWordWrap];
        return aboutSize.height + 20;
    }
    else {
        return self.tableView.rowHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.65];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.textLabel.textAlignment = UITextAlignmentLeft;
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
        			cell.textLabel.textColor = CELL_STANDARD_FONT_COLOR;
                    cell.textLabel.text = AboutVersion;
                    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [infoDict objectForKey:@"CFBundleDisplayName"], [infoDict objectForKey:@"CFBundleVersion"]];
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = AboutAppText;
                    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
                    cell.textLabel.numberOfLines = 0;
                    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        			cell.textLabel.textColor = CELL_STANDARD_FONT_COLOR;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
//                case 0:
//                    cell.textLabel.text = @"Credits";
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//                    cell.textLabel.textColor = CELL_STANDARD_FONT_COLOR;
//                    break;
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:AboutAppliction, ApplictionDisplayName];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.textLabel.textColor = CELL_STANDARD_FONT_COLOR;
                    cell.backgroundColor = [UIColor whiteColor];
                    break;
//                case 2:
//                    cell.textLabel.text = @"Send Feedback";
//                    cell.accessoryView = [UIImageView accessoryViewWithMITType:MITAccessoryViewEmail];
//                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//                    break;
                break;
            }
        default:
            break;
    }
    
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
//        showBuildNumber = !showBuildNumber;
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
//            case 0: {
//                AboutCreditsVC *aboutCreditsVC = [[AboutCreditsVC alloc] init];
//                [self.navigationController pushViewController:aboutCreditsVC animated:YES];
//                [aboutCreditsVC release];
//                break;
//            }
            case 0: {
                AboutMITVC *aboutMITVC = [[AboutMITVC alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:aboutMITVC animated:YES];
                [aboutMITVC release];
                break;
            }
//            case 2: {
//                NSString *email = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MITFeedbackAddress"];
//                NSString *subject = [NSString stringWithFormat:@"Feedback for MIT Mobile %@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], [MITBuildInfo description]];
//                
//                if ([MFMailComposeViewController canSendMail]) {
//                    MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
//                    [mailView setMailComposeDelegate:self];
//                    [mailView setSubject:subject];
//                    [mailView setToRecipients:[NSArray arrayWithObject:email]];
//                    [self presentModalViewController:mailView
//                                            animated:YES]; 
//                }            
//            }            
            default:
                break;
        }
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark MFMailComposeViewController delegation

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	[self dismissModalViewControllerAnimated:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end

