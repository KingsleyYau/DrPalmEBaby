//
//  CustromLastUpdate.m
//  DrPalm
//
//  Created by JiangBo on 13-3-5.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustromLastUpdate.h"
#import "LoginManager.h"

@implementation LastUpdate (Custom)

- (void)updateWithCategory:(NSInteger)category lastupdate:(NSDate*)lastupdate hasUser:(BOOL)hasUser
{
    self.category = [NSNumber numberWithInteger:category];
    self.lastupdate = lastupdate;
    if(hasUser)
        self.user = LoginManagerInstance().accountName;
    return;
}

@end
