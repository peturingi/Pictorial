#import "BBACoreDataStack.h"
#import "BBAModel.h"
#import "BBAStore.h"
#import "BBAContext.h"

#import "BBAModel/BBAModel/Schedule.h"
#import "BBAModel/BBAModel/Activity.h"
#import "BBAModel/BBAModel/Pictogram.h"

@implementation BBACoreDataStack

#pragma mark - public methods

+ (id)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[BBACoreDataStack alloc] initWithModelNamed:@"CoreData" andStoreFileNamed:@"CoreData.sqlite"];
    });
    return _sharedObject;
}

- (NSManagedObjectContext *)sharedObjectContext {
    return [_context managedObjectContext];
}

- (void)insertScheduleWithTitle:(NSString *)aString logo:(UIImage *)image backgroundColor:(NSInteger)colorCode {
    Schedule *schedule = (Schedule *)[self insertNewManagedObjectFromClass:[Schedule class]];
    schedule.title = aString;
    // TODO store the image instead of discarding it.
    schedule.date = [NSDate date];
    // TODO handle saving of color
    schedule.colour = [NSNumber numberWithInteger:colorCode];
    
    [self saveAll];
}

- (void)insertPictogramWithTitle:(NSString *)aString andLocation:(NSString *)location {
    Pictogram *pictogram = (Pictogram *)[self insertNewManagedObjectFromClass:[Pictogram class]];
    pictogram.title = aString;
    pictogram.favorited = [NSNumber numberWithBool:NO];
    pictogram.imageURL = location;
    [self saveAll];
}

+(instancetype)stackWithModelNamed:(NSString *)modelName andStoreFileNamed:(NSString *)storeFileName{
    return [[BBACoreDataStack alloc]initWithModelNamed:modelName andStoreFileNamed:storeFileName];
}

-(NSFetchedResultsController*)fetchedResultsControllerFromFetchRequest:(NSFetchRequest*)request{
    return [[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                    managedObjectContext:[_context managedObjectContext]
                                                      sectionNameKeyPath:nil
                                                               cacheName:nil];
}

-(NSArray*)resultFromFetchRequest:(NSFetchRequest *)fetchRequest{
    if(!fetchRequest){
        [NSException raise:@"Request is nil" format:@"Attempted to execute a fetch for a nil fetch request."];
    }
    NSError* error = nil;
    NSArray* result = [[_context managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if(!result){
        [NSException raise:@"Results is nil" format:@"The resulting array is nil. This is probably caused by a wrongly configured fetch request. The generated error is: %@", error];
    }
    return result;
}

-(void)fetchFor:(NSFetchedResultsController*)fetchedResultsController{
    NSError* error = nil;
    BOOL success = [fetchedResultsController performFetch:&error];
    if(!success){
        [NSException raise:@"Fetch failed" format:@"Failed to perform a perform fetch on a fetched results controller. The generated error is: %@", error];
    }
}

-(NSFetchedResultsController*)fetchedResultsControllerForEntityClass:(Class)aClass batchSize:(NSUInteger)size andSortDescriptors:(NSArray *)sortDescriptors{
    NSFetchRequest* fetchRequest = [self fetchRequestForEntityClass:aClass];
    if(sortDescriptors){
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    [fetchRequest setFetchBatchSize:size];
    return [self fetchedResultsControllerFromFetchRequest:fetchRequest];
}

-(NSFetchRequest*)fetchRequestForEntityClass:(Class)aClass{
    NSString* entityName = NSStringFromClass([aClass class]);
    return [[NSFetchRequest alloc]initWithEntityName:entityName];
}

-(NSManagedObject*)insertNewManagedObjectFromClass:(Class)aClass{
    NSString* entityName = NSStringFromClass([aClass class]);
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                           inManagedObjectContext:[_context managedObjectContext]];
}

-(void)deleteObject:(NSManagedObject*)anObject{
    [_context deleteObject:anObject];
}

-(void)deleteStoreAndResetStack{
    NSLog(@"Deleting the storefile at runtime might have unexpected behaviour - use at own risk");
    NSLog(@"Any fetch requests or controllers should be nullified and requested again after this command");
    _context = nil;
    _model = nil;
    _store = nil;
    [self deleteStoreFile];
    [self setupStack];
}

#pragma mark - private methods
-(id)initWithModelNamed:(NSString *)modelName andStoreFileNamed:(NSString *)storeFileName{
    self = [super init];
    if(self){
        _storeFileName = storeFileName;
        _modelName = modelName;
        [self setupStack];
    }
    return self;
}

-(void)setupStack{
    _model = [BBAModel modelFromModelNamed:_modelName];
    _store = [BBAStore storeWithModel:[_model managedObjectModel] andStoreFileURL:[self storeFileURL]];
    _context = [BBAContext contextWithStore:[_store persistentStoreCoordinator]];
}

-(void)deleteStoreFile{
    NSError* error = nil;
    BOOL deleteSuccess = [[NSFileManager defaultManager] removeItemAtURL:[self storeFileURL] error:&error];
    if(!deleteSuccess){
        [NSException raise:@"Unsuccessful deletion of store file" format:@"Failed to delete the store file with the following error: %@", error];
    }
}

-(void)saveAll{
    [_context saveAll];
}

-(NSURL*)storeFileURL{
    NSURL* documentsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    return [documentsDir URLByAppendingPathComponent:_storeFileName];
}

-(id)init __deprecated{
    [NSException raise:@"-init not allowed" format:@"Initialization using standard -init is not allowed - please use the provided classmethod"];
    return nil;
}

@end
