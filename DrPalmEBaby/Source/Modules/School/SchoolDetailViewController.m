//
//  SchoolDetailViewController.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SchoolDetailViewController.h"
#import "SchoolAttachmentDownloader.h"
#import "SchoolAttachmentController.h"

#import "SchoolCommonDef.h"

#define ThumbImage_Long          120      //拇指图长边长度

@interface SchoolDetailViewController () <SchoolAttachmentDownloaderDelegate, SchoolRequestOperatorDelegete>
@property (nonatomic, retain) SchoolRequestOperator* requestOperator;
@end

@implementation SchoolDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupWebView];
    self.shareDelegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![self.item.read boolValue])
        [self loadFromServer];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - (界面逻辑)
- (void)setupNavigationBar {
    SchoolNewsCategory *category = [[self.item.categories allObjects] lastObject];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //titleLabel.text = NSLocalizedString(category.title, nil);
    titleLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(category.title, nil),NSLocalizedString(@"CommonDetail", nil)];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupWebView {
    self.webView.scrollView.bounces = NO;
}
- (void)setupKKButtonBar {
    // 附件
    if([self.item.subImage count] > 0) {
        self.attachmentButton.hidden = NO;
        [self.attachmentButton setBadgeValue:[NSString stringWithFormat:@"%d", [self.item.subImage count]]];
    }
    else {
        [self.attachmentButton setBadgeValue:nil];
        self.attachmentButton.hidden = YES;
    }
    // 收藏
    UIImage *image = nil;
    if([self.item.bookmarked boolValue]) {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonDetailBookmarkOnButton ofType:@"png"]];
    }
    else {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonDetailBookmarkOffButton ofType:@"png"]];
    }
    [self.bookmarkButton setImage:image forState:UIControlStateNormal];
}
- (IBAction)attachmentAction:(id)sender {
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    SchoolAttachmentController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SchoolAttachmentController"];
    vc.item = self.item;
    [nvc pushViewController:vc animated:YES gesture:NO];
}
- (IBAction)bookmarkAction:(id)sender {
    self.item.bookmarked = [NSNumber numberWithBool:![self.item.bookmarked boolValue]];
    [CoreDataManager saveData];
    [self reloadData];
    [self setupKKButtonBar];
}
- (void)reloadData {
    self.item = [SchoolDataManager newsWithId:self.item.story_id];
    [self displayItem];
    [self setupKKButtonBar];
}
- (void)displayItem/*:(NewsStory *)item*/ {
	NSURL *baseURL = [NSURL fileURLWithPath:[ResourceManager resourcePath] isDirectory:YES];
    NSURL *fileURL = [NSURL URLWithString:SchoolDetailTemplate relativeToURL:baseURL];
    
    NSError *error = nil;
    NSMutableString *htmlString = [NSMutableString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    if (!htmlString) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, y"];
    NSString *postDate = [dateFormatter stringFromDate:self.item.postdate];
    
    
    NSString *thumbnailURL = self.item.mainImage.fullImage.path;
    NSData* thumbnailData = self.item.mainImage.fullImage.data;
    if(thumbnailData == nil)
    {
        SchoolAttachmentDownloader* attachmentDownloader = [[SchoolAttachmentDownloader alloc] init];
        [attachmentDownloader startDownload:thumbnailURL delegate:self];
    }
    UIImage *image = [UIImage imageWithData:thumbnailData];
    
    //压缩
    float width = image.size.width;
    float height = image.size.height;
    if(image.size.width > ThumbImage_Long || image.size.height > ThumbImage_Long )
    {
        if(image.size.width > image.size.height)
        {
            width = ThumbImage_Long;
            height = (image.size.height * ThumbImage_Long)/image.size.width;
        }
        else
        {
            height = ThumbImage_Long;
            width  = (image.size.width * ThumbImage_Long)/image.size.height;
        }
    }
    
    NSString *thumbnailWidth = [NSString stringWithFormat:@"%f",width];
    NSString *thumbnailHeight =[NSString stringWithFormat:@"%f",height];
    //NSString *thumbnailWidth = [item.inlineImage.smallImage.width stringValue];
    // NSString *thumbnailHeight = [item.inlineImage.smallImage.height stringValue];
    if (!thumbnailURL) {
        thumbnailURL = @"";
    }
    if (!thumbnailWidth) {
        thumbnailWidth = @"0";
    }
    if (!thumbnailHeight) {
        thumbnailHeight = @"0";
    }
    
    NSString *maxWidth = [NSString stringWithFormat:@"%.0f", self.webView.frame.size.width - 2 * BLANKING_X];
    
    NSArray *keys = [NSArray arrayWithObjects:
                     @"__TITLE__", @"__WIDTH__", @"__AUTHOR__", @"__DATE__",
                     @"__THUMBNAIL_DATA__", @"__THUMBNAIL_WIDTH__", @"__THUMBNAIL_HEIGHT__",
                     @"__GALLERY_COUNT__",@"__DEK__",@"__BODY__", nil];
    
    
    NSString* attachmentcountstring = self.item.subImage!=nil?[NSString stringWithFormat:@"%d",self.item.subImage.count]:@"0";
    NSString* thumbdatastring  =  thumbnailData==nil?@"":[thumbnailData base64EncodingWithLineLength:0];
    
    NSArray *values = [NSArray arrayWithObjects:
                       self.item.title==nil?@"":self.item.title, maxWidth, self.item.author==nil?@"":self.item.author, postDate==nil?@"":postDate,
                       thumbdatastring,thumbnailWidth,thumbnailHeight,
                       attachmentcountstring,
                       self.item.abstract==nil?@"":self.item.abstract,
                       self.item.body==nil?@"":self.item.body,
                       nil];
    
    [htmlString replaceOccurrencesOfStrings:keys withStrings:values options:NSLiteralSearch];
    
	[CoreDataManager saveDataWithTemporaryMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
	[self.webView loadHTMLString:htmlString baseURL:baseURL];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	BOOL result = YES;
    
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *url = [request URL];
        NSURL *baseURL = [NSURL fileURLWithPath:[ResourceManager resourcePath]];
        
        if ([[url path] rangeOfString:[baseURL path] options:NSAnchoredSearch].location == NSNotFound) {
            [[UIApplication sharedApplication] openURL:url];
            result = NO;
        } else {
            if ([[url path] rangeOfString:@"image" options:NSBackwardsSearch].location != NSNotFound) {
                //attachmentcontroller
                [self attachmentAction:nil];
            }
		}
	}
	return result;
}


#pragma mark - (协议请求)
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
        self.requestOperator = nil;
    }
}
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[SchoolRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    return [self.requestOperator getNewsDetail:self.item.story_id isAllField:self.needLoadAllDetail];
}
- (void)operateFinish:(id)data requestType:(SchoolRequestOperatorStatus)type {
    //[_loadingview hideLoading:YES];
    self.item.read = [NSNumber numberWithBool:YES];
    [CoreDataManager saveData];
    [self cancel];
    [self reloadData];
}
- (void)operateFail:(NSString*)error requestType:(SchoolRequestOperatorStatus)type {
    //[_loadingview hideLoading:YES];
    [self cancel];
}
#pragma mark - (下载回调)
- (BOOL)attachmentDownloader:(SchoolAttachmentDownloader*)attachmentDownloader startDownload:(NSString*)contentType {
    return YES;
}
- (void)attachmentDownloader:(SchoolAttachmentDownloader*)attachmentDownloader downloadFinish:(NSData*)data contentType:(NSString*)contentType {
    self.item.mainImage.fullImage.data = data;
    SchoolFile *file = [SchoolDataManager fileWithUrl:self.item.mainImage.fullImage.path isLocal:NO];
    if(file) {
        file.data = data;
        file.contenttype = contentType;
        [CoreDataManager saveData];
    }
    [self reloadData];
    return;
}
- (void)attachmentDownloader:(SchoolAttachmentDownloader *)attachmentDownloader downloadFail:(NSError*)error {
    return;
}
#pragma mark -  (分享回调ShareItemDelegate)
- (NSString *)actionSheetTitle {
	return @"";
}
- (NSString *)emailSubject {
	return [NSString stringWithFormat:@"%@", self.item.title];
}
- (NSString *)emailBody{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"%@\n%@", self.item.title,self.item.shareurl, nil];
	return body;
}
- (NSString*)urlBody
{
    NSString *urlBody = @"";
    urlBody = [self emailBody];
    return urlBody;
}
- (BOOL)isHtmlBody {
    return NO;
}
- (NSString *)contentBody {
    return [self emailBody];
}
@end
