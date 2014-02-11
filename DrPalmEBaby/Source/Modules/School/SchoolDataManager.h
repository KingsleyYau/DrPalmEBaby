//
//  SchoolDataManager.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-10.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"

#import "CustomSchoolNewsCategory.h"
#import "CustomSchoolNews.h"
#import "CustomSchoolFile.h"
#import "CustomSchoolImage.h"

@interface SchoolDataManager : NSObject
// 初始化本地分类
+ (NSArray *)staticCategory;
// 获取所有分类
+ (NSArray *)categoryList;
// 获取所有分类按最后更新时间排序
+ (NSArray *)categoryListByLastUpdate;
// 查找和添加分类（查找则添加）
+ (SchoolNewsCategory *)categaoryWithId:(NSString *)newCategory;
// 查找分类(只查找)
+ (SchoolNewsCategory *)queryCategaoryWithId:(NSString *)categoryId;

// 查询新闻
// 查找指定分类下新闻
+ (NSArray *)newsListWithCatalog:(NSString *)catID;
+ (NSArray *)newsWithBookmark;
+ (NSArray *)newsWithBookmark:(NSString *)catID;
+ (NSArray *)newsWithSearchString:(NSString *)query;
+ (BOOL)newsIsExist:(NSString *)storyId;
+ (SchoolNews *)newsWithId:(NSString *)storyId;
// 添加一条新闻
+ (SchoolNews *)newsWitdhDict:(NSDictionary *)dict;
// 获取附件
+ (NSArray *)imagesWithNewsId:(NSString *)itemId;
/* 查询文件 */
// 插入文件
+ (SchoolFile *)fileWithUrl:(NSString *)url isLocal:(Boolean)isLocal;
// 插入图片
+ (SchoolImage *)imageWithImageFullUrl:(NSString *)url isLocal:(Boolean)isLocal;
+ (SchoolImage *)imageWithImageDict:(NSDictionary *)dict isLocal:(Boolean)isLocal;


//删除数据
// 删除所有News,withoutBookmark为true,不删除已收藏的
+ (void)removeAllNews:(BOOL)withoutBookmark;
// TODO:删除所有分类最后更新时间
+ (void)removeAllCategoryLastUpdate;
@end
