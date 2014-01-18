//
//  UserInfoManager.m
//  DrPalm4EBaby2
//
//  Created by JiangBo on 13-8-16.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "UserInfoManager.h"
#import "LoginManager.h"
#import "CustomUserInfo.h"
#import "CoreDataManager.h"
#import "OnlyWifi.h"

#import "PrivateAlbumLastupdate.h"
#import "PrivateAlbum+Custom.h"

#import "CommonRequestDefine.h"
@implementation UserInfoManager
@synthesize userInfo = _userInfo;
@synthesize isOnlyWifi = _isOnlyWifi;

-(id)init{
    self = [super init];
    if(self)
    {
        self.userInfo = nil;
        self.isOnlyWifi = NO;
    }
    return self;
}



-(void)loadCurUserInfo:(NSString*)userName
{
    self.userInfo =[UserInfo getUserInfo:userName];
    return;
}

-(void)saveUserInfo
{
    OnlyWifi* item = [[CoreDataManager objectsForEntity:OnlyWifiEntityName matchingPredicate:nil] lastObject];
    item.isonlywifi = [NSNumber numberWithBool:self.isOnlyWifi];
    [CoreDataManager saveData];
}

-(void)initWithCurSchool
{
    [self initWithLastLoginUser];
    [self reloadOnlyWifi];
}

-(void)initWithLastLoginUser
{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastlogintime" ascending:YES];
    NSArray* sortArray = [NSArray arrayWithObjects:sortDescriptor, nil];
    self.userInfo = [[CoreDataManager objectsForEntity:UserInfoEntityName matchingPredicate:nil sortDescriptors:sortArray] lastObject];
}

-(void)reloadOnlyWifi
{
    OnlyWifi* item = nil;
    item = [[CoreDataManager objectsForEntity:OnlyWifiEntityName matchingPredicate:nil] lastObject];
    if(!item)
    {
       item = [CoreDataManager insertNewObjectForEntityForName:OnlyWifiEntityName]; 
    }
    self.isOnlyWifi = [item.isonlywifi boolValue];
}

//获取登录帐号列表
+(NSArray*)getLoginUserList
{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastlogintime" ascending:NO];
    NSArray* sortArray = [NSArray arrayWithObjects:sortDescriptor, nil];
    return [CoreDataManager objectsForEntity:UserInfoEntityName matchingPredicate:nil sortDescriptors:sortArray];
}

+(void)delUser:(UserInfo*)userInfo
{
    [CoreDataManager deleteObject:userInfo];
    [CoreDataManager saveData];
}


+(GrowDiary*)growDiaryWithDict:(NSDictionary*)dict
{
    NSString *diaryId = [GrowDiary idWithDict:dict];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(diaryid == %@)  and (user == %@)", diaryId, LoginManagerInstance().accountName];
    GrowDiary* item = [[CoreDataManager objectsForEntity:GrowDiaryEntityName matchingPredicate:predicate] lastObject];
    if(!item) {
        item = (GrowDiary *)[CoreDataManager insertNewObjectForEntityForName:GrowDiaryEntityName];
    }
    [item updateWithDict:dict];
    item.user = LoginManagerInstance().accountName;
    return item;
    
}

+(NSArray*)getGrowDiaryList
{  
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user == %@)and (status != %@)",LoginManagerInstance().accountName,@"C"];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastupdate" ascending:NO];
    
    NSArray* sortArray = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    return [CoreDataManager objectsForEntity:GrowDiaryEntityName matchingPredicate:predicate sortDescriptors:sortArray];
}

+(void)updateAlbumLastupdate:(NSNumber*)lastupdate
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"user == %@",LoginManagerInstance().accountName];
    PrivateAlbumLastupdate* item = [[CoreDataManager objectsForEntity:PrivateAlbumLastupdateEntityName matchingPredicate:predicate] lastObject];
    if(!item)
    {
        item = [CoreDataManager insertNewObjectForEntityForName:PrivateAlbumLastupdateEntityName];
        item.user = LoginManagerInstance().accountName;
    }
    
    item.lastupdate = [NSDate dateWithTimeIntervalSince1970:[lastupdate doubleValue]];
}

+(PrivateAlbum*)albumWithDict:(NSDictionary*)dict
{
    NSString *imageId = [PrivateAlbum idWithDict:dict];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(imageid == %@)  and (user == %@)", imageId, LoginManagerInstance().accountName];
    PrivateAlbum* item = [[CoreDataManager objectsForEntity:PrivateAlbumEntityName matchingPredicate:predicate] lastObject];
    if(!item) {
        item = (PrivateAlbum *)[CoreDataManager insertNewObjectForEntityForName:PrivateAlbumEntityName];
    }
    [item updateWithDict:dict];
    item.user = LoginManagerInstance().accountName;
    return item;
}

+(NSArray*)getAlbumImageList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user == %@) AND (status != %@)",LoginManagerInstance().accountName,OperateStatus_Del];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"imageid" ascending:YES];
    
    NSArray* sortArray = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    return [CoreDataManager objectsForEntity:PrivateAlbumEntityName matchingPredicate:predicate sortDescriptors:sortArray];

}

+(NSDate*)getAlbumLastupdate
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user == %@)",LoginManagerInstance().accountName];
    PrivateAlbumLastupdate* item = (PrivateAlbumLastupdate*)[[CoreDataManager objectsForEntity:PrivateAlbumLastupdateEntityName matchingPredicate:predicate] lastObject];
    if(item)
        date = item.lastupdate;
    return date;
}





+(GrowDiaryForSent*)newGrowDiaryForSent
{
    GrowDiaryForSent* item = (GrowDiaryForSent*)[CoreDataManager insertNewObjectForEntityForName:GrowDiaryForSentEntityName];
    if (nil != item) {
        item.user = [LoginManagerInstance() accountName];
    }
    return item;
}

+(void)delGrowDiaryForSent
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"user == %@",LoginManagerInstance().accountName];
    NSArray* array = [CoreDataManager objectsForEntity:GrowDiaryForSentEntityName matchingPredicate:predicate];
    if(array)
    {
        [CoreDataManager deleteObjects:array];
        [CoreDataManager saveData];
    }
}


+(PrivateAlbum*)newPrivateAlbum
{
    PrivateAlbum* item = (PrivateAlbum*)[CoreDataManager insertNewObjectForEntityForName:PrivateAlbumEntityName];
    if (nil != item) {
        item.user = [LoginManagerInstance() accountName];
    }
    
    return item;
}

+(PrivateAlbum*)getAlbumImage:(NSString*)imageId
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(imageid == %@) AND (user == %@)",imageId,LoginManagerInstance().accountName];
    
    PrivateAlbum* item = (PrivateAlbum*)[[CoreDataManager objectsForEntity:PrivateAlbumEntityName matchingPredicate:predicate] lastObject];
    return item;
}

+(HeadImage*)headImageWithUrl:(NSString*)url
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"url == %@",url];
    HeadImage* item = [[CoreDataManager objectsForEntity:HeadImageEntityName matchingPredicate:predicate] lastObject];
    if(!item){
        item = [UserInfoManager newHeadImage];
        item.url = url;
    }
    return item;
}

+(HeadImage*)newHeadImage
{
    HeadImage* item = (HeadImage*)[CoreDataManager insertNewObjectForEntityForName:HeadImageEntityName];
    return item;
}


@end
