//
//  UserInfoManager.h
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-8-16.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "CustomHeadImage.h"

#import "GrowDiary+Custom.h"
#import "GrowDiaryForSent.h"
#import "PrivateAlbum.h"
#import "PrivateAlbumForSent.h"
#import "HeadImage.h"

@interface UserInfoManager : NSObject
{
    UserInfo*  _userInfo;
    BOOL    _isOnlyWifi;
}

@property (nonatomic, readwrite,retain) UserInfo* userInfo;
@property (nonatomic, readwrite) BOOL isOnlyWifi;

-(void)loadCurUserInfo:(NSString*)userName;
-(void)saveUserInfo;

//获取登录帐号列表
+(NSArray*)getLoginUserList;
+(void)delUser:(UserInfo*)userInfo;


-(void)initWithCurSchool;
-(void)initWithLastLoginUser;

-(void)reloadOnlyWifi;


+(GrowDiary*)growDiaryWithDict:(NSDictionary*)dict;
+(NSArray*)getGrowDiaryList;

+(void)updateAlbumLastupdate:(NSNumber*)lastupdate;
+(NSDate*)getAlbumLastupdate;


+(GrowDiaryForSent*)newGrowDiaryForSent;
+(void)delGrowDiaryForSent;

+(PrivateAlbum*)newPrivateAlbum;
+(PrivateAlbum*)getAlbumImage:(NSString*)imageId;


+(PrivateAlbum*)albumWithDict:(NSDictionary*)dict;
+(NSArray*)getAlbumImageList;


+(HeadImage*)headImageWithUrl:(NSString*)url;
+(HeadImage*)newHeadImage;



@end
