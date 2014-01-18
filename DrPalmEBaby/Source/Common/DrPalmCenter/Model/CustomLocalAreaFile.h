//
//  CustomLocalAreaFile.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalAreaFile.h"

#define FILE_TYPE_URL           0
#define FILE_TYPE_LOCALPATH     1

@interface LocalAreaFile (Custom)
- (void)updateWithImageUrl:(NSString *)url isLocal:(Boolean)isLocal;
@end
