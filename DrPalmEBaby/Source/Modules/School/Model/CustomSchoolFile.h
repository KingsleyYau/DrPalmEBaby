//
//  CustomSchoolFile.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolFile.h"

#define FILE_TYPE_URL           0
#define FILE_TYPE_LOCALPATH     1

@interface SchoolFile (Custom)
- (void)updateWithImageUrl:(NSString *)url isLocal:(Boolean)isLocal;
@end
