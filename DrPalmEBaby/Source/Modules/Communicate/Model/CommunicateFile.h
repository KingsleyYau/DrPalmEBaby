//
//  CommunicateFile.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-12-18.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CommunicateMan;

@interface CommunicateFile : NSManagedObject

@property (nonatomic, retain) NSString * contentType;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * fileExt;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * pathType;
@property (nonatomic, retain) NSSet *communicateMan;
@end

@interface CommunicateFile (CoreDataGeneratedAccessors)

- (void)addCommunicateManObject:(CommunicateMan *)value;
- (void)removeCommunicateManObject:(CommunicateMan *)value;
- (void)addCommunicateMan:(NSSet *)values;
- (void)removeCommunicateMan:(NSSet *)values;

@end
