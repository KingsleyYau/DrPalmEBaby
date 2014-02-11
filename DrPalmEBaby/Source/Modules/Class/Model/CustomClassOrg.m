//
//  CustomClassOrg.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "CustomClassOrg.h"
#import "ClassDataManager.h"
#import "ClassModuleDefine.h"

@implementation ClassOrg (Custom)
+ (NSString *)orgIDWithDict:(NSDictionary *)dict
{
    return [dict objectForKey:GetOrgInfo_ID];
}

+ (NSString *)orgPIDWIthDict:(NSDictionary *)dict
{
    return [dict objectForKey:GetOrgInfo_PID];
}

- (void)updateWithDict:(NSDictionary *)dict parent:(ClassOrg *)parent
{
    self.orgID = [dict objectForKey:GetOrgInfo_ID];
	self.orgName = [dict objectForKey:GetOrgInfo_Name];
    self.orgType = [dict objectForKey:GetOrgInfo_Type];
    self.orgStatus = [dict objectForKey:GetOrgInfo_Status];
    
    if (nil == parent) {
        self.orgParents = nil;
    }
    else if (![self.orgParents containsObject:parent]){
        [self addOrgParentsObject:parent];
    }
}
//
//+ (void)parentsWithEventOrg:(ClassOrg *)eventOrg parents:(NSMutableArray*)parents
//{
//    if ([eventOrg.orgParents count] > 0
//        && ![[[eventOrg.orgParents anyObject] orgID] isEqualToString:OrgTopDefaultValue]){
//        for (ClassOrg *parentEventOrg in eventOrg.orgParents) {
//            [ClassOrg parentsWithEventOrg:parentEventOrg parents:parents];
//            [parents addObject:parentEventOrg];
//        }
//    }
//}
//
//- (NSArray *)parents
//{
//    NSMutableArray *parents = [NSMutableArray array];
//    [ClassOrg parentsWithEventOrg:self parents:parents];
//    return parents;
//}
//
//+ (void)getPath:(ClassOrg*)org pathStr:(NSMutableString*)path
//{
//    if (nil == path) {
//        return;
//    }
//    
//    for (ClassOrg* parent in org.orgParents) {
//        if ([parent.orgID isEqualToString:OrgTopDefaultValue]) {
//            return;
//        }
//        
//        // 添加路径
//        if ([path length] == 0) {
//            [path insertString:[NSString stringWithFormat:@"%@%@%@", OrgPathNodeBreakSign, parent.orgID, OrgPathNodeBreakSign] atIndex:0];
//        }
//        else {
//            [path appendFormat:@"%@%@", parent.orgID, OrgPathNodeBreakSign];
//        }
//        
//        [ClassOrg getPath:parent pathStr:path];
//    }
//}
//
//+ (void)updatePath:(ClassOrg*)org
//{
//    NSMutableString* path = [NSMutableString string];
//    
//    if ([org.orgPath length] > 0) {
//        [path appendFormat:@"%@", org.orgPath];
//    }
//    
//    for (ClassOrg* parent in org.orgParents) {
//        if ([parent.orgID isEqualToString:OrgTopDefaultValue]) {
//            return;
//        }
//        
//        if (nil == parent.orgPath) {
//            [path appendFormat:@"%@%@%@", OrgPathNodeBreakSign, parent.orgID, OrgPathNodeBreakSign];
//        }
//        else {
//            [path appendFormat:@"%@%@%@", parent.orgPath, parent.orgID, OrgPathNodeBreakSign];
//        }
//    }
//    [path appendString:OrgPathBreakSign];
//    org.orgPath = path;
//}

// 生成路径
- (void)createPath
{
    if ([self.orgPath length] == 0) {
        NSMutableString* path = [NSMutableString string];
        for (ClassOrg* parent in self.orgParents) {
            // 根节点不写入路径
            if ([parent.orgID isEqualToString:OrgTopDefaultValue]) {
                return;
            }
            
            if ([parent.orgPath length] == 0) {
                [parent createPath];
            }
            [path appendString:[ClassOrg getOrgPathWithParent:parent]];
        }
        self.orgPath = path;
    }
}

// 获取指定节点所有路径
+ (NSArray *)getOrgPaths:(ClassOrg*)org
{
    NSMutableArray* pathArray = [NSMutableArray array];
    
    if ([org.orgPath length] > 0) {
        // 分割路径
        NSRange searchRange = NSMakeRange(0, [org.orgPath length]);
        do {
            NSRange resultRange = [org.orgPath rangeOfString:OrgPathBreakSign options:NSCaseInsensitiveSearch range:searchRange];
            NSString* path = nil;
            if (resultRange.location != NSNotFound) {
                path = [org.orgPath substringWithRange:NSMakeRange(searchRange.location, resultRange.location - searchRange.location)];
                
                searchRange.length -= resultRange.location + 1;
                searchRange.location = resultRange.location + 1;
            }
            else {
                path = [org.orgPath substringWithRange:NSMakeRange(searchRange.location, searchRange.length)];
                searchRange.length = -1;
            }
            [pathArray addObject:path];
        } while (searchRange.length > 0);
    }
    
    return pathArray;
}

// 根据指定parent创建路径
+ (NSString*)getOrgPathWithParent:(ClassOrg*)parent
{
    NSMutableString* result = [NSMutableString string];
    NSArray* parentPaths = [ClassOrg getOrgPaths:parent];
    if ([parentPaths count] == 0) {
        [result appendFormat:@"%@%@%@%@", OrgPathNodeBreakSign, parent.orgID, OrgPathNodeBreakSign, OrgPathBreakSign];
    }
    else {
        for (NSString* path in parentPaths) {
            [result appendFormat:@"%@%@%@%@", path, parent.orgID, OrgPathNodeBreakSign, OrgPathBreakSign];
        }
    }
    return result;
}

// 获取路径节点字符串
- (NSString*)getOrgPathNode
{
    return [NSString stringWithFormat:@"%@%@%@", OrgPathNodeBreakSign, self.orgID, OrgPathNodeBreakSign];
}

// 判断是否父层节点
- (BOOL)isProgenitorNode:(ClassOrg*)subNode
{
    BOOL result = NO;
    NSRange range = [subNode.orgPath rangeOfString:[self getOrgPathNode]];
    if (range.location != NSNotFound) {
        result = YES;
    }
    return result;
}
@end
