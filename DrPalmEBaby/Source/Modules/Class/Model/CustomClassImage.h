//
//  CustomClassImage.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassImage.h"
@interface ClassImage (Custom)
// for {image:{"fullURL":"","thumb152":"","thumbURL":"","smallURL":""}}
+ (NSString *)fullImageUrlWithDict:(NSDictionary *)dict;
- (void)updateWithImageDict:(NSDictionary *)dict isLocal:(Boolean)isLocal;

// for only full url
- (void)updateWithFullUrl:(NSString *)url isLocal:(Boolean)isLocal;
@end
