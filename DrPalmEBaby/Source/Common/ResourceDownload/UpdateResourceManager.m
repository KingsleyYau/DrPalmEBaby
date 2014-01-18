//
//  UpdateResourceManager.m
//  DrPalm
//
//  Created by fgx_lion on 12-6-5.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "UpdateResourceManager.h"
#import "ResourceManager.h"
#import "ZipArchive.h"

@implementation UpdateResourceManager

// packetPath文件解压并覆盖到resourcePath
+ (BOOL)updateResourceWithPacket:(NSString*)packetPath resourcePacket:(NSString*)resourcePath
{
    NSString *unzipPacketPath = [NSString stringWithFormat:@"%@%@", [ResourceManager resourcePath], @"/unzip"];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    BOOL success = NO;
    
    ZipArchive* zip = [[ZipArchive alloc] init];
    if ([zip UnzipOpenFile:packetPath]){
        success = [zip UnzipFileTo:unzipPacketPath overWrite:YES];
        [zip UnzipCloseFile];
    }
    [zip release];
    
    if (success){
        NSArray* subPaths = [fileManager contentsOfDirectoryAtPath:unzipPacketPath error:&error];
        for (NSString* subPath in subPaths) {
            NSString* srcPath = [NSString stringWithFormat:@"%@/%@", unzipPacketPath, subPath];
            NSString* dstPath = [NSString stringWithFormat:@"%@/%@", resourcePath, subPath];
            if ([fileManager fileExistsAtPath:dstPath]){
                success &= [fileManager removeItemAtPath:dstPath error:&error];
            }
            success &= [fileManager copyItemAtPath:srcPath toPath:dstPath error:&error]; 
        }
    }
    
    success &= [fileManager removeItemAtPath:unzipPacketPath error:&error];
    
    return success;
}
@end
