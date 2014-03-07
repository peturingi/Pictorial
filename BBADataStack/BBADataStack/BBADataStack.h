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
    BOOL _fromBundle;
}

+(instancetype)stackWithModelNamed:(NSString*)modelName andStoreFileNamed:(NSString*)storeFileName;
+(instancetype)stackInMemoryWithModelNamed:(NSString*)modelName;
+(instancetype)stackInMemoryStoreFromMergedModelBundle;
+(instancetype)stackFromMergedModelBundleAndStoreNamed:(NSString*)storeFileName;

-(NSArray*)resultFromFetchRequest:(NSFetchRequest*)fetchRequest;
-(NSFetchedResultsController*)fetchedResultsControllerFromFetchRequest:(NSFetchRequest*)request;
-(NSFetchRequest*)fetchRequestForEntityClass:(Class)aClass;
-(NSManagedObject*)insertNewManagedObjectFromClass:(Class)aClass;
-(void)deleteObject:(NSManagedObject*)anObject;
-(void)deleteStoreAndResetStack;
-(void)saveAll;

@end
