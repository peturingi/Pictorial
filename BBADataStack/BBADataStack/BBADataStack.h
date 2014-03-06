#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class BBAModel;
@class BBAStore;
@class BBAContext;

@interface BBADataStack : NSObject{
    BBAModel* _model;
    BBAStore* _store;
    BBAContext* _context;
    NSString* _modelName;
    NSString* _storeFileName;
}

+(instancetype)stackWithModelNamed:(NSString*)modelName andStoreFileNamed:(NSString*)storeFileName;

-(NSArray*)resultFromFetchRequest:(NSFetchRequest*)fetchRequest;
-(NSFetchedResultsController*)fetchedResultsControllerFromFetchRequest:(NSFetchRequest*)request;
-(NSFetchRequest*)fetchRequestForEntityClass:(Class)aClass;
-(NSManagedObject*)insertNewManagedObjectFromClass:(Class)aClass;
-(void)deleteObject:(NSManagedObject*)anObject;
-(void)deleteStoreAndResetStack;
-(void)saveAll;

@end
