#import "BBADataStack.h"
#import "BBAModel.h"
#import "BBAStore.h"
#import "BBAContext.h"

@implementation BBADataStack

#pragma mark - public methods

+(instancetype)stackInMemoryStoreFromMergedModelBundle{
    return [[BBADataStack alloc]initInMemoryFromBundle];
}

+(instancetype)stackFromMergedModelBundleAndStoreNamed:(NSString*)storeFileName{
    return [[BBADataStack alloc]initFromBundleWithStoreFile:storeFileName];
}

+(instancetype)stackInMemoryWithModelNamed:(NSString*)modelName{
    return [[BBADataStack alloc]initInMemoryWithModelNamed:modelName];
}

+(instancetype)stackWithModelNamed:(NSString *)modelName andStoreFileNamed:(NSString *)storeFileName{
    return [[BBADataStack alloc]initWithModelNamed:modelName andStoreFileNamed:storeFileName];
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
-(id)initInMemoryFromBundle{
    self = [super init];
    if(self){
        _inMemory = YES;
        _fromBundle = YES;
        [self setupStack];
    }
    return self;
}

-(id)initInMemoryWithModelNamed:(NSString*)modelName{
    self = [super init];
    if(self){
        _inMemory = YES;
        _modelName = modelName;
        [self setupStack];
    }
    return self;
}

-(id)initFromBundleWithStoreFile:(NSString*)storeFileName{
    self = [super init];
    if(self){
        _storeFileName = storeFileName;
        _inMemory = NO;
        _fromBundle = YES;
        [self setupStack];
    }
    return self;
}

-(id)initWithModelNamed:(NSString *)modelName andStoreFileNamed:(NSString *)storeFileName{
    self = [super init];
    if(self){
        _inMemory = NO;
        _storeFileName = storeFileName;
        _modelName = modelName;
        [self setupStack];
    }
    return self;
}

-(void)setupStack{
    [self setupModel];
    [self setupStore];
    [self setupContext];
}

-(void)setupModel{
    if(_fromBundle){
        _model = [BBAModel mergedBundleModel];
    }else{
        _model = [BBAModel modelFromModelNamed:_modelName];
    }
}

-(void)setupStore{
    NSAssert(_model, @"cannot instantiate store before model");
    if(_inMemory){
        _store = [BBAStore inMemoryStoreWithModel:[_model managedObjectModel]];
    }else{
        _store = [BBAStore storeWithModel:[_model managedObjectModel] andStoreFileURL:[self storeFileURL]];
    }

}

-(void)setupContext{
    NSAssert(_store, @"cannot instantiate context before store");
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
