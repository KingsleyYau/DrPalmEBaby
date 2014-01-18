//
//  CustomSchoolImage.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolImage.h"
@interface SchoolImage (Custom)
// for {image:{"fullURL":"","thumb152":"","thumbURL":"","smallURL":""}}
+ (NSString *)fullImageUrlWithDict:(NSDictionary *)dict;
- (void)updateWithImageDict:(NSDictionary *)dict isLocal:(Boolean)isLocal;

// for only full url
- (void)updateWithFullUrl:(NSString *)url isLocal:(Boolean)isLocal;
@end
