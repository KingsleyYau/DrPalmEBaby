//
//  CustomHeadImage.m
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-8-20.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomHeadImage.h"

@implementation HeadImage(Custom)

+(HeadImage*)imgWithUrl:(NSString*)url
{
    HeadImage* img = nil;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"url == %@",url];
    img = [[CoreDataManager objectsForEntity:HeadImageEntityName matchingPredicate:predicate] lastObject];
    if(!img)
    {
        img = [CoreDataManager insertNewObjectForEntityForName:HeadImageEntityName];
    }
    img.url = url;
    return img;
}

@end
