//
//  CustomClassFile.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomClassFile.h"

@implementation ClassFile (Custom)

+(NSString*) urlWithDict:(NSDictionary*)dict
{
    return [dict objectForKey:@"atturl"];
}
+(NSString*)preViewUrlWithDict:(NSDictionary*)dict {
    return [dict objectForKey:@"attpreview"];
}
- (void)updateWithImageUrl:(NSString *)url isLocal:(Boolean)isLocal {
    if(nil != self.path && ![self.path isEqualToString:url]) {
        // 文件路径更新，清除旧数据
        self.data = nil;
        if(isLocal) {
            // 本地文件
            self.pathtype = [NSNumber numberWithInt:FILE_TYPE_LOCALPATH];
        }
        else {
            // 网络文件
            self.pathtype = [NSNumber numberWithInt:FILE_TYPE_URL];
        }
    }
    self.path = url;
}
@end
