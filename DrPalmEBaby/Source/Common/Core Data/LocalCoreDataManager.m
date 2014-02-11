//
//  LocalCoreDataManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-4.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "LocalCoreDataManager.h"
#import <objc/runtime.h>

// for multiple school
//#import "DrPalmGatewayManagerInclude.h"
// not sure what to call this, just a placeholder for now, still hard coding file name below
#define SQLLITE_PREFIX @"CoreDataXML."
#define LOCAL_MANAGER_CONTEXT @"LocalCoreDataManagedObjectContext"
#define SQLLITE_SUFFIX @".sqlite"

@implementation LocalCoreDataManager

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

#pragma mark -
#pragma mark Class methods

+(id)coreDataManager {
	static LocalCoreDataManager *sharedInstance;
	if (!sharedInstance) {
		sharedInstance = [LocalCoreDataManager new];
	}
	return sharedInstance;
}

#pragma mark -
#pragma mark *** Public accessors ***

+(NSArray *)fetchDataForAttribute:(NSString *)attributeName {
	return [[LocalCoreDataManager coreDataManager] fetchDataForAttribute:attributeName];
}

+(NSArray *)fetchDataForAttribute:(NSString *)attributeName sortDescriptor:(NSSortDescriptor *)sortDescriptor {
	return [[LocalCoreDataManager coreDataManager] fetchDataForAttribute:attributeName sortDescriptor:sortDescriptor];
}

+(void)clearDataForAttribute:(NSString *)attributeName {
	[[LocalCoreDataManager coreDataManager] clearDataForAttribute:attributeName];
}

+(id)insertNewObjectForEntityForName:(NSString *)entityName {
	return [[LocalCoreDataManager coreDataManager] insertNewObjectForEntityForName:entityName];
}

+(id)insertNewObjectWithNoContextForEntity:(NSString *)entityName {
	return [[LocalCoreDataManager coreDataManager] insertNewObjectWithNoContextForEntity:entityName];
}

+(id)objectsForEntity:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    return [[LocalCoreDataManager coreDataManager] objectsForEntity:entityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
}

+(id)objectsForEntity:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate {
    return [[LocalCoreDataManager coreDataManager] objectsForEntity:entityName matchingPredicate:predicate];
}

+(id)getObjectForEntity:(NSString *)entityName attribute:(NSString *)attributeName value:(id)value {
	return [[LocalCoreDataManager coreDataManager] getObjectForEntity:entityName attribute:attributeName value:value];
}

+(void)deleteObjects:(NSArray *)objects {
    [[LocalCoreDataManager coreDataManager] deleteObjects:objects];
}

+(void)deleteObject:(NSManagedObject *)object {
	[[LocalCoreDataManager coreDataManager] deleteObject:object];
}

+(void)saveData {
	[[LocalCoreDataManager coreDataManager] saveData];
}

+(void)saveDataWithTemporaryMergePolicy:(id)temporaryMergePolicy {
    NSManagedObjectContext *context = [LocalCoreDataManager managedObjectContext];
    id originalMergePolicy = [context mergePolicy];
    [context setMergePolicy:NSOverwriteMergePolicy];
	[self saveData];
	[context setMergePolicy:originalMergePolicy];
}

+(BOOL)wipeData {
    return [[LocalCoreDataManager coreDataManager] wipeData];
}
+(BOOL)isExist {
    return [[LocalCoreDataManager coreDataManager] isExist];
}
+(NSManagedObjectModel *)managedObjectModel {
	return [[LocalCoreDataManager coreDataManager] managedObjectModel];
}

+(NSManagedObjectContext *)managedObjectContext {
	return [[LocalCoreDataManager coreDataManager] managedObjectContext];
}

+(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	return [[LocalCoreDataManager coreDataManager] persistentStoreCoordinator];
}

#pragma mark -
#pragma mark CoreData object methods

-(NSArray *)fetchDataForAttribute:(NSString *)attributeName {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];	// make a request object
	NSEntityDescription *entity = [NSEntityDescription entityForName:attributeName inManagedObjectContext:self.managedObjectContext];	// tell the request what to look for
	[request setEntity:entity];
	
	NSError *error;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    // TODO: handle errors when Core Data calls fail
    [request release];
    
	return result;
}

-(NSArray *)fetchDataForAttribute:(NSString *)attributeName sortDescriptor:(NSSortDescriptor *)sortDescriptor {
    NSArray *result = nil;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];	// make a request object
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if (self.managedObjectContext) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:attributeName inManagedObjectContext:self.managedObjectContext];	// tell the request what to look for
        [request setEntity:entity];
        
        NSError *error;
        result = [self.managedObjectContext executeFetchRequest:request error:&error];
    }
    [request release];
    
	return result;
}

-(void)clearDataForAttribute:(NSString *)attributeName {
	for (id object in [self fetchDataForAttribute:attributeName]) {
		[self deleteObject:(NSManagedObject *)object];
	}
	[self saveData];
}

-(void)deleteObjects:(NSArray *)objects {
    for (NSManagedObject *object in objects) {
        [self.managedObjectContext deleteObject:object];
    }
}

-(void)deleteObject:(NSManagedObject *)object {
	[self.managedObjectContext deleteObject:object];
}

-(id)insertNewObjectForEntityForName:(NSString *)entityName {
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

-(id)insertNewObjectForEntityForName:(NSString *)entityName context:(NSManagedObjectContext *)aManagedObjectContext {
	NSEntityDescription *entityDescription = [[managedObjectModel entitiesByName] objectForKey:entityName];
	return [[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:aManagedObjectContext] autorelease];
}

-(id)insertNewObjectWithNoContextForEntity:(NSString *)entityName {
	return [self insertNewObjectForEntityForName:entityName context:nil];
}

-(id)objectsForEntity:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entity];
	if (predicate != nil) {
		[request setPredicate:predicate];
	}
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
	
	NSError *error = nil;
    NSArray *objects;
    @try {
        objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"executeFetchRequest Exception");
        objects = nil;
    }	
    // Should only return 'nil' on error
    return objects;
}

-(id)objectsForEntity:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate {
    return [self objectsForEntity:entityName matchingPredicate:predicate sortDescriptors:nil];
}

-(id)getObjectForEntity:(NSString *)entityName attribute:(NSString *)attributeName value:(id)value {
	NSString *predicateFormat = [attributeName stringByAppendingString:@" like %@"];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, value];
    NSArray *objects = [self objectsForEntity:entityName matchingPredicate:predicate];
    return ([objects count] > 0) ? [objects lastObject] : nil;
}

-(void)saveData {
	NSError *error = nil;
    
    // fgx 2011-12-14 add {
    if ([self.managedObjectContext hasChanges])
    {
        // } fgx 2011-12-14 add
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
            NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
            if(detailedErrors != nil && [detailedErrors count] > 0) {
                for(NSError* detailedError in detailedErrors) {
                    NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                }
            }
            else {
                NSLog(@"  %@", [error userInfo]);
            }
        }
    }
}

- (BOOL)wipeData {
    NSError *error = nil;
    NSString *storePath = [self storeFileName];
#ifdef DEBUG
    NSString *backupPath = [storePath stringByAppendingString:@".bak"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:backupPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:backupPath
                                                   error:NULL];
    }
    
    if (![[NSFileManager defaultManager] copyItemAtPath:storePath toPath:backupPath error:&error]) {
        NSLog(@"Failed to copy old store, error %d: %@", [error code], [error description]);
        for (NSError *detailedError in [[error userInfo] objectForKey:NSDetailedErrorsKey]) {
            NSLog(@"%@", [detailedError userInfo]);
        }
        return NO;
    } else if (![[NSFileManager defaultManager] removeItemAtPath:storePath error:&error]) {
        NSLog(@"Failed to remove old store with error %d: %@", [error code], [error userInfo]);
        NSLog(@"Old store is at %@", storePath);
        return NO;
    } else {
        NSLog(@"Old store is backed up at %@", backupPath);
    }
#else
    if (![[NSFileManager defaultManager] removeItemAtPath:storePath error:&error]) {
        NSLog(@"Failed to remove old store with error %d: %@", [error code], [error userInfo]);
        return NO;
    }
#endif
    return YES;
}

#pragma mark -
#pragma mark Core Data stack

// modified to allow safe multithreaded Core Data use
-(NSManagedObjectContext *)managedObjectContext {
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    
    NSMutableString *curContext = [NSMutableString string];
    [curContext appendString:LOCAL_MANAGER_CONTEXT];
    
    NSManagedObjectContext *localContext = [threadDict objectForKey:curContext];
    if (localContext) {
        return localContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        localContext = [[NSManagedObjectContext alloc] init];
        [localContext setPersistentStoreCoordinator: coordinator];
        [threadDict setObject:localContext forKey:curContext];
        [localContext release];
    }
    return localContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
	// override the autogenerated method -- see http://iphonedevelopment.blogspot.com/2009/09/core-data-migration-problems.html
	NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:2];
	// list all xcdatamodeld's here
	NSArray *allModels = [NSArray arrayWithObjects:@"LocalArea", nil];
	for (NSString *modelName in allModels) {
		NSString *path = [[NSBundle mainBundle] pathForResource:modelName ofType:@"momd"];
        if (nil != path)
        {
            NSManagedObjectModel *aModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
            [models addObject:aModel];
            [aModel release];
        }
	}
	
	managedObjectModel = [NSManagedObjectModel modelByMergingModels:models];
	[models release];
    
    return managedObjectModel;
	
	
	// any data model in this project will have the compiled MOM file attached to the main application bundle...
    //managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];	// so, specify nil to get any MOM files found in the main bundle
    //return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSString *storePath = [self storeFileName];
	NSURL *storeURL = [NSURL fileURLWithPath:storePath];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])  {
		NSLog(@"LocalCoreDataManager failed to create or access the persistent store: %@", [error userInfo]);
		
		// see if we failed because of changes to the db
		if (![[self storeFileName] isEqualToString:[self currentStoreFileName]]) {
			NSLog(@"This app has been upgraded since last use of Core Data. If it crashes on launch, reinstalling should fix it.");
			if ([self migrateData]) {
                // storeFileName has changed
				storeURL = [NSURL fileURLWithPath:[self storeFileName]];
			} else {
				NSLog(@"Data migration failed! Wiping out core data.");
                [self wipeData];
			}
            
            NSLog(@"Attempting to recreate the persistent store...");
            if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                          configuration:nil URL:storeURL options:options error:&error]) {
                NSLog(@"Failed to recreate the persistent store: %@", [error userInfo]);
            }
		}
        // putting this here for faster debugging.
        // TODO: in production the user should be the one initiating this.
        else {
            NSLog(@"Nothing to migrate! Wiping out core data.");
            [self wipeData];
            
            [persistentStoreCoordinator release];
            persistentStoreCoordinator = nil;
            
            [managedObjectModel release];
            managedObjectModel = nil;
        }
    }
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString *)storeFileName {
	NSString *currentFileName = [self currentStoreFileName];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:currentFileName]) {
		NSInteger maxVersion = 0;
		NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self applicationDocumentsDirectory] error:NULL];
		// find all files like CoreDataXML.* and pick the latest one
		for (NSString *file in files) {
			if ([file hasPrefix:SQLLITE_PREFIX] && [file hasSuffix:SQLLITE_SUFFIX]) {
				// if version is something like 3:4M, this takes 3 to be the pre-existing version
				NSInteger version = [[[file componentsSeparatedByString:@"."] objectAtIndex:1] intValue];
				if (version >= maxVersion) {
					maxVersion = version;
					currentFileName = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:file];
				}
			}
		}
	}
	NSLog(@"Core Data stored at %@", currentFileName);
	return currentFileName;
}

- (NSString *)currentStoreFileName {
    // modify by qh 2013/2/4 for mutiple school
    NSMutableString *storeFileName = [NSMutableString string];
    [storeFileName appendString:SQLLITE_PREFIX];
//    DrPalmGateWayManager *drPalmGateWayManager = DrPalmGateWayManagerInstance();
//    if(drPalmGateWayManager.schoolKey.length > 0) {
//        [storeFileName appendFormat:@"%@.", drPalmGateWayManager.schoolKey, nil];
//    }
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [storeFileName appendFormat:@"%@%@", version, SQLLITE_SUFFIX];
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:storeFileName];
    //	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"CoreDataXML.%@.sqlite", [MITBuildInfo revision]]];
}
- (BOOL)isExist {
    NSString *currentFileName = [self currentStoreFileName];
	return [[NSFileManager defaultManager] fileExistsAtPath:currentFileName];
}
#pragma mark -
#pragma mark Migration methods

- (BOOL)migrateData
{
	NSError *error = nil;
	
	NSString *sourcePath = [self storeFileName];
	NSURL *sourceURL = [NSURL fileURLWithPath:sourcePath];
	NSURL *destURL = [NSURL fileURLWithPath: [self currentStoreFileName]];
	
	NSLog(@"Attempting to migrate from %@ to %@", [[self storeFileName] lastPathComponent], [[self currentStoreFileName] lastPathComponent]);
    
	NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
																							  URL:sourceURL
																							error:&error];
	
	if (sourceMetadata == nil) {
		NSLog(@"Failed to fetch metadata with error %d: %@", [error code], [error userInfo]);
		return NO;
	}
	
	NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil
																	forStoreMetadata:sourceMetadata];
	
	if (sourceModel == nil) {
		NSLog(@"Failed to create source model");
		return NO;
	}
	
	NSManagedObjectModel *destinationModel = [self managedObjectModel];
    
	if ([destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata]) {
		NSLog(@"No persistent store incompatilibilities detected, cancelling");
		return YES;
	}
	
	NSLog(@"source model entities: %@", [[sourceModel entityVersionHashesByName] description]);
	NSLog(@"destination model entities: %@", [[destinationModel entityVersionHashesByName] description]);
	
	NSMappingModel *mappingModel;
	
	// try to get a mapping automatically first
	mappingModel = [NSMappingModel inferredMappingModelForSourceModel:sourceModel
													 destinationModel:destinationModel
																error:&error];
    
	if (mappingModel == nil) {
		NSLog(@"Could not create inferred mapping model: %@", [error userInfo]);
		// try again with xcmappingmodel files we created
		mappingModel = [NSMappingModel mappingModelFromBundles:nil
												forSourceModel:sourceModel
                                              destinationModel:destinationModel];
		
		if (mappingModel == nil) {
			NSLog(@"Failed to create mapping model");
			return NO;
		}
	}
	
	
	NSValue *classValue = [[NSPersistentStoreCoordinator registeredStoreTypes] objectForKey:NSSQLiteStoreType];
	Class sqliteStoreClass = (Class)[classValue pointerValue];
	Class sqliteStoreMigrationManagerClass = [sqliteStoreClass migrationManagerClass];
	
	NSMigrationManager *manager = [[[sqliteStoreMigrationManagerClass alloc]
                                    initWithSourceModel:sourceModel destinationModel:destinationModel] autorelease];
	
	if (![manager migrateStoreFromURL:sourceURL type:NSSQLiteStoreType options:nil withMappingModel:mappingModel
					 toDestinationURL:destURL destinationType:NSSQLiteStoreType destinationOptions:nil error:&error]) {
		NSLog(@"Migration failed with error %d: %@", [error code], [error userInfo]);
		return NO;
	}
	
	if (![[NSFileManager defaultManager] removeItemAtPath:sourcePath error:&error]) {
		NSLog(@"Failed to remove old store with error %d: %@", [error code], [error userInfo]);
	}
	
	NSLog(@"Migration complete!");
	return YES;
	
}








#pragma mark -

-(void)dealloc {
	[managedObjectModel release];
	[managedObjectContext release];
	[persistentStoreCoordinator release];
    
	[super dealloc];
}

@end
