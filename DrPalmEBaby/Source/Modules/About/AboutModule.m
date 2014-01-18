#import "AboutModule.h"
#import "MITModule.h"
#import "AboutTableViewController.h"
#import "AboutLanguageDef.h"

@implementation AboutModule
+ (NSString*)moduleName
{
    return @"About";
}

- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = AboutTag;
        self.shortName = AboutModuleTitle;
        self.longName = AboutModuleTitle;
        self.iconName = @"about";
        self.isMovableTab = FALSE;
        
        //moduleHomeController.title = self.longName;
        
        //AboutTableViewController *aboutVC = [[[AboutTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        //aboutVC.title = self.longName;
        
        //[self.tabNavController setViewControllers:[NSArray arrayWithObject:aboutVC]];
    }
    return self;
}

- (UIViewController *)moduleHomeController {
    if (!moduleHomeController) {
        moduleHomeController = [[AboutTableViewController alloc] initWithNibName:nil bundle:nil];
    }
    return moduleHomeController;
}

@end
