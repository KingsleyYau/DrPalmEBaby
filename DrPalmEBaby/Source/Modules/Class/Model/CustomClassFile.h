//
//  CustomClassFile.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassFile.h"

#define FILE_TYPE_URL           0
#define FILE_TYPE_LOCALPATH     1

@interface ClassFile (Custom)
+(NSString*)urlWithDict:(NSDictionary*)dict;
+(NSString*)preViewUrlWithDict:(NSDictionary*)dict;
- (void)updateWithImageUrl:(NSString *)url isLocal:(Boolean)isLocal;
@end
