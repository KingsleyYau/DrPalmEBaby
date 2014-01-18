//
//  ClassDetailSentInfoTableView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-5.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "ClassDetailSentInfoTableView.h"
#import "ClassCommonDef.h"
#import <EventKitUI/EventKitUI.h>

typedef enum {
    ClassDetailRowTypeTitle,
    ClassDetailRowTypeSender,
    ClassDetailRowTypeRecevier,
	ClassDetailRowTypeTime,
    ClassDetailRowTypePostTime,
	ClassDetailRowTypeLocation,
    ClassDetailRowTypeBody,
} RowType;
@interface ClassDetailSentInfoTableView () <UITableViewDelegate, UITableViewDataSource, EKEventEditViewDelegate> {
    
}
@property (nonatomic, retain) NSArray *itemArray;
@end

@implementation ClassDetailSentInfoTableView
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
        
        NSString *version = [[UIDevice currentDevice] systemVersion];
        if(NSOrderedDescending == [version compare:@"7"]) {
            // TODO:IOS 7.0 or later
            self.separatorInset = UIEdgeInsetsZero;
        }
    }
    return self;
}
- (void)reloadData {
    self.delegate = self;
    self.dataSource = self;
    if(self.item) {
        //ClassEventCategory *category = [[self.classevent.categories allObjects] lastObject];
        // 判断需要显示的属性
        NSMutableArray *array = [NSMutableArray array];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        NSString *textTitle;
        CGSize viewSize;
        CGFloat tableHeight = 0;
        NSValue *rowSize;
        
        // 发件人
        dictionary = [NSMutableDictionary dictionary];
        textTitle = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Sender", nil), self.item.pubName];
        viewSize = [textTitle sizeWithFont:[UIFont boldSystemFontOfSize:17]
                         constrainedToSize:CGSizeMake(self.frame.size.width - 2 * BLANKING_X, MAXFLOAT)
                             lineBreakMode:NSLineBreakByClipping];
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:ClassDetailRowTypeSender] forKey:ROW_TYPE];
        [array addObject:dictionary];
        tableHeight += viewSize.height;
        tableHeight += 2 * BLANKING_Y;
        
        // 收件人
        dictionary = [NSMutableDictionary dictionary];
        textTitle = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Receiver", nil), self.item.owner];
        viewSize = [textTitle sizeWithFont:[UIFont boldSystemFontOfSize:17]
                         constrainedToSize:CGSizeMake(self.frame.size.width - 4 * BLANKING_X, MAXFLOAT)
                             lineBreakMode:NSLineBreakByClipping];
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:ClassDetailRowTypeRecevier] forKey:ROW_TYPE];
        [array addObject:dictionary];
        tableHeight += viewSize.height;
        tableHeight += 2 * BLANKING_Y;
        
//        // 有效期
//        dictionary = [NSMutableDictionary dictionary];
//        //        textTitle = [NSString stringWithFormat:@"%@:%@\n%@", ClasseffectivePeriod, [self.classevent.startDate toString2YMDHM], [self.classevent.endDate toString2YMDHM], nil];
//        //        viewSize = [textTitle sizeWithFont:[UIFont boldSystemFontOfSize:UITableViewDetailDescriptionLabelFontSize]
//        //                         constrainedToSize:CGSizeMake(_tableView.frame.size.width - 2 * BLANKING_X, 2010.0)
//        //                             lineBreakMode:UILineBreakModeClip];
//        viewSize = CGSizeMake(self.frame.size.width - 2 * BLANKING_X, 44);
//        rowSize = [NSValue valueWithCGSize:viewSize];
//        [dictionary setValue:rowSize forKey:ROW_SIZE];
//        [dictionary setValue:[NSNumber numberWithInteger:ClassDetailRowTypeTime] forKey:ROW_TYPE];
//        [array addObject:dictionary];
//        tableHeight += viewSize.height;
//        tableHeight += 2 * BLANKING_Y;
        
        // 发布日期
        dictionary = [NSMutableDictionary dictionary];
        textTitle = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"PostTime", nil), [self.item.postDate toString2YMDHM], nil];
        viewSize = [textTitle sizeWithFont:[UIFont boldSystemFontOfSize:17]
                         constrainedToSize:CGSizeMake(self.frame.size.width - 2 * BLANKING_X, MAXFLOAT)
                             lineBreakMode:NSLineBreakByClipping];
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:ClassDetailRowTypePostTime] forKey:ROW_TYPE];
        [array addObject:dictionary];
        tableHeight += viewSize.height;
        tableHeight += 2 * BLANKING_Y;
        
//        //if(![category.category_id isEqualToString:ClassCategoryIdAlbum]) {
//            // 地点
//            dictionary = [NSMutableDictionary dictionary];
//            textTitle = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Location", nil), self.item.location];
//            viewSize = [textTitle sizeWithFont:[UIFont boldSystemFontOfSize:17]
//                             constrainedToSize:CGSizeMake(self.frame.size.width - 2 * BLANKING_X, MAXFLOAT)
//                                 lineBreakMode:NSLineBreakByClipping];
//            rowSize = [NSValue valueWithCGSize:viewSize];
//            [dictionary setValue:rowSize forKey:ROW_SIZE];
//            [dictionary setValue:[NSNumber numberWithInteger:ClassDetailRowTypeLocation] forKey:ROW_TYPE];
//            [array addObject:dictionary];
//            tableHeight += viewSize.height;
//            tableHeight += 2 * BLANKING_Y;
//        //}

        
        // 普通属性重新计算高度
        self.itemArray = array;

        // 详细列表重新计算高度
        if([self.tableViewDelegate respondsToSelector:@selector(reSizetableViewHeight:newHeight:)]) {
            [self.tableViewDelegate reSizetableViewHeight:self newHeight:tableHeight];
        }

    }
    [super reloadData];
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.itemArray.count;
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *result = nil;
    static NSString *cellIdentifier;

    NSDictionary *dictionarry = [self.itemArray objectAtIndex:indexPath.row];
    
    // 大小
    CGSize viewSize;
    NSValue *value = [dictionarry valueForKey:ROW_SIZE];
    [value getValue:&viewSize];
    
    // 类型
    RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
    switch (type) {
            // 图片
        case ClassDetailRowTypeSender: {
            cellIdentifier = @"ClassDetailRowTypeSender";
            result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!result) {
                result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                result.backgroundColor = [UIColor clearColor];
                result.accessoryType = UITableViewCellAccessoryNone;
                result.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSString *textTitle = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Sender", nil), self.item.pubName];
            result.textLabel.text = textTitle;
            result.textLabel.font = [UIFont boldSystemFontOfSize:17];
            result.textLabel.textColor = [UIColor colorWithIntRGB:102 green:102 blue:102 alpha:255];
        }break;
        case ClassDetailRowTypeRecevier: {
            cellIdentifier = @"ClassDetailRowTypeRecevier";
            result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!result) {
                result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                result.backgroundColor = [UIColor clearColor];
                result.accessoryType = UITableViewCellAccessoryNone;
                result.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSString *textTitle = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Receiver", nil), self.item.owner];
            result.textLabel.text = textTitle;
            result.textLabel.font = [UIFont boldSystemFontOfSize:17];
            result.textLabel.textColor = [UIColor colorWithIntRGB:102 green:102 blue:102 alpha:255];
            result.textLabel.lineBreakMode = NSLineBreakByClipping;
            result.textLabel.numberOfLines = 0;
        }break;
        case ClassDetailRowTypeTime: {
            cellIdentifier = @"ClassDetailRowTypeTime";
            
            result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!result) {
                result = [[MultiLineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                result.backgroundColor = [UIColor clearColor];
                result.accessoryType = UITableViewCellAccessoryNone;
                result.selectionStyle = UITableViewCellSelectionStyleBlue;
                
                //                    startLabel = [[[UILabel alloc] initWithFrame:CGRectMake(BLANKING_X, 0, tableView.frame.size.width - BUTTON_CALENDAR_SIZE - 2 * BLANKING_X, 44)] autorelease];
                //                    startLabel.tag = tagStart;
                //                    [result.contentView addSubview:startLabel];
                //
                //                    endLabel = [[[UILabel alloc] initWithFrame:CGRectMake(BLANKING_X, 44, tableView.frame.size.width - BUTTON_CALENDAR_SIZE - 2 * BLANKING_X, 44)] autorelease];
                //                    endLabel.tag = tagEnd;
                //                    [result.contentView addSubview:endLabel];
                //
                //                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                //                    button.frame = CGRectMake(tableView.frame.size.width - BUTTON_CALENDAR_SIZE - BLANKING_X, 22, BUTTON_CALENDAR_SIZE, BUTTON_CALENDAR_SIZE);
                //                    button addTarget:self action:@selector(ca) forControlEvents:￼
                
            }
            
            //                NSString *textTitle = [NSString stringWithFormat:@"%@:%@\r\n%@", ClasseffectivePeriod, [self.classevent.startDate toString2YMDHM], [self.classevent.endDate toString2YMDHM], nil];
            //                result.textLabel.text = textTitle;
            result.textLabel.font = [UIFont boldSystemFontOfSize:17];
            result.textLabel.textColor = [UIColor colorWithIntRGB:102 green:102 blue:102 alpha:255];
            //result.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            
            result.textLabel.text =
            [self.item dateStringWithDateStyle:NSDateFormatterFullStyle
                                           timeStyle:NSDateFormatterShortStyle
                                           separator:@"\n"];
//            result.accessoryView = [UIImageView accessoryViewWithMITType:MITAccessoryViewCalendar];
        }break;
        case ClassDetailRowTypePostTime: {
            cellIdentifier = @"ClassDetailRowTypePostTime";
            result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!result) {
                result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                result.backgroundColor = [UIColor clearColor];
                result.accessoryType = UITableViewCellAccessoryNone;
                result.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSString *textTitle = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"PostTime", nil), [self.item.postDate toString2YMDHM], nil];
            result.textLabel.text = textTitle;
            result.textLabel.font = [UIFont boldSystemFontOfSize:17];
            result.textLabel.textColor = [UIColor colorWithIntRGB:102 green:102 blue:102 alpha:255];
        }break;
        case ClassDetailRowTypeLocation: {
            cellIdentifier = @"ClassDetailRowTypeLocation";
            result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!result) {
                result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                result.backgroundColor = [UIColor clearColor];
                result.accessoryType = UITableViewCellAccessoryNone;
                result.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSString *textTitle = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Location", nil), self.item.location];
            result.textLabel.text = textTitle;
            result.textLabel.font = [UIFont boldSystemFontOfSize:17];
            result.textLabel.textColor = [UIColor colorWithIntRGB:102 green:102 blue:102 alpha:255];
        }break;
        default:break;
    }
    
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;

    NSDictionary *dictionarry = [self.itemArray objectAtIndex:indexPath.row];
    
    CGSize viewSize;
    NSValue *value = [dictionarry valueForKey:ROW_SIZE];
    [value getValue:&viewSize];
    
    height = viewSize.height + 2 * BLANKING_Y;

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 类型
    NSDictionary *dictionarry = [self.itemArray objectAtIndex:indexPath.row];
    RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
    switch (type) {
        case ClassDetailRowTypeTime:
        {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
//            NSAutoreleasePool *eventAddPool = [[NSAutoreleasePool alloc] init];
            
            EKEvent *newEvent = [EKEvent eventWithEventStore:eventStore];
            newEvent.calendar = [eventStore defaultCalendarForNewEvents];
            [self.item setUpEKEvent:newEvent];
            
            //                NSInteger rowCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
            //                NSInteger likelyIndexOfDescriptionRow = rowCount - 2;
            //                NSIndexPath *descriptionIndexPath = [NSIndexPath indexPathForRow:likelyIndexOfDescriptionRow inSection:indexPath.section];
            //                if (descriptionIndexPath.row > 0) {
            //                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:descriptionIndexPath];
            //                    UIWebView *webView = (UIWebView *)[cell viewWithTag:kDescriptionWebViewTag];
            //                    NSString *result = [webView stringByEvaluatingJavaScriptFromString:
            //                                        @"function f(){ return document.body.innerText; } f();"];
            //                    if (result) {
            //                        newEvent.notes = result;
            //                    }
            //                }
            newEvent.notes = self.item.body;//[_webViewBody stringByEvaluatingJavaScriptFromString:@"function f(){ return document.body.innerText; } f();"];
            
//            MIT_MobileAppDelegate* application = (MIT_MobileAppDelegate*)[[UIApplication sharedApplication] delegate];
//            [application.tabBarController hideFootView];
            
            EKEventEditViewController *eventViewController =
            [[EKEventEditViewController alloc] init];
            eventViewController.event = newEvent;
            eventViewController.eventStore = eventStore;
            eventViewController.editViewDelegate = self;
            [self.vc presentModalViewController:eventViewController animated:YES];
            
//            [eventAddPool drain];
//            [eventStore release];
            
        }break;
            
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark EKEventEditViewDelegate
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action {
    [controller dismissModalViewControllerAnimated:YES];
    
//    MIT_MobileAppDelegate* application = (MIT_MobileAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [application.tabBarController showFootView];
}

@end
