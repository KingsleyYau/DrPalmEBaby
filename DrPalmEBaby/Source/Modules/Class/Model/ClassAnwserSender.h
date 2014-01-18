//
//  ClassAnwserSender.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 13-12-31.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassAnwserContent, ClassAnwserMan, ClassFile;

@interface ClassAnwserSender : NSManagedObject

@property (nonatomic, retain) NSString * itemID;
@property (nonatomic, retain) NSDate * senderImageLastUpdate;
@property (nonatomic, retain) NSString * senderName;
@property (nonatomic, retain) NSSet *anwserContents;
@property (nonatomic, retain) NSSet *anwserMan;
@property (nonatomic, retain) ClassFile *senderImage;
@end

@interface ClassAnwserSender (CoreDataGeneratedAccessors)

- (void)addAnwserContentsObject:(ClassAnwserContent *)value;
- (void)removeAnwserContentsObject:(ClassAnwserContent *)value;
- (void)addAnwserContents:(NSSet *)values;
- (void)removeAnwserContents:(NSSet *)values;

- (void)addAnwserManObject:(ClassAnwserMan *)value;
- (void)removeAnwserManObject:(ClassAnwserMan *)value;
- (void)addAnwserMan:(NSSet *)values;
- (void)removeAnwserMan:(NSSet *)values;

@end
