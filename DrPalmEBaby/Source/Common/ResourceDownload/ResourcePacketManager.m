//
//  ResourcePacketManager.m
//  DrPalm
//
//  Created by JiangBo on 13-3-8.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "ResourcePacketManager.h"
#import "ResourceDownloadManager.h"

@implementation ResourcePacketInfo

@synthesize schoolkey = _schoolkey;
@synthesize resourcepath = _resourcepath;
@synthesize timestamp = _timestamp;

- (id)init
{
    if(self = [super init]) {
        self.timestamp = @"";
        self.schoolkey = @"";
        self.resourcepath = @"";
    }
    return self;
}

- (void)dealloc
{
    self.schoolkey = nil;
    self.resourcepath = nil;
    self.timestamp = nil;
    [super dealloc];
}

@end


@implementation ResourcePacketManager

@synthesize resPacketInfo = _resPacketInfo;
@synthesize resPacketArray = _resPacketArray;

-(id)init{
    if (self = [super init]){
        self.resPacketArray = [NSMutableArray array];
        _resPacketInfo = [[ResourcePacketInfo alloc] init];
        [self load];
    }
    return  self;
}

-(void)dealloc{
    self.resPacketArray = nil;
    self.resPacketInfo = nil;
    [super dealloc];
}

-(void)load{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realPath = [NSString stringWithFormat:@"%@/resourcepacket.plist",documentPath];
    
    NSArray* arrayresource = [[[NSArray alloc] initWithContentsOfFile:realPath] autorelease];
    
    self.resPacketArray = [NSMutableArray arrayWithArray:arrayresource];
    return;
    
}

-(BOOL)save{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realPath = [NSString stringWithFormat:@"%@/resourcepacket.plist",documentPath];
    if(_resPacketArray != nil)
        return [_resPacketArray writeToFile:realPath atomically:YES];
    else
        return NO;
}

-(void)setResPacketInfo:(ResourcePacketInfo*)resPacketInfo
{
    if(_resPacketInfo) {
        [_resPacketInfo release];
        _resPacketInfo = nil;
    }
    _resPacketInfo = [resPacketInfo retain];
    if(_resPacketArray == nil)
        return;
    //查找，有则删除
    int nCount = [self.resPacketArray count];
    for(int i=0;i<nCount;i++)
    {
        if([[_resPacketArray objectAtIndex:i] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary * dict = [_resPacketArray objectAtIndex:i];
            if([[dict objectForKey:SCHOOLKEY] isKindOfClass:[NSString class]])
            {
                NSString* nsschoolkey = [dict objectForKey:SCHOOLKEY];
                if([nsschoolkey compare:resPacketInfo.schoolkey] == 0)
                {
                    [_resPacketArray removeObjectAtIndex:i];
                    // add by qh for fix bug
                    // 删除旧的tours包
                    break;
                }
            }
        }
    }
    
    //
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          resPacketInfo.timestamp, TIMESTAMP,
                          resPacketInfo.schoolkey,SCHOOLKEY,
                          resPacketInfo.resourcepath,RESPACKETPATH,
                          nil];
    [_resPacketArray addObject:dict];
    [self save];
}


-(ResourcePacketInfo*)findResPacketWithSchoolKey:(NSString*)schoolkey
{
    if(_resPacketArray == nil)
        return nil;
    
    //ResourcePacketInfo* resinfo = [[ResourcePacketInfo alloc] init];
    int nCount = [_resPacketArray count];
    for(int i=0;i<nCount;i++)
    {
        if([[_resPacketArray objectAtIndex:i] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary * dict = [_resPacketArray objectAtIndex:i];
            if([[dict objectForKey:SCHOOLKEY] isKindOfClass:[NSString class]])
            {
                NSString* nsschoolkey = [dict objectForKey:SCHOOLKEY];
                if([nsschoolkey compare:schoolkey] == 0)
                {
                    self.resPacketInfo.schoolkey = nsschoolkey;
                    id timestamp = [dict objectForKey:TIMESTAMP];
                    if([timestamp isKindOfClass:[NSString class]])
                        self.resPacketInfo.timestamp = timestamp;
                    if([timestamp isKindOfClass:[NSNumber class] ])
                        self.resPacketInfo.timestamp = [NSString stringWithFormat:@"%@",timestamp];
                    self.resPacketInfo.timestamp = [dict objectForKey:TIMESTAMP];
                    self.resPacketInfo.resourcepath = [dict objectForKey:RESPACKETPATH];
                    return self.resPacketInfo;
                }
            }
        }
    }
    return nil;

}

- (NSString *)resourceFilePath:(NSString*)filePath {
    NSString *path = @"";
//    DrPalmGateWayManager* gateWayManager = DrPalmGateWayManagerInstance();
//    NSString* schoolkey = gateWayManager.schoolKey;
//    ResourcePacketInfo* packinfo = [self findResPacketWithSchoolKey:schoolkey];
//    
//    if(packinfo.resourcepath.length > 0) {
//        if ([@"/" isEqualToString:[filePath substringWithRange:NSMakeRange(0, 1)]]
//            || [@"\\" isEqualToString:[filePath substringWithRange:NSMakeRange(0, 1)]]){
//            path = [NSString stringWithFormat:@"%@%@", packinfo.resourcepath, filePath];
//        }
//        else{
//            path = [NSString stringWithFormat:@"%@/%@", packinfo.resourcepath, filePath];
//        }
//    }
    path = [NSString stringWithFormat:@"%@/%@", [ResourceDownloadManager toursPathWithSchoolKey], filePath];
    return path;
}
@end
