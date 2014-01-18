//
//  UpdateResourceManager.h
//  DrPalm
//
//  Created by fgx_lion on 12-6-5.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateResourceManager : NSObject
+ (BOOL)updateResourceWithPacket:(NSString*)packetPath resourcePacket:(NSString*)resourcePath;
@end
