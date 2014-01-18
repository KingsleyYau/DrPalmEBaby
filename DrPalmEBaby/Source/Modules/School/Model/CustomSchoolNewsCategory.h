//
//  CustomSchoolNewsCategory.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//
/*
 * NSDate * lastUpdateChannel       :分类从服务器刷下来的最后更新时间;
 * NSDate * lastUpdateChannelList   :分类刷新列表服务器返回的最后一条item的更新时间;
 * NSDate * lastUpdated             :分类本地最后刷新时间,仅用于下拉列表显示;
 */
#import <Foundation/Foundation.h>
#import "SchoolNewsCategory.h"

#define  SCHOOLMODULES       @"schoolmodule"
#define  MAILMOUDLE          @"mailmodule"


#define TYPE_LIST   @"list"
#define TYPE_ALBUM  @"album"
@interface SchoolNewsCategory (Custom)

@end
