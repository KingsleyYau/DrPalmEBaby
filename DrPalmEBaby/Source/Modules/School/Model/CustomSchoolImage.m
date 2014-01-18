//
//  CustomSchoolImage.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomSchoolImage.h"
#import "SchoolDataManager.h"
#import "SchoolNewsDefine.h"

@implementation SchoolImage (Custom)
#pragma mark - ExplainImageDictionary
/*
 * Exsample:
 * {image:{"fullURL":"","thumb152":"","thumbURL":"","smallURL":""}}
 */
+ (NSString *)fullImageUrlWithDict:(NSDictionary *)dict {
    NSString *value = nil;
    id foundValue = [dict objectForKey:FullUrl];
    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]) {
        value = foundValue;
    }
    return value;
}
- (void)updateWithImageDict:(NSDictionary *)dict isLocal:(Boolean)isLocal{
    id foundValue;
    foundValue = [dict objectForKey:SmallUrl];
    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]) {
        SchoolFile *file = [SchoolDataManager fileWithUrl:foundValue isLocal:isLocal];
        self.smallImage = file;
    }
    foundValue = [dict objectForKey:ThumbUrl];
    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]) {
        SchoolFile *file = [SchoolDataManager fileWithUrl:foundValue isLocal:isLocal];
        self.thumbImage = file;
    }
}

#pragma mark - ExplainImageFullUrl
- (void)updateWithFullUrl:(NSString *)url isLocal:(Boolean)isLocal{
    SchoolFile *file = [SchoolDataManager fileWithUrl:url isLocal:isLocal];
    self.fullImage = file;
    [file addFullParentObject:self];
}
@end
