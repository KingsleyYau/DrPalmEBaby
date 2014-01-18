//
//  CustomSchoolNews.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomSchoolNews.h"
#import "SchoolNewsDefine.h"
#import "SchoolDataManager.h"

@implementation SchoolNews (Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict {
    return [dict objectForKey:StoryId];
}

+ (BOOL)isDeleteNews:(NSDictionary *)dict
{
    id status = [dict objectForKey:Status];
    if(status != nil && status != [NSNull null] && [status isKindOfClass:[NSString class]])
    {
        NSString* str = (NSString*)status;
        if([str isEqualToString:@"C"])
            return YES;
    }
    return NO;
}

- (void)updateWithDict:(NSDictionary *)dict {
    //storyid
    self.story_id = [SchoolNews idWithDict:dict];
    
    //title
    id foundValue = [dict objectForKey:Title];
    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]){
        self.title = foundValue;
    }
    
    //Author
    foundValue = [dict objectForKey:Author];
    if(nil != foundValue && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
    {
        self.author = foundValue;
    }

    //Body
    foundValue = [dict objectForKey:Body];
    if(nil != foundValue && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
    {
        self.body = foundValue;
    }
    
    //PostDate
    foundValue = [dict objectForKey:PostDate];
    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSNumber class]]){
        double postTime = [foundValue doubleValue];
        if (postTime) {
            self.postdate = [NSDate dateWithTimeIntervalSince1970:postTime];
        }
    }
    
    //Status
    foundValue = [dict objectForKey:Status];
    if(nil != foundValue && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
    {
        self.status = foundValue;
    }
    
    //abstract
    foundValue = [dict objectForKey:Abstract];
    if(nil != foundValue && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
    {
        self.abstract = foundValue;
    }
    
    //shareurl
    foundValue = [dict objectForKey:ShareUrl];
    if(nil != foundValue && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]])
    {
        self.shareurl = foundValue;
    }
    
    // 分类
    foundValue = [dict objectForKey:Channel];
    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]){
        SchoolNewsCategory *category = [SchoolDataManager categaoryWithId:foundValue];
        // 添加分类对象到新闻
        [self addCategoriesObject:category];
        // 添加新闻对象到分类
        [category addNewsObject:self];
    }
    
    //lastupdate
    foundValue = [dict objectForKey:LastUpdate];
    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSNumber class]]){
        double lastupdate = [foundValue doubleValue];
        if (lastupdate) {
            self.lastUpdate = [NSDate dateWithTimeIntervalSince1970:lastupdate];
        }
    }
    
    //thumburl
    foundValue = [dict objectForKey:ThumbUrl];
    //foundValue = @"http://42.120.45.72/schoolnews/images/smallURL/176_1.jpeg";
   // foundValue = @"http://img0.autoimg.cn/upload/spec/7741/u_20100504093230259264.jpg";
    if (nil != foundValue && foundValue != [NSNull null] &&  [foundValue isKindOfClass:[NSString class]]){
        self.mainImage = [SchoolDataManager imageWithImageFullUrl:foundValue isLocal:NO];
        [self.mainImage addMainImageParentObject:self];
    }
    
    
    
    // Image
    //NSString* url = @"http://img0.autoimg.cn/upload/spec/7741/u_20100504093230259264.jpg";
    
    foundValue = [dict objectForKey:Images];
    if (nil != foundValue && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSArray class]]){
    //if (nil != foundValue){
        //NSDictionary *dict = foundValue;
        for(NSDictionary* dict in foundValue)
        {
            id fullValue = [dict objectForKey:FullUrl];
            //fullValue = @"http://picm.photophoto.cn/015/037/003/0370032269.jpg";
            //fullValue = @"http://192.168.22.211:8000/schoolinfo.pdf";
            //fullValue = @"http://192.168.22.211:8000/test.docx";
            if(nil != fullValue && [NSNull null] != fullValue && [fullValue isKindOfClass:[NSString class]])
            {
                //full
                SchoolImage* img = [SchoolDataManager imageWithImageFullUrl:fullValue isLocal:NO];
                
                //small
                id smallValue = [dict objectForKey:SmallUrl];
                smallValue = fullValue;
                if(nil != smallValue && [NSNull null] != smallValue && [smallValue isKindOfClass:[NSString class]])
                {
                    SchoolFile* smallfile = [SchoolDataManager fileWithUrl:smallValue isLocal:NO];
                    img.thumbImage = smallfile;
                    [smallfile addSmallParentObject:img];
                }
                //caption
                id captionValue = [dict objectForKey:Caption];
                //id captionValue = @"123";
                if(nil != captionValue && [NSNull null] != captionValue && [captionValue isKindOfClass:[NSString class]])
                    img.caption = captionValue;

                
                [self addSubImageObject:img];
                [img addSubImageParentObject:self];
            }
        }

    }

}
@end
