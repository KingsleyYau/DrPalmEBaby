//
//  LocalAreaDefine.h
//  DrPalm
//
//  Created by drcom on 13-1-14.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#ifndef DrPalm_LocalAreaDefine_h
#define DrPalm_LocalAreaDefine_h

#define PARSE_FAIL      @"0" // 解析错误

#pragma mark - (代理商/机构/幼儿园集合)模块
#define AppId               @"appid"
#define AppType             @"type"
#define GetAgentList_Path   @"org.alikesun.area.getnavigation.flow"     
#define AgentList_Items     @"results"

#define Test_GetAgentList_Path @""

#pragma mark - 区域模块
#define Local_Id            @"localid"
#define LocalArea_ParentId  @"plocid"
#define LocalArea_Name      @"name"
#define LocalArea_Type      @"type"
#define LocalArea_key       @"key"
#define LocalArea_TitleUrl  @"titleurl"

#define GetNavigation_Path           @"getnavigation"
#define GetSchoolList_Path           @"getschoollist"
#define SearchSchool_Path            @"searchschool"

//#define GetSchoolList_Path           @"org.alikesun.area.getschoollist.flow"
//#define SearchSchool_Path            @"org.alikesun.area.searchschool.flow"
#define SearchSchool_KeyWord         @"keyword"
#define SchoolList_Items             @"results"


#endif
