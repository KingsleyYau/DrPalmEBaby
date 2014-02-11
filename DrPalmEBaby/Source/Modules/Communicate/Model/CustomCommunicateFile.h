//
//  CustomClassFile.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicateFile.h"

#define FILE_TYPE_URL           0
#define FILE_TYPE_LOCALPATH     1

@interface CommunicateFile (Custom)
+ (NSString*)headImgUrlWithDict:(NSDictionary *)dict;
- (void)updateWithImageUrl:(NSString *)url isLocal:(Boolean)isLocal;
@end
