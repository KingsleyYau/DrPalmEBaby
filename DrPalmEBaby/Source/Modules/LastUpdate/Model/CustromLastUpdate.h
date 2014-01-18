//
//  CustromLastUpdate.h
//  DrPalm
//
//  Created by JiangBo on 13-3-5.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LastUpdate.h"

@interface LastUpdate(Custom)
- (void)updateWithCategory:(NSInteger)category lastupdate:(NSDate*)lastupdate hasUser:(BOOL)hasUser;
@end
