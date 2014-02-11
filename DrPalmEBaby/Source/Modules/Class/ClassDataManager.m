//
//  ClassDataManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "ClassDataManager.h"
#import "LoginManager.h"
#import "ResourceManager.h"
#import "ClassModuleDefine.h"
#import "CustomClassEventCategory.h"

@implementation ClassDataManager
#pragma mark - 分类模块 (ClassEventCategory)
// 查找和添加分类
+ (ClassEventCategory *)categaoryWithId:(NSString *)newCategory {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@", newCategory];
    ClassEventCategory *category = [[CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate] lastObject];
    if (!category) {
        category = [CoreDataManager insertNewObjectForEntityForName:ClassEventCategoryEntityName];
        category.category_id = newCategory;
        //[category setValue:[NSNumber numberWithInteger:newCategory] forKey:@"category_id"];
    }
    return category;
}

// 查找分类
+ (ClassEventCategory *)queryCategaoryWithId:(NSString *)categoryId
{
    ClassEventCategory *category = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@", categoryId];
    category = [[CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate] lastObject];
    return category;
}

// 获取所有分类
+ (NSArray *)categoryList {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(modulesname == %@) and (bShow == YES)",EVENTMODULES];
    NSSortDescriptor *categoryIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category_id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
    [categoryIdSortDescriptor release];
    
    NSArray *items = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}

#pragma mark 在最新界面显示的分类（参数,帐号类型）
+ (NSArray*)showInLatestArray:(AccountType)accType
{
    NSPredicate *predicate = nil;
    if(accType == AccountType_Teacher)
        predicate = [NSPredicate predicateWithFormat:@"(showinlatestlist >= %d) and (bShow == YES)",AccountType_Student];
    else
        predicate = [NSPredicate predicateWithFormat:@"(showinlatestlist == %d) and (bShow == YES)",AccountType_Student];
    NSSortDescriptor *categorylastupdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdateChannel" ascending:NO];
    NSSortDescriptor *categoryIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category_id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categorylastupdateSortDescriptor,categoryIdSortDescriptor, nil];
    [categoryIdSortDescriptor release];
    
    NSArray *items = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}

// 获取可发送的分类
+ (NSArray *)canSendcategoryList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(modulesname == %@) and (bSend == YES)",EVENTMODULES];
    NSSortDescriptor *categoryIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category_id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
    [categoryIdSortDescriptor release];
    
    NSArray *items = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}

// 获取所有分类（包括已发，系统消息，家园桥）
+ (NSArray *)allcategoryList
{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"not (modulesname == %@ ) and (bShow == YES)", FACE2FACEMOUDLE];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(showinlatestlist == YES ) and (bShow == YES)"];
    NSSortDescriptor *categorylastupdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdateChannel" ascending:NO];
    NSSortDescriptor *categoryIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category_id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categorylastupdateSortDescriptor,categoryIdSortDescriptor, nil];
    [categoryIdSortDescriptor release];
    
    NSArray *items = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}


// 获取所有分类按最后更新排序
+ (NSArray *)categoryListByLastUpdate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bShow == YES"];
    
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdateChannel" ascending:NO];
    NSSortDescriptor *categoryIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category_id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, categoryIdSortDescriptor, nil];
    [categoryIdSortDescriptor release];
    
    NSArray *items = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 获取所有可发送分类
+ (NSArray *)categoryListCanSend {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(modulesname == %@) and (bSend == YES)", EVENTMODULES];
    
    NSSortDescriptor *categoryIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category_id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
    [categoryIdSortDescriptor release];
    
    NSArray *items = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 初始化本地分类
+ (NSArray *)staticCategory {
	NSString *path = [ResourceManager pathForResource:@"staticClassTypes" ofType:@"plist"];
	NSArray *staticTypeData = [NSArray arrayWithContentsOfFile:path];
	NSMutableArray *mutableArray = [NSMutableArray array];
	for (NSDictionary *typeInfo in staticTypeData) {
        ClassEventCategory *category = [ClassDataManager categaoryWithId:[typeInfo objectForKey:@"categoryId"]];
//        if (!category.title || !category.sortOrder) {
            category.title = [typeInfo objectForKey:@"title"];
            category.sortOrder = [NSNumber numberWithInteger:[[typeInfo objectForKey:@"sortOrder"] integerValue]];
            category.picture = [NSNumber numberWithBool:[[typeInfo objectForKey:@"picture"] boolValue]];
            category.type = [typeInfo objectForKey:@"type"];
            category.modulesname = [typeInfo objectForKey:@"modulesname"];
            category.bShow = [NSNumber numberWithBool:[[typeInfo objectForKey:@"bShow"] boolValue]];
            category.showinlatestlist = [NSNumber numberWithInteger:[[typeInfo objectForKey:@"showinlatestlist"] integerValue]];
            category.bSend = [NSNumber numberWithBool:[[typeInfo objectForKey:@"cansend"] boolValue]];
        
            NSString *logoPath = [typeInfo objectForKey:@"logoPath"];
            ClassFile *file = [ClassDataManager fileWithUrl:logoPath isLocal:YES];
            category.logoImage = file;
//        }
        [mutableArray addObject:category];
	}
    [CoreDataManager saveData];
	return [NSArray arrayWithArray:mutableArray];
}
#pragma mark - 通告模块 (ClassEvent)
#pragma mark 获取最后更新的通告
+ (ClassEvent *)eventLastUpdate {
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    NSSortDescriptor *lastUpdateSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    ClassEvent *item = [[CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors] lastObject];
    return item;
}
#pragma mark 获取最后阅读的通告
+ (ClassEvent *)eventLastRead {
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    NSSortDescriptor *postDateSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"postDate" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:postDateSortDescriptor, nil];
    ClassEvent *item = [[CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors] lastObject];
    return item;
}
#pragma mark 获取所有通告
+ (NSArray *)eventList {
    NSArray *items = [NSArray array];
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    NSSortDescriptor *lastUpdateSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO] autorelease];
    NSSortDescriptor *postDateSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"postDate" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, postDateSortDescriptor, nil];
    items = [CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
//// event_id倒叙
//NSInteger EventIdCompare(ClassEvent *first, ClassEvent *second, void *context){
//    //return [first.event_id compare:second.event_id];
//    return [second.event_id compare:first.event_id];
//}
// 查询指定父分类通告
+ (NSArray *)eventListWithCatalog:(NSString *)catID {
    NSArray *items = [NSArray array];
//    NSArray *sortItemsById = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@", catID];
    NSArray *categories = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate];
    if(nil != categories && categories.count > 0) {
        ClassEventCategory *category = [categories lastObject];
//        NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortField" ascending:NO];
        NSSortDescriptor *lastUpdateSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO] autorelease];
        NSSortDescriptor *postDateSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"postDate" ascending:NO] autorelease];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, postDateSortDescriptor, nil];
        
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%@ in categories and (user == %@) and (status != %@)", category, [LoginManagerInstance() accountName],@"D"];
    
        items = [CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate2 sortDescriptors:sortDescriptors];
    }
//    if(items) {
//        sortItemsById = [items sortedArrayUsingFunction:EventIdCompare context:NULL];
//    }
    return items;
}

+(NSDate*)lastReadTimeWithCatalog:(NSString *)catID
{
    NSArray *items = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@", catID];
    NSArray *categories = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate];
    if(nil != categories && categories.count > 0) {
        ClassEventCategory *category = [categories lastObject];
        NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastreadtime" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
        [lastUpdateSortDescriptor release];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%@ in categories and (user == %@)", category, [LoginManagerInstance() accountName]];
        items = [CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate2 sortDescriptors:sortDescriptors limit:1];
    }
    if(items.count >0)
    {
        ClassEvent* item = [items objectAtIndex:0];
        return item.lastreadtime;
    }
    else
        return nil;
}

+(NSDate*)lastupdateWithCatalog:(NSString *)catID
{
    NSArray *items = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@", catID];
    NSArray *categories = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate];
    if(nil != categories && categories.count > 0) {
        ClassEventCategory *category = [categories lastObject];
        NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
        [lastUpdateSortDescriptor release];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%@ in categories and (user == %@)", category, [LoginManagerInstance() accountName]];
        items = [CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate2 sortDescriptors:sortDescriptors limit:1];
    }
    if(items.count >0)
    {
        ClassEvent* item = [items objectAtIndex:0];
        return item.lastUpdate;
    }
    else
        return nil;
}
#pragma mark (收藏/取消收藏)指定通告
+ (void)bookmarkEvent:(NSString *)itemID bookmark:(BOOL)bookmark {
    ClassEvent *item = [ClassDataManager eventWithId:itemID];
    if(item) {
//        if([item.bookmarked boolValue] == bookmark) {
//            return;
//        }
        item.alreadySynchronize = [NSNumber numberWithBool:NO];
        item.bookmarked = [NSNumber numberWithBool:bookmark];
        [CoreDataManager saveData];
    }
}
#pragma mark 查找收藏
+ (NSArray *)eventWithBookmark {
    NSString *user = @"";
    if(LoginManagerInstance().accountName.length >0) {
        user = LoginManagerInstance().accountName;
    }
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(bookmarked == 1) and (user == %@)", user];
    NSArray *items = [CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
+ (NSArray *)eventWithBookmark:(NSString *)catID {
    NSArray *items = nil;
//    NSArray *sortItemsById = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@", catID];
    NSArray *categories = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate];
    if(nil != categories) {
        ClassEventCategory *category = [categories lastObject];
        if(nil != category) {
            NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
            [lastUpdateSortDescriptor release];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(%@ in categories) and (bookmarked == 1) and (user == %@)", category, [LoginManagerInstance() accountName]];
            items = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:predicate2 sortDescriptors:sortDescriptors];
        }
    }
//    if(items) {
//        sortItemsById = [items sortedArrayUsingFunction:EventIdCompare context:NULL];
//    }
    return items;
}
#pragma mark 查询需要向服务器同步的已改变收藏状态通告
+ (NSArray *)eventListWithBookmarkSynchronize {
    NSString *user = @"";
    if(LoginManagerInstance().accountName.length >0) {
        user = LoginManagerInstance().accountName;
    }
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"favourLastUpdate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user == %@) and (alreadySynchronize == 0)", user];
    NSArray *items = [CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
#pragma mark 取消收藏状态
+ (void)cancelEventListWithBookmarkSynchronize {
    NSArray *array = [ClassDataManager eventListWithBookmarkSynchronize];
    for(ClassEvent *item in array) {
        item.alreadySynchronize = [NSNumber numberWithBool:YES];
    }
    [CoreDataManager saveData];
}
#pragma mark 查询最后同步的收藏通告
+ (ClassEvent *)eventLastSynchronize {
    NSString *user = @"";
    if(LoginManagerInstance().accountName.length >0) {
        user = LoginManagerInstance().accountName;
    }
    
    NSSortDescriptor *lastUpdateSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"favourLastUpdate" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user == %@)", user];
    ClassEvent *item = [[CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors] lastObject];
    return item;
}
#pragma mark 查找标题关键字
+ (NSArray *)eventWithSearchString:(NSString *)query {
    //NSMutableArray *searchNews = [NSMutableArray array];
    // make a predicate for everything with the search flag
    NSArray *results = [NSArray array];
    if(query.length == 0) {
        return results;
    }
    NSPredicate *predicate = nil;
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortField" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
    
	predicate = [NSPredicate predicateWithFormat:@"(title like[cd] %@) and (user == %@)", [NSString stringWithFormat:@"*%@*", query], [LoginManagerInstance() accountName]];
    
    // show everything that comes back
    results = [CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return results;
    
}
+ (NSArray *)eventsWithStartEndDate:(NSDate *)startDate end:(NSDate *)endDate catID:(NSString *)catID {
//	NSSortDescriptor *sortStart = [[[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES] autorelease];
//    NSSortDescriptor *sortEnd = [[[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES] autorelease];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortStart, sortEnd, nil];
//    NSSortDescriptor *lastUpdateSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"sortField" ascending:NO] autorelease];
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    
    NSArray *events = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((startDate <= %@ and %@ <= endDate) or (%@ <= startDate and startDate<=%@) or (%@ < endDate and endDate <= %@)) and (ANY categories.category_id == %@) and (user == %@)", startDate, endDate, startDate, endDate, startDate, endDate, catID, [LoginManagerInstance() accountName]];
    events = [CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return events;
}
// 已发通告是否存在
+ (BOOL)eventIsExist:(NSString *)eventId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event_id == %@) and (user == %@)", eventId, [LoginManagerInstance() accountName]];
    ClassEvent *item = [[CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate] lastObject];
    return (nil == item) ? NO:YES;
}
// 添加一条通告
+ (ClassEvent *)eventWithId:(NSString *)eventId {
    ClassEvent *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event_id == %@) and (user == %@)", eventId, [LoginManagerInstance() accountName]];
    item = [[CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate] lastObject];
    return item;
}
+ (ClassEvent *)eventInsertWithId:(NSString *)eventId {
    ClassEvent *item = [ClassDataManager eventWithId:eventId];
    if(!item) {
        item = (ClassEvent *)[CoreDataManager insertNewObjectForEntityForName:ClassEventEntityName];
        item.event_id = eventId;
        item.user = [LoginManagerInstance() accountName];
    }
    return item;
}
+ (ClassEvent *)eventWitdhDict:(NSDictionary *)dict {
    NSString *eventId = [ClassEvent idWithDict:dict];
    ClassEvent *item = [ClassDataManager eventInsertWithId:eventId];
    item.isGetByBookmarkList = [NSNumber numberWithBool:NO];
    [item updateWithDict:dict];
    return item;
}
+ (ClassEvent *)eventWitdhFavourDict:(NSDictionary *)dict {
    NSString *eventId = [ClassEvent idWithDict:dict];
    ClassEvent *item = [ClassDataManager eventWithId:eventId];
    // otherwise create new
    if (!item) {
        item = (ClassEvent *)[CoreDataManager insertNewObjectForEntityForName:ClassEventEntityName];
        item.isGetByBookmarkList = [NSNumber numberWithBool:YES];
    }
    item.user = [LoginManagerInstance() accountName];
    [item updateFavourWithDict:dict];
    return item;
}

+(BOOL)hasEventGetByBookMark
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isGetByBookmarkList == 1) and (user == %@)", LoginManagerInstance().accountName];
    NSArray* array = [CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:predicate];
    if(array && array.count>0)
        return YES;
    else
        return NO;
}


// 获取附件
+ (NSArray *)filesWithClassEventId:(NSString *)eventId {
    NSArray *items = [NSArray array];
    NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"path" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sort, sort, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY eventParent.event_id == %@) and (ANY eventParent.user == %@)", eventId, [LoginManagerInstance() accountName]];
    items = [CoreDataManager objectsForEntity:ClassFileEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
+ (NSArray *)filesWithClassEventSentId:(NSString *)eventId {
    NSArray *items = [NSArray array];
    NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"path" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sort, sort, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY eventSentParent.event_id == %@) and (ANY eventSentParent.user == %@)", eventId, [LoginManagerInstance() accountName]];
    items = [CoreDataManager objectsForEntity:ClassFileEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
#pragma mark - 已发通告模块 (ClassEventSent)

+ (NSDate*)getSentListLastupdate
{
    NSArray *items = nil;
    ClassEventSent* item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@ ", [LoginManagerInstance() accountName]];
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
//    items = [CoreDataManager objectsForEntity:ClassEventSentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    
    items = [CoreDataManager objectsForEntity:ClassEventSentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors limit:1];
    
    if(items)
        item =  (ClassEventSent*)[items objectAtIndex:0] ;
    if(item!= nil)
        return item.lastUpdate;
    else
        return nil;

}
// 查询已发通告
+ (NSArray *)eventSentList {
    NSArray *items = nil;
//    NSArray *sortItemsById = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user == %@)and(status != %@)", [LoginManagerInstance() accountName],@"D"];
//    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortField" ascending:NO];
    NSSortDescriptor *lastUpdateSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO] autorelease];
    NSSortDescriptor *postDateSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"postDate" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, postDateSortDescriptor, nil];
    items = [CoreDataManager objectsForEntity:ClassEventSentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
//    if(items) {
//        sortItemsById = [items sortedArrayUsingFunction:EventIdCompare context:NULL];
//    }
    return items;
}
+ (NSArray*)eventSentListWithPostDate:(NSDate*)startPostDate endPostDate:(NSDate*)endPostDate
{
    NSArray *items = nil;
    //    NSArray *sortItemsById = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%@ <= postDate) and (postDate <= %@) and (user == %@)", startPostDate, endPostDate, [LoginManagerInstance() accountName]];
//    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortField" ascending:NO];
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
    items = [CoreDataManager objectsForEntity:ClassEventSentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
+ (BOOL)eventSentIsExist:(NSString *)eventId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event_id == %@) and (user == %@)", eventId, [LoginManagerInstance() accountName]];
    ClassEventSent *item = [[CoreDataManager objectsForEntity:ClassEventSentEntityName matchingPredicate:predicate] lastObject];
    return (nil == item) ? NO:YES;
}
// 查询指定已发通告
+ (ClassEventSent *)eventSentWithId:(NSString *)eventId {
    ClassEventSent *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event_id == %@) and (user == %@)", eventId, [LoginManagerInstance() accountName]];
    item = [[CoreDataManager objectsForEntity:ClassEventSentEntityName matchingPredicate:predicate] lastObject];
    return item;
}

+ (void)delSentEventById:(NSString*)eventId
{
    ClassEventSent *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event_id == %@) and (user == %@)", eventId, [LoginManagerInstance() accountName]];
    item = [[CoreDataManager objectsForEntity:ClassEventSentEntityName matchingPredicate:predicate] lastObject];
    if(item)
    {
        [CoreDataManager deleteObject:item];
        [CoreDataManager saveData];
    }
    return;
}

// 添加一条已发通告
+ (ClassEventSent *)eventSentWitdhDict:(NSDictionary *)dict {
    NSString *eventId = [ClassEventSent idWithDict:dict];
    ClassEventSent *item = [ClassDataManager eventSentWithId:eventId];
    // otherwise create new
    if (!item) {
        item = (ClassEventSent *)[CoreDataManager insertNewObjectForEntityForName:ClassEventSentEntityName];
        item.user = [LoginManagerInstance() accountName];
    }
    [item updateWithDict:dict];
    return item;
}

#pragma mark 获取通告回评模板
+ (ClassEventReviewTemp *)reviewTempWithIdEventId:(NSString *)itemID eventId:(NSString *)eventId {
    ClassEventReviewTemp *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(itemID == %@) and (eventParent.event_id == %@)", itemID, eventId];
    item = [[CoreDataManager objectsForEntity:ClassEventReviewTempEntityName matchingPredicate:predicate] lastObject];
    return item;
}
+ (ClassEventReviewTemp *)reviewTempInsertWithIdEventId:(NSString *)itemID eventId:(NSString *)eventId {
    ClassEventReviewTemp *item = [ClassDataManager reviewTempWithIdEventId:itemID eventId:eventId];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassEventReviewTempEntityName];
        item.itemID = itemID;
    }
    ClassEvent *event = [ClassDataManager eventWithId:eventId];
    if(event) {
        item.eventParent = event;
    }
    return item;
}
+ (ClassEventReviewTemp *)reviewTempInsertWithDictEventId:(NSDictionary *)dict eventId:(NSString *)eventId {
    NSString *itemID = [ClassEventReviewTemp idWithDict:dict];
    ClassEventReviewTemp *item = [ClassDataManager reviewTempInsertWithIdEventId:itemID eventId:eventId];
    if(item)
        [item updateWithDict:dict];
    return item;
}

#pragma mark - 反馈人模块 (ClassAnwserMan/ClassAnwserContent)
// anwserMan_id倒叙
NSInteger AnwserManIdCompare(ClassAnwserMan *first, ClassAnwserMan *second, void *context){
    //return [first.event_id compare:second.event_id];
    return [second.anwserMan_id compare:first.anwserMan_id];
}
// anwserMan_id倒叙
NSInteger AnwserDateCompare(ClassAnwserContent *first, ClassAnwserContent *second, void *context){
    //return [first.event_id compare:second.event_id];
    return [second.anwserDate compare:first.anwserDate];
}
// 按通告查反馈人列表
+ (NSArray *)anwserListWithEventId:(NSString *)eventId {
    NSArray *sortItemsById = nil;
    ClassEvent *event = [ClassDataManager eventWithId:eventId];
    if(event.anwserMans) {
        sortItemsById = [[event.anwserMans allObjects] sortedArrayUsingFunction:AnwserManIdCompare context:NULL];
    }
    return sortItemsById;
}
// 按已发通告查反馈人列表
+ (NSArray *)anwserListWithEventSentId:(NSString *)eventId {
    NSArray *sortItemsById = nil;
    ClassEventSent *event = [ClassDataManager eventSentWithId:eventId];
    if(event.anwserMans) {
        sortItemsById = [[event.anwserMans allObjects] sortedArrayUsingFunction:AnwserManIdCompare context:NULL];
    }
    return sortItemsById;
}
// 查询自己与指定反馈人指定通告对话内容
+ (NSArray *)anwserContentListWithEventId:(NSString *)anwserManId eventId:(NSString *)eventId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"anwserMan.anwserMan_id == %@ and (anwserMan.eventParent.event_id == %@) and (anwserMan.eventParent.user == %@)", anwserManId, eventId, [LoginManagerInstance() accountName]];
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"anwserDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
    
    NSArray *items = [CoreDataManager objectsForEntity:ClassAnwserContentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];

    return items;
}
// 查询自己与指定反馈人指定已发通告对话内容
+ (NSArray *)anwserContentListWithEventSentId:(NSString *)anwserManId eventId:(NSString *)eventId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"anwserMan.anwserMan_id == %@ and (anwserMan.eventSentParent.event_id == %@) and (anwserMan.eventSentParent.user == %@)", anwserManId, eventId, [LoginManagerInstance() accountName]];
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"anwserDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
    
    NSArray *items = [CoreDataManager objectsForEntity:ClassAnwserContentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 查询自己与指定反馈人所有对话内容
+ (NSArray *)anwserContentListAll:(NSString *)anwserManId {
    NSMutableArray *items = [NSMutableArray array];
//    NSArray *sortItemsById = nil;
    /* 一个评论人只对一条通告 */
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(anwserMan.anwserMan_id == %@) and (anwserMan.eventParent.user == %@)", anwserManId, [LoginManagerInstance() accountName]];
    [items addObjectsFromArray:[CoreDataManager objectsForEntity:ClassAnwserContentEntityName matchingPredicate:predicate]];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(anwserMan.anwserMan_id == %@) and (anwserMan.eventSentParent.user == %@)", anwserManId, [LoginManagerInstance() accountName]];
    
    NSSortDescriptor *lastUpdateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"anwser_id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastUpdateSortDescriptor, nil];
    [lastUpdateSortDescriptor release];
    
    [items addObjectsFromArray:[CoreDataManager objectsForEntity:ClassAnwserContentEntityName matchingPredicate:predicate2 sortDescriptors:sortDescriptors]];
    return items;
    /* 多对多关系 */
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"anwserMan.anwserMan_id == %@ and (ANY anwserMan.eventParents.user == %@)", anwserManId, [LoginManagerInstance() accountName]];
//    [items addObjectsFromArray:[CoreDataManager objectsForEntity:ClassAnwserContentEntityName matchingPredicate:predicate]];
//    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"anwserMan.anwserMan_id == %@ and (ANY anwserMan.eventSentParents.user == %@)", anwserManId, [LoginManagerInstance() accountName]];
//    [items addObjectsFromArray:[CoreDataManager objectsForEntity:ClassAnwserContentEntityName matchingPredicate:predicate2]];
//    if(items) {
//        sortItemsById = [items sortedArrayUsingFunction:AnwserDateCompare context:NULL];
//    }
//    return sortItemsById;
}

// 查询指定通告是否有新反馈
+ (BOOL)hasAnwserWithEventId:(NSString *)eventId
{
    ClassEvent* event = [ClassDataManager eventWithId:eventId];
    BOOL result = NO;
    
    if ([event.anwserMans count] == 0) {
        // 列表时间大于0
        result = (NSOrderedDescending == [event.lastAwsTime compare:[NSDate dateWithTimeIntervalSince1970:0]]);
    }
    else {
        for (ClassAnwserMan* anwser in event.anwserMans) {
            NSDate* date = [ClassDataManager lastAnwsWithEventId:anwser.anwserMan_id eventId:eventId];
            // 指定反馈人最后回复时间比详细里面的回复时间要新
            if (nil != anwser.lastawsTime && NSOrderedAscending == [date compare:anwser.lastawsTime])
            {
                result = YES;
                break;
            }
        }
    }
    return result;
}

// 查询自己与指定反馈人指定通告对话内容的最后时间
+ (NSDate *)lastAnwsWithEventId:(NSString *)anwserManId eventId:(NSString *)eventId {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    NSArray *items = [ClassDataManager anwserContentListWithEventId:anwserManId eventId:eventId];
    if(items.count > 0) {
        ClassAnwserContent *item = [items lastObject];
        date = item.anwserDate;
    }
    return date;
}

// 查询指定已发通告是否有新反馈
+ (BOOL)hasAnwserWithEventSentId:(NSString *)eventSentId
{
    BOOL result = NO;
    ClassEventSent* event = [ClassDataManager eventSentWithId:eventSentId];
    if ([event.anwserMans count] == 0) {
        // 列表时间大于0
        result = (NSOrderedDescending == [event.lastAwsTime compare:[NSDate dateWithTimeIntervalSince1970:0]]);
    }
    else {
        for (ClassAnwserMan* anwser in event.anwserMans) {
            NSDate* date = [ClassDataManager lastAnwsWithEventSentId:anwser.anwserMan_id eventId:eventSentId];
            // 指定反馈人最后回复时间比详细里面的回复时间要新
            if (nil != anwser.lastawsTime && NSOrderedAscending == [date compare:anwser.lastawsTime])
            {
                result = YES;
                break;
            }
        }
    }
    return result;
}
// 查询已发通告自己与指定反馈人否有新反馈
+ (BOOL)hasAnwserWithAnwserManIdEventSentId:(NSString *)anwserManId eventSentId:(NSString *)eventSentId {
    BOOL result = NO;
    ClassAnwserMan *anwserMan = [ClassDataManager anwserManWithIdEventSentId:anwserManId eventId:eventSentId];
    NSDate* date = [ClassDataManager lastAnwsWithEventSentId:anwserMan.anwserMan_id eventId:eventSentId];
    // 指定反馈人最后回复时间比详细里面的回复时间要新
    if (nil != anwserMan.lastawsTime && NSOrderedAscending == [date compare:anwserMan.lastawsTime])
    {
        result = YES;
    }
    return result;
}
// 查询自己与指定反馈人指定已发通告对话内容的最后时间
+ (NSDate *)lastAnwsWithEventSentId:(NSString *)anwserManId eventId:(NSString *)eventId {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    NSArray *items = [ClassDataManager anwserContentListWithEventSentId:anwserManId eventId:eventId];
    if(items.count > 0) {
        ClassAnwserContent *item = [items lastObject];
        date = item.anwserDate;
    }
    return date;
}


// 按通告添加一个讨论组
+ (ClassAnwserMan *)anwserManWithIdEventId:(NSString *)anwserManId eventId:(NSString *)eventId {
    ClassAnwserMan *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"anwserMan_id == %@ and (%@ == eventParent.event_id) and (eventParent.user == %@)", anwserManId, eventId, [LoginManagerInstance() accountName]];
    item = [[CoreDataManager objectsForEntity:ClassAnwserManEntityName matchingPredicate:predicate] lastObject];
    if(item == nil)
    {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassAnwserManEntityName];
        item.anwserMan_id = anwserManId;
    }
    ClassEvent *classItem = nil;
    classItem = [ClassDataManager eventWithId:eventId];
    if(nil != classItem) {
        item.eventParent = classItem;
    }
    return item;
}
+ (ClassAnwserMan *)anwserManWithDictEventId:(NSDictionary *)dict eventId:(NSString *)eventId {
    NSString* answerman = [dict objectForKey:@"aswpubid"];
    ClassAnwserMan *item = nil;
    item = [ClassDataManager anwserManWithIdEventId:answerman eventId:eventId];
    if(item == nil)
    {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassAnwserManEntityName];
    }
    [item updateWithDict:dict];
    return item;
}
#pragma mark 讨论组成员
+ (ClassAnwserSender *)anwserSenderWithId:(NSString *)itemID {
    ClassAnwserSender *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID == %@", itemID];
    item = [[CoreDataManager objectsForEntity:ClassAnwserSenderEntityName matchingPredicate:predicate] lastObject];
    return item;
}
+ (ClassAnwserSender *)anwserSenderInsertWithId:(NSString *)itemID {
    ClassAnwserSender *item = [ClassDataManager anwserSenderWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassAnwserSenderEntityName];
        item.itemID = itemID;
    }
    return item;
}
+ (ClassAnwserSender *)anwserSenderWithDict:(NSDictionary *)dict {
    NSString *itemID = [ClassAnwserSender idWithDict:dict];
    ClassAnwserSender *item = [ClassDataManager anwserSenderInsertWithId:itemID];
    if(item)
        [item updateWithDict:dict];
    return item;
}

// 按已发通告添加一个反馈人
+ (ClassAnwserMan *)anwserManWithIdEventSentId:(NSString *)anwserManId eventId:(NSString *)eventId {
    ClassAnwserMan *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(anwserMan_id == %@) and (%@ == eventSentParent.event_id) and (eventSentParent.user == %@)", anwserManId, eventId, [LoginManagerInstance() accountName]];
    item = [[CoreDataManager objectsForEntity:ClassAnwserManEntityName matchingPredicate:predicate] lastObject];
    if(item == nil)
    {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassAnwserManEntityName];
        item.anwserMan_id = anwserManId;
    }
    ClassEventSent *classItem = nil;
    classItem = [ClassDataManager eventSentWithId:eventId];
    if(nil != classItem) {
        item.eventSentParent = classItem;
    }
    return item;
}
+ (ClassAnwserMan *)anwserManWithDictEventSentId:(NSDictionary *)dict eventId:(NSString *)eventId {
    NSString* answerman = [dict objectForKey:@"aswpubid"];
    ClassAnwserMan *item = nil;
    item = [ClassDataManager anwserManWithIdEventSentId:answerman eventId:eventId];
    if(item == nil)
    {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassAnwserManEntityName];
    }
    [item updateWithDict:dict];
    return item;

}
// 添加一条通告反馈内容
+ (ClassAnwserContent *)anwserContentWithDict:(NSDictionary *)dict anwserManId:(NSString *)anwserManId eventId:(NSString *)eventId {
    ClassAnwserContent *item = nil;
    NSString *contentId = [ClassAnwserContent idWithDict:dict];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(anwser_id == %@) and (anwserMan.anwserMan_id == %@) and (anwserMan.eventParent.event_id == %@) and (anwserMan.eventParent.user == %@)",contentId, anwserManId, eventId, [LoginManagerInstance() accountName]];
    item = [[CoreDataManager objectsForEntity:ClassAnwserContentEntityName matchingPredicate:predicate] lastObject];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassAnwserContentEntityName];
    }
    [item updateWithDictEventId:dict anwserMan_id:anwserManId event_id:eventId];
    return item;
}
// 添加一条已发通告反馈内容
+ (ClassAnwserContent *)anwserContentWithDictSent:(NSDictionary *)dict anwserManId:(NSString *)anwserManId eventId:(NSString *)eventId {
    ClassAnwserContent *item = nil;
    NSString *contentId = [ClassAnwserContent idWithDict:dict];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(anwser_id == %@) and (anwserMan.anwserMan_id == %@) and (anwserMan.eventSentParent.event_id == %@) and (anwserMan.eventSentParent.user == %@)",contentId, anwserManId, eventId, [LoginManagerInstance() accountName]];
    item = [[CoreDataManager objectsForEntity:ClassAnwserContentEntityName matchingPredicate:predicate] lastObject];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassAnwserContentEntityName];
    }
    [item updateWithDictEventSentId:dict anwserMan_id:anwserManId event_id:eventId];
    return item;
}
#pragma mark - 文件模块 (ClassFile/ClassImage)
// 插入文件
+ (ClassFile *)fileWithUrl:(NSString *)url isLocal:(Boolean)isLocal {
    ClassFile *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path == %@", url];
    item = [[CoreDataManager objectsForEntity:ClassFileEntityName matchingPredicate:predicate] lastObject];
    if (!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassFileEntityName];
    }
    [item updateWithImageUrl:url isLocal:isLocal];
    return item;
}
// 插入图片
+ (ClassImage *)imageWithImageFullUrl:(NSString *)url isLocal:(Boolean)isLocal{
    ClassImage *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullImage.path == %@", url];
    item = [[CoreDataManager objectsForEntity:ClassImageEntityName matchingPredicate:predicate] lastObject];
    if (!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassImageEntityName];
    }
    [item updateWithFullUrl:url isLocal:isLocal];
    return item;
}
+ (ClassImage *)imageWithImageDict:(NSDictionary *)dict isLocal:(Boolean)isLocal{
    ClassImage *item = nil;
    item = [ClassDataManager imageWithImageFullUrl:[ClassImage fullImageUrlWithDict:dict] isLocal:isLocal];
    [item updateWithImageDict:dict isLocal:isLocal];
    return item;
}

#pragma mark - 组织架构(ClassOrg, ClassUserTopOrg)
+ (ClassUserTopOrg*)getUserTopOrg
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(user == %@)", [LoginManagerInstance() accountName]];
    ClassUserTopOrg* userTopOrg = [[CoreDataManager objectsForEntity:ClassUserTopOrgEntityName
                                                   matchingPredicate:pred] lastObject];
    if (nil == userTopOrg) {
        userTopOrg = [CoreDataManager insertNewObjectForEntityForName:ClassUserTopOrgEntityName];
        userTopOrg.user = [LoginManagerInstance() accountName];
    }
    return userTopOrg;
}

+ (void)updateUserTopOrgWithOrgIDs:(NSArray*)orgIDs
{
    ClassUserTopOrg* userTopOrg = [ClassDataManager getUserTopOrg];
    
    // 清空关系
    [userTopOrg removeTopOrgs:userTopOrg.topOrgs];
    
    // 更新
    for (NSString* orgId in orgIDs) {
        ClassOrg* org = [ClassDataManager orgWithID:orgId];
        [userTopOrg addTopOrgsObject:org];
    }
}

+ (NSArray *)topLevelOrgs
{
    ClassUserTopOrg* userTopOrg = [ClassDataManager getUserTopOrg];
    
    // 排序
    NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"orgID" ascending:YES] autorelease];
    return [userTopOrg.topOrgs sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}

+ (NSArray *)suborgsWithParentOrgID:(NSString *)orgID
{
    NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"orgID" ascending:YES] autorelease];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"(ANY orgParents.orgID == %@)", orgID];
    return [CoreDataManager objectsForEntity:ClassOrgEntityName
                           matchingPredicate:pred
                             sortDescriptors:[NSArray arrayWithObject:sort]];
}

+ (ClassOrg*)orgWithID:(NSString *)orgID
{
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"orgID == %@", orgID];
    ClassOrg *org = [[CoreDataManager objectsForEntity:ClassOrgEntityName
                                     matchingPredicate:pred] lastObject];
    if(!org)
    {
        org = (ClassOrg*)[CoreDataManager insertNewObjectForEntityForName:ClassOrgEntityName];
        org.orgID = orgID;
    }
    return org;
}

+ (ClassOrg *) orgWithDict:(NSDictionary *)dict
{
    ClassOrg *parent = nil;
    NSString* parentId = [ClassOrg orgPIDWIthDict:dict];
    parent = [ClassDataManager orgWithID:parentId];
    
    NSString *orgID = [ClassOrg orgIDWithDict:dict];
    ClassOrg* org = [ClassDataManager orgWithID:orgID];
    [org updateWithDict:dict parent:parent];
    return org;
}

+ (ClassOrg *)orgWithDict:(NSDictionary *)dict parentId:(NSString *)parentId
{
    ClassOrg *parent = nil;
    if (nil != parentId)
    {
        parent = [ClassDataManager orgWithID:parentId];
    }
    
    NSString *orgID = [ClassOrg orgIDWithDict:dict];
    ClassOrg* org = [ClassDataManager orgWithID:orgID];
    [org updateWithDict:dict parent:parent];
    return org;
}

+ (NSDate *)getOrgLastupdate
{
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"orgID == %@", OrgTopDefaultValue];
    ClassOrg *org = [[CoreDataManager objectsForEntity:ClassOrgEntityName
                                     matchingPredicate:pred] lastObject];
    return org.lastupdate;
}

+ (void)removeAllOrg
{
    NSArray *orgs = [CoreDataManager objectsForEntity:ClassOrgEntityName
                                     matchingPredicate:nil];
    for (ClassOrg* org in orgs) {
        [CoreDataManager deleteObject:org];
    }
}

// 创建节点目录
+ (void)createOrgPath
{
    ClassOrg* topOrg = [ClassDataManager orgWithID:OrgTopDefaultValue];
    NSMutableArray* orgArray = [NSMutableArray array];
    [orgArray addObjectsFromArray:[topOrg.orgSubs allObjects]];
    while ([orgArray count] > 0) {
        ClassOrg* org = [orgArray objectAtIndex:0];
        [org createPath];
        
        if ([org.orgSubs count] > 0) {
            [orgArray addObjectsFromArray:[org.orgSubs allObjects]];
        }
        [orgArray removeObjectAtIndex:0];
    }
}

// 计算叶子节点数
+ (void)countLeafOrg
{
    ClassOrg* topOrg = [ClassDataManager orgWithID:OrgTopDefaultValue];
    NSMutableArray* orgArray = [NSMutableArray array];
    [orgArray addObjectsFromArray:[topOrg.orgSubs allObjects]];
    while ([orgArray count] > 0) {
        ClassOrg* org = [orgArray objectAtIndex:0];
        org.orgLeafCount = [NSNumber numberWithInteger:[ClassDataManager getLeafOrgNumberWithOrg:org]];
        
        if ([org.orgSubs count] > 0) {
            [orgArray addObjectsFromArray:[org.orgSubs allObjects]];
        }
        [orgArray removeObjectAtIndex:0];
    }
}

// 获取指定节点的叶子节点数
+ (NSInteger)getLeafOrgNumberWithOrg:(ClassOrg*)org
{
    return [[ClassDataManager getLeafOrgWithOrg:org] count];
}

// 获取指定节点的所有叶子节
+ (NSArray*)getLeafOrgWithOrg:(ClassOrg*)org
{
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"(orgPath like[cd] %@) and (orgType == %@)", [NSString stringWithFormat:@"*%@*", [org getOrgPathNode]], GetOrgInfo_OrgMemberType];
    
    NSArray* orgs = [CoreDataManager objectsForEntity:ClassOrgEntityName
                                    matchingPredicate:pred];
    return orgs;
}

#pragma mark - 草稿(ClassEventDraft)
+ (void)insertEventDraft {
    ClassEventDraft* draft = (ClassEventDraft*)[CoreDataManager insertNewObjectForEntityForName:ClassEventDraftEntityName];
    if (nil != draft) {
        draft.user = [LoginManagerInstance() accountName];
    }
    draft.lastUpdated = [NSDate date];
    [CoreDataManager saveData];
}
+ (ClassEventDraft *)lastEventDraft {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(user == %@)", [LoginManagerInstance() accountName]];
    NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"lastUpdated" ascending:YES] autorelease];
    return [[CoreDataManager objectsForEntity:ClassEventDraftEntityName
                           matchingPredicate:pred
                             sortDescriptors:[NSArray arrayWithObject:sort]] lastObject];
}
+ (NSArray*)getEventDrafts
{
    NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"lastUpdated" ascending:NO] autorelease];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"(user == %@)", [LoginManagerInstance() accountName]];
    return [CoreDataManager objectsForEntity:ClassEventDraftEntityName
                           matchingPredicate:pred
                             sortDescriptors:[NSArray arrayWithObject:sort]];
}

+ (void)removeEventDraft:(ClassEventDraft*)draft
{
//    ClassEventDraft *item = [draft retain];
//    [ClassDataManager removeEventDraftAttachment:item];
    [CoreDataManager deleteObject:draft];
    [CoreDataManager saveData];
//    [item release];
}

+ (void)removeEventDraftAttachment:(ClassEventDraft*)draft
{
    NSSet *attachments = [draft.attachments retain];
    draft.attachments = nil;
    for (ClassEventDraftAttachment *attachment in attachments) {
        [ClassDataManager removeDraftAttachment:attachment];
    }
    [attachments release];
}

#pragma mark - 草稿附件(EventDraftAttachment)
+ (ClassEventDraftAttachment*)draftAttachmentWithDraftAndUrl:(ClassEventDraft*)eventDraft url:(NSString*)url
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(eventDraft.title==%@) and (eventDraft.user==%@) and (eventDraft.lastUpdated==%@) and (path==%@)", eventDraft.title, eventDraft.user, eventDraft.lastUpdated ,url];
    ClassEventDraftAttachment *draftAttachment = (ClassEventDraftAttachment*)[[CoreDataManager objectsForEntity:ClassEventDraftAttachmentEntityName
        matchingPredicate:pred
        sortDescriptors:nil] lastObject];
    
    if (nil == draftAttachment){
        draftAttachment = (ClassEventDraftAttachment*)[CoreDataManager insertNewObjectForEntityForName:ClassEventDraftAttachmentEntityName];
    }
    draftAttachment.path = url;
    draftAttachment.eventDraft = eventDraft;
    
    return draftAttachment;
}

+ (void)removeDraftAttachment:(ClassEventDraftAttachment*)draftAttachment
{
    [CoreDataManager deleteObject:(NSManagedObject*)draftAttachment];
}

#pragma mark - 协议相关
// 获取event状态
+ (EventStatusType)eventStatusTypeWithStatusString:(NSString*)eventStatus
{
    EventStatusType status = EventStatusType_Normal;
    NSString *statusString = [eventStatus uppercaseString];
    if ([statusString isEqualToString:@"C"]){
        status = EventStatusType_Cancel;
    }
    else if ([statusString isEqualToString:@"A"]){
        status = EventStatusType_Add;
    }
    return status;
}

+ (NSString*)StatausStringWithEventStatusType:(EventStatusType)eventStatus
{
    NSString * statusString;
    switch (eventStatus) {
        case EventStatusType_Add:
            statusString = @"A";
            break;
        case EventStatusType_Cancel:
            statusString = @"C";
            break;
        case EventStatusType_Normal:
        default:
            statusString = @"N";
            break;
    }
    return statusString;
}

//
+ (void)setUnReadCount:(NSInteger)count
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user == %@)", @"user"];
    ClassUnRead* item = [[CoreDataManager objectsForEntity:ClassUnReadEntityName matchingPredicate:predicate] lastObject];
    if(!item )
    {
        item = [CoreDataManager insertNewObjectForEntityForName:ClassUnReadEntityName];
        item.user = @"user";
    }
    item.unreadcount = [NSNumber numberWithInteger:count];
    [CoreDataManager saveData];
}
+ (NSInteger)getUnReadCount
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user == %@)", @"user"];
    ClassUnRead* item = [[CoreDataManager objectsForEntity:ClassUnReadEntityName matchingPredicate:predicate] lastObject];
    if(item != nil)
        return [item.unreadcount integerValue];
    else
        return 0;
    
}
//删除
+ (void)removeAllEvents:(BOOL)withoutBookMark
{
    // 删除events
    NSPredicate *pred = nil;
    if (withoutBookMark){
        pred = [NSPredicate predicateWithFormat:@"(user == %@) AND (bookmarked != 1)", LoginManagerInstance().accountName];
    }
    else {
        pred = [NSPredicate predicateWithFormat:@"(user == %@)", LoginManagerInstance().accountName];
    }
    NSArray *events = [CoreDataManager objectsForEntity:ClassEventEntityName matchingPredicate:pred];
    
    for(ClassEvent *event in events) {
        //删附件
        NSArray* attachments = [event.attachments allObjects];
        if(nil != attachments)
            [CoreDataManager deleteObjects:attachments];
        
        // 删除评论
        NSArray *answermans = [event.anwserMans allObjects];
        for( ClassAnwserMan *man in answermans ){
            NSArray *contents = [man.anwserContents allObjects];
            if( nil != contents && [contents count] > 0)
                [CoreDataManager deleteObjects:contents];
        }
        if( nil != answermans ){
            [CoreDataManager deleteObjects:answermans];
        }
    }
    if ([events count] > 0) {
        [CoreDataManager deleteObjects:events];
    }
    
    //删已发Events
    NSPredicate *sentPred = [NSPredicate predicateWithFormat:@"(user == %@)",LoginManagerInstance().accountName];
    NSArray *sentEvents = [CoreDataManager objectsForEntity:ClassEventSentEntityName matchingPredicate:sentPred];
    // 删除已发评论
    for(ClassEventSent *sent in sentEvents) {
        //删已发附件
        NSArray* attachments = [sent.attachments allObjects];
        if(nil != attachments)
            [CoreDataManager deleteObjects:attachments];
        
        NSArray *answermans = [sent.anwserMans allObjects];
        for( ClassAnwserMan *man in answermans ){
            NSArray *commments = [man.anwserContents allObjects];
            if( nil != commments && [commments count] > 0)
                [CoreDataManager deleteObjects:commments];
        }
        if( nil != answermans ){
            [CoreDataManager deleteObjects:answermans];
        }
    }
    if ([sentEvents count] > 0) {
        [CoreDataManager deleteObjects:sentEvents];
    }
    
    //删分类
    NSArray * classCategorys = [CoreDataManager objectsForEntity:ClassEventCategoryEntityName matchingPredicate:nil];
    if([classCategorys count] > 0)
    {
        [CoreDataManager deleteObjects:classCategorys];
        [CoreDataManager saveData];
    }
    [ClassDataManager staticCategory];
}
#pragma mark 清除所有分类最后更新时间
+ (void)removeAllCategoryLasUpdate {
    NSArray *items = [ClassDataManager allcategoryList];
    for(int i = 0; i< items.count; i++) {
        ClassEventCategory* category = [items objectAtIndex:i];
        category.unreadcount = [NSNumber numberWithInteger:0];
    }
    [CoreDataManager saveData];
}
@end
