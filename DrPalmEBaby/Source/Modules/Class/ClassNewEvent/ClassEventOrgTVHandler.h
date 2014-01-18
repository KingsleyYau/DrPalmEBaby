//
//  ClassEventOrgTVHandler.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-11-6.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NoChecked,
    SubsChecked,
    Checked
}OrgCellStatus;

@class ClassOrg;
@class LoadingView;
// 合并的数据定义
@interface ClassEventOrgTVCombineItem : NSObject {
    NSString*   _orgId;
    NSString*   _orgParentId;
}
@property (nonatomic, retain) NSString* orgId;
@property (nonatomic, retain) NSString* orgParentId;
@end

#pragma mark - 节点操作处理类
@interface ClassEventOrgTVHandler : NSObject
+ (BOOL)isCombineSubItem:(ClassOrg*)parent items:(NSArray*)items;
+ (BOOL)combineSubItem:(ClassEventOrgTVCombineItem*)combineItem items:(NSMutableArray*)items;
+ (void)combineSubOrg:(NSMutableArray*)srcCheckedOrgs desCheckedOrgs:(NSMutableArray*)desCheckedOrgs;
+ (void)removeRepetitiveCombineItem:(NSMutableArray*)items desCheckedOrgs:(NSMutableArray*)orgs;
+ (void)createDesCheckedOrgsWithItems:(NSArray*)items desCheckedOrgs:(NSMutableArray*)desCheckedOrgs;
+ (void)addClassOrgToItemArray:(NSMutableArray*)itemArray org:(ClassOrg*)org;
+ (BOOL)isAllOrgChecked:(NSArray *)array checkedArray:(NSArray *)checkArray;
+ (OrgCellStatus)cellStatusWithEventOrg:(NSArray*)array eventOrg:(ClassOrg*)eventOrg;
+ (void)addToArray:(NSMutableArray*)array eventOrg:(ClassOrg*)eventOrg;
+ (void)removeToArray:(NSMutableArray*)array eventOrg:(ClassOrg*)eventOrg;
@end
