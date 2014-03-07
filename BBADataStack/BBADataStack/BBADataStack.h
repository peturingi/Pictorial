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
    BOOL _inMemory;
}

+(instancetype)stackWithModelNamed:(NSString*)modelName andStoreFileNamed:(NSString*)storeFileName;
+(instancetype)stackInMemoryWithModelNamed:(NSString*)modelName;

-(NSArray*)resultFromFetchRequest:(NSFetchRequest*)fetchRequest;
-(NSFetchedResultsController*)fetchedResultsControllerFromFetchRequest:(NSFetchRequest*)request;
-(NSFetchRequest*)fetchRequestForEntityClass:(Class)aClass;
-(NSManagedObject*)insertNewManagedObjectFromClass:(Class)aClass;
-(void)deleteObject:(NSManagedObject*)anObject;
-(void)deleteStoreAndResetStack;
-(void)saveAll;

@end
