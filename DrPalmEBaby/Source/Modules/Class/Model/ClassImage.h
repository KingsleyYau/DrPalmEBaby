//
//  ClassImage.h
//  DrPalm4Ebaby2
//
//  Created by KingsleyYau on 14-1-17.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassEvent, ClassEventSent, ClassFile;

@interface ClassImage : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) ClassFile *fullImage;
@property (nonatomic, retain) NSSet *mainImageParent;
@property (nonatomic, retain) NSSet *mainImageSentParent;
@property (nonatomic, retain) ClassFile *smallImage;
@property (nonatomic, retain) ClassFile *thumbImage;
@end

@interface ClassImage (CoreDataGeneratedAccessors)

- (void)addMainImageParentObject:(ClassEvent *)value;
- (void)removeMainImageParentObject:(ClassEvent *)value;
- (void)addMainImageParent:(NSSet *)values;
- (void)removeMainImageParent:(NSSet *)values;

- (void)addMainImageSentParentObject:(ClassEventSent *)value;
- (void)removeMainImageSentParentObject:(ClassEventSent *)value;
- (void)addMainImageSentParent:(NSSet *)values;
- (void)removeMainImageSentParent:(NSSet *)values;

@end
