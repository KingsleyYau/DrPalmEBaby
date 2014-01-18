#import "AboutMITVC.h"
#import "UIKit+MITAdditions.h"
#import "MITUIConstants.h"
#import "AboutLanguageDef.h"
#import "ResourceManager.h"
#import "UIImage+ResourcePath.h"

@implementation AboutMITVC
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    self.navigationItem.title = AboutModuleTitle;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    // 设置背景图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedWithData:[ResourceManager resourceFilePath:DrPalmImageNameLoginBackground]]];
    imageView.frame = self.view.bounds;
    _tableView.backgroundView = imageView;
    [imageView release];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *aboutText = AboutText;
    UIFont *aboutFont = [UIFont systemFontOfSize:18.0];
    CGSize aboutSize = [aboutText sizeWithFont:aboutFont constrainedToSize:CGSizeMake(270, 2000) lineBreakMode:UILineBreakModeWordWrap];
    
    aboutSize.height += 14;
    return aboutSize.height;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = AboutText;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = CELL_STANDARD_FONT_COLOR;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
	
    return cell;
}

@end

