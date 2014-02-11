//
//  CustomClassImage.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomClassImage.h"
#import "ClassDataManager.h"
@implementation ClassImage (Custom)
#pragma mark - ExplainImageDictionary
/*
 * Exsample:
 * {image:{"fullURL":"","thumb152":"","thumbURL":"","smallURL":""}}
 */
+ (NSString *)fullImageUrlWithDict:(NSDictionary *)dict {
    NSString *value = nil;
    id foundValue = [dict objectForKey:@"fullURL"];
    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]) {
        value = foundValue;
    }
    return value;
}
- (void)updateWithImageDict:(NSDictionary *)dict isLocal:(Boolean)isLocal{
    //    id foundValue;
    //    foundValue = [dict objectForKey:SMALURL];
    //    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]) {
    //        SchoolFile *file = [SchoolDataManager fileWithUrl:foundValue isLocal:isLocal];
    //        self.smallImage = file;
    //    }
    //    foundValue = [dict objectForKey:THUMBURL];
    //    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]) {
    //        SchoolFile *file = [SchoolDataManager fileWithUrl:foundValue isLocal:isLocal];
    //        self.thumbImage = file;
    //    }
    //    foundValue = [dict objectForKey:THUMB152];
    //    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]) {
    //        SchoolFile *file = [SchoolDataManager fileWithUrl:foundValue isLocal:isLocal];
    //        self.thumb152Image = file;
    //    }
}

#pragma mark - ExplainImageFullUrl
- (void)updateWithFullUrl:(NSString *)url isLocal:(Boolean)isLocal{
    ClassFile *file = [ClassDataManager fileWithUrl:url isLocal:isLocal];
    self.fullImage = file;
    [file addFullParentObject:self];
}
@end
