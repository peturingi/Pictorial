#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
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