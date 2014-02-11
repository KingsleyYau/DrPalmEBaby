//
//  LatestSchoolNewsViewController.h
//  DrPalm
//
//  Created by KingsleyYau on 13-4-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LatestSchoolNewsTableView.h"
@interface LatestSchoolNewsViewController : BaseViewController <EGORefreshTableHeaderDelegate>{
    
}
@property (nonatomic, weak) IBOutlet LatestSchoolNewsTableView *tableView;
@end
