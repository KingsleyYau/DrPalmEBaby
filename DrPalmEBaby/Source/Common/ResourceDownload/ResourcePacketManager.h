//
//  ResourcePacketManager.h
//  DrPalm
//
//  Created by JiangBo on 13-3-8.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SCHOOLKEY               @"Schoolkey"
#define TIMESTAMP               @"TimeStamp"
#define RESPACKETPATH           @"ResPacketPath"

@interface ResourcePacketInfo : NSObject
{
    NSString*   _schoolkey;
    NSString*   _timestamp;
    NSString*   _resourcepath;
}

@property (nonatomic,retain) NSString*   timestamp;
@property (nonatomic,retain) NSString*   schoolkey ;
@property (nonatomic,retain) NSString*   resourcepath ;

@end



@interface ResourcePacketManager : NSObject
{
    NSMutableArray* _resPacketArray;
    ResourcePacketInfo*  _resPacketInfo;
}

@property(nonatomic,retain) ResourcePacketInfo*  resPacketInfo;
@property(nonatomic,retain) NSMutableArray* resPacketArray;

-(void)load;
-(BOOL)save;

-(void)setResPacketInfo:(ResourcePacketInfo*)resPacketInfo;
-(ResourcePacketInfo*)findResPacketWithSchoolKey:(NSString*)schoolkey;

- (NSString *)resourceFilePath:(NSString*)filePath;
@end
