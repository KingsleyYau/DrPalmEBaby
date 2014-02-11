//
//  CustomSystemMessage.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemMessage.h"
@interface SystemMessage (Custom)
+ (id)idWithDict:(NSDictionary *)dict;

- (void)updateWithDict:(NSDictionary *)dict;
@end
