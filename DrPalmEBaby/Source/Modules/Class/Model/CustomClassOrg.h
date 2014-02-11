//
//  CustomClassOrg.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassOrg.h"

// 路径节点分隔符，如：.131.114.
#define OrgPathNodeBreakSign    @"."
// 路径分隔符，分隔多个路径，如：.131.114.;.121.115.;
#define OrgPathBreakSign    @";"

@interface ClassOrg (Custom)
+ (NSString *)orgIDWithDict:(NSDictionary *)dict;
+ (NSString *)orgPIDWIthDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict parent:(ClassOrg *)parent;
//- (void)updateWithDict:(NSDictionary *)dict sub:(ClassOrg *)sub;
//- (NSArray *)parents;
//+ (void)getPath:(ClassOrg*)org pathStr:(NSMutableString*)path;
//+ (void)updatePath:(ClassOrg*)org;
- (void)createPath;
+ (NSArray *)getOrgPaths:(ClassOrg*)parent;
+ (NSString*)getOrgPathWithParent:(ClassOrg*)parent;
- (NSString*)getOrgPathNode;
// 判断是否父层节点
- (BOOL)isProgenitorNode:(ClassOrg*)parentNode;
@end
