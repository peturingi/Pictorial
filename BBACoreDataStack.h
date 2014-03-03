//
//  BBACoreDataStore.h
//  TestCoreData
//
//  Created by Brian Pedersen on 01/03/14.
//  Copyright (c) 2014 TestOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BBAModel;
@class BBAStore;
@class BBAContext;

@interface BBACoreDataStack : NSObject{
    BBAModel* _model;
    BBAStore* _store;
    BBAContext* _context;
    NSString* _modelName;
    NSString* _storeFileName;
}

+(instancetype)stackWithModelNamed:(NSString*)modelName andStoreFileNamed:(NSString*)storeFileName;

-(NSFetchedResultsController*)fetchedResultsControllerForEntityClass:(Class)aClass batchSize:(NSUInteger)size andSortDescriptors:(NSArray*)sortDescriptors;
-(void)performFetchForResultsController:(NSFetchedResultsController*)fetchedResultsController;
-(NSArray*)resultFromFetchRequest:(NSFetchRequest*)fetchRequest;
//-(NSFetchedResultsController*)fetchedResultsControllerFromFetchRequest:(NSFetchRequest*)request;
-(NSFetchRequest*)fetchRequestForEntityClass:(Class)aClass;
-(NSManagedObject*)insertNewManagedObjectFromClass:(Class)aClass;
-(void)deleteObject:(NSManagedObject*)anObject;
-(void)deleteStoreAndResetStack;
-(void)saveAll;

@end
