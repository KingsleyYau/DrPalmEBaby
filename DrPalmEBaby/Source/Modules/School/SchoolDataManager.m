//
//  SchoolDataManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "SchoolDataManager.h"
#import "ResourceManager.h"
@implementation SchoolDataManager
#pragma mark - 新闻分类入数据库 (SchoolNewsCategory)
// 查找和添加分类
+ (SchoolNewsCategory *)categaoryWithId:(NSString *)newCategory {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@", newCategory];
    SchoolNewsCategory *category = [[CoreDataManager objectsForEntity:SchoolNewsCategoryEntityName matchingPredicate:predicate] lastObject];
    if (!category) {
        category = [CoreDataManager insertNewObjectForEntityForName:SchoolNewsCategoryEntityName];
        category.category_id = newCategory;
        //[category setValue:[NSNumber numberWithInteger:newCategory] forKey:@"category_id"];
    }
    return category;
}

// 查找分类(只查找)
+ (SchoolNewsCategory *)queryCategaoryWithId:(NSString *)categoryId
{
    SchoolNewsCategory *category = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@", categoryId];
    category = [[CoreDataManager objectsForEntity:SchoolNewsCategoryEntityName matchingPredicate:predicate] lastObject];
    return category;
}

// 获取所有分类
+ (NSArray *)categoryList {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(modulesname == %@) and (bShow == YES)", SCHOOLMODULES];

    NSSortDescriptor *categoryIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category_id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
    [categoryIdSortDescriptor release];
    
    NSArray *items = [CoreDataManager objectsForEntity:SchoolNewsCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 获取所有分类按最后更新时间排序
+ (NSArray *)categoryListByLastUpdate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(modulesname == %@) and (bShow == YES)",SCHOOLMODULES];
    
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdateChannel" ascending:NO];
    NSSortDescriptor *categoryIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category_id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, categoryIdSortDescriptor, nil];
    [categoryIdSortDescriptor release];
    
    NSArray *items = [CoreDataManager objectsForEntity:SchoolNewsCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 初始化本地分类
+ (NSArray *)staticCategory {
	NSString *path = [ResourceManager pathForResource:@"staticSchoolTypes" ofType:@"plist"];
	NSArray *staticTypeData = [NSArray arrayWithContentsOfFile:path];
	NSMutableArray *mutableArray = [NSMutableArray array];
	for (NSDictionary *typeInfo in staticTypeData) {
        NSString *categorID = [typeInfo objectForKey:@"categoryId"];
        if(categorID.length >0) {
            SchoolNewsCategory *category = [SchoolDataManager categaoryWithId:categorID];
//            if (!category.title || !category.sortOrder) {
                category.title = [typeInfo objectForKey:@"title"];
                category.sortOrder = [NSNumber numberWithInteger:[[typeInfo objectForKey:@"sortOrder"] integerValue]];
                category.picture = [NSNumber numberWithBool:[[typeInfo objectForKey:@"picture"] boolValue]];
                category.type = [typeInfo objectForKey:@"type"];
                category.modulesname = [typeInfo objectForKey:@"modulesname"];
                category.bShow = [NSNumber numberWithBool:[[typeInfo objectForKey:@"bShow"] boolValue]];
                
                NSString *logoPath = [typeInfo objectForKey:@"logoPath"];
                SchoolFile *file = [SchoolDataManager fileWithUrl:logoPath isLocal:YES];
                category.logoImage = file;
//            }
            [mutableArray addObject:category];
        }
        
	}
    [CoreDataManager saveData];
	return [NSArray arrayWithArray:mutableArray];
}
#pragma mark - 新闻入数据库 (SchoolNews)
//// storyid倒叙
//NSInteger SchoolNewsIdCompare(SchoolNews *first, SchoolNews *second, void *context){
//    //return [first.story_id compare:second.story_id];
//    return [second.story_id compare:first.story_id];
//}
// 查询指定父分类新闻
+ (NSArray *)newsListWithCatalog:(NSString *)catID {
    NSArray *stories = [NSArray array];
//    NSArray *sortStoriesById = nil;
    
//    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
//    [lastUpdateSortDescriptor release];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@", catID];
    NSArray *categories = [CoreDataManager objectsForEntity:SchoolNewsCategoryEntityName matchingPredicate:predicate];
    if(nil != categories && categories.count > 0) {
        SchoolNewsCategory *category = [categories lastObject];

        NSSortDescriptor *lastUpdateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastUpdate" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(status != %@ )AND(%@ in categories)",@"D",category];
        stories = [CoreDataManager objectsForEntity:SchoolNewsEntityName matchingPredicate:predicate2 sortDescriptors:sortDescriptors];
    }
    return stories;
}
// 查找收藏
+ (NSArray *)newsWithBookmark {
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookmarked == 1"];
    NSArray *stories = [CoreDataManager objectsForEntity:SchoolNewsEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return stories;
}
+ (NSArray *)newsWithBookmark:(NSString *)catID {
    NSArray *stories = nil;
//    NSArray *sortStoriesById = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@", catID];
    NSArray *categories = [CoreDataManager objectsForEntity:SchoolNewsCategoryEntityName matchingPredicate:predicate];
    if(nil != categories) {
        SchoolNewsCategory *category = [categories lastObject];
        if(nil != category) {
            NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
            [lastUpdateSortDescriptor release];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%@ in categories and bookmarked == 1", category];
            stories = [CoreDataManager objectsForEntity:SchoolNewsEntityName matchingPredicate:predicate2 sortDescriptors:sortDescriptors];
        }
    }
//    if(stories) {
//        sortStoriesById = [stories sortedArrayUsingFunction:SchoolNewsIdCompare context:NULL];
//    }
    return stories;
}
// 查找标题关键字
+ (NSArray *)newsWithSearchString:(NSString *)query {
    //NSMutableArray *searchNews = [NSMutableArray array];
    // make a predicate for everything with the search flag
    NSPredicate *predicate = nil;
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
//    NSSortDescriptor *storyIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"story_id" ascending:NO];
//    [storyIdSortDescriptor release];

    
	predicate = [NSPredicate predicateWithFormat:@"(title like[cd] %@)", [NSString stringWithFormat:@"*%@*", query]];
    
    // show everything that comes back
   // NSArray *results = [CoreDataManager objectsForEntity:SchoolNewsEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    NSArray *results = [CoreDataManager objectsForEntity:SchoolNewsEntityName matchingPredicate:predicate];
    return results;
    
}
+ (BOOL)newsIsExist:(NSString *)storyId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"story_id == %@", storyId];
    SchoolNews *story = [[CoreDataManager objectsForEntity:SchoolNewsEntityName matchingPredicate:predicate] lastObject];
    return (nil == story) ? NO:YES;
}
+ (SchoolNews *)newsWithId:(NSString *)storyId {
    SchoolNews *story = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"story_id == %@", storyId];
    story = [[CoreDataManager objectsForEntity:SchoolNewsEntityName matchingPredicate:predicate] lastObject];
    return story;
}
// 添加一条新闻
+ (SchoolNews *)newsWitdhDict:(NSDictionary *)dict {
    NSString *storyId = [SchoolNews idWithDict:dict];
   
    SchoolNews *story = [SchoolDataManager newsWithId:storyId];
//    if([SchoolNews isDeleteNews:dict]) //status为“c”，需要删除
//    {
//        if(story != nil)
//            [CoreDataManager deleteObject:(NSManagedObject*)story];
//        return nil;
//    }
    // otherwise create new
    if (!story) {
        story = (SchoolNews *)[CoreDataManager insertNewObjectForEntityForName:SchoolNewsEntityName];
    }
    [story updateWithDict:dict];
    return story;
}
// 获取附件
+ (NSArray *)imagesWithNewsId:(NSString *)itemId {
    NSArray *items = [NSArray array];
    NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"fullImage.path" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sort, sort, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY subImageParent.story_id == %@)", itemId];
    items = [CoreDataManager objectsForEntity:SchoolImageEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
#pragma mark - 文件模块
// 插入文件
+ (SchoolFile *)fileWithUrl:(NSString *)url isLocal:(Boolean)isLocal {
    SchoolFile *file = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path == %@", url];
    file = (SchoolFile *)[[CoreDataManager objectsForEntity:SchoolFileEntityName matchingPredicate:predicate] lastObject];
    if (!file) {
        file = (SchoolFile *)[CoreDataManager insertNewObjectForEntityForName:SchoolFileEntityName];
    }
    [file updateWithImageUrl:url isLocal:isLocal];
    return file;
}
// 插入图片
+ (SchoolImage *)imageWithImageFullUrl:(NSString *)url isLocal:(Boolean)isLocal{
    SchoolImage *image = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullImage.path == %@", url];
    image = [[CoreDataManager objectsForEntity:SchoolImageEntityName matchingPredicate:predicate] lastObject];
    if (!image) {
        image = [CoreDataManager insertNewObjectForEntityForName:SchoolImageEntityName];
    }
    [image updateWithFullUrl:url isLocal:isLocal];
    return image;
}
+ (SchoolImage *)imageWithImageDict:(NSDictionary *)dict isLocal:(Boolean)isLocal{
    SchoolImage *image = nil;
    image = [SchoolDataManager imageWithImageFullUrl:[SchoolImage fullImageUrlWithDict:dict] isLocal:isLocal];
    [image updateWithImageDict:dict isLocal:isLocal];
    return image;
}

+ (void)removeAllNews:(BOOL)withoutBookmark
{
    NSPredicate *predicate = nil;
    if (withoutBookmark){
        predicate = [NSPredicate predicateWithFormat:@"bookmarked != 1"];
    }
    NSArray *nonBookmarkedStories = [CoreDataManager objectsForEntity:SchoolNewsEntityName matchingPredicate:predicate];
    if ([nonBookmarkedStories count] > 0){
        [CoreDataManager deleteObjects:nonBookmarkedStories];
        [CoreDataManager saveData];
    }
    
    NSArray * schoolCategorys = [CoreDataManager objectsForEntity:SchoolNewsCategoryEntityName matchingPredicate:nil];
    if([schoolCategorys count] > 0)
    {
        [CoreDataManager deleteObjects:schoolCategorys];
        [CoreDataManager saveData];
    }
    [SchoolDataManager staticCategory];
    
}
// TODO:删除所有分类最后更新时间
+ (void)removeAllCategoryLastUpdate {
    NSArray *items = [SchoolDataManager categoryList];
    for(int i = 0; i< items.count; i++) {
        SchoolNewsCategory *category = [items objectAtIndex:i];
        category.lastUpdateChannel = [NSDate dateWithTimeIntervalSince1970:0];
    }
    [CoreDataManager saveData];
}
@end
