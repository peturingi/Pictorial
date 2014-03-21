#import "BBACoreDataStack.h"
#import "UIApplication+BBA.h"
#import "UIImage+BBA.h"
#import "BBAModel.h"
#import "BBAStore.h"
#import "BBAContext.h"
#import "BBAServiceProvider.h"

@implementation BBACoreDataStack

-(id)init __deprecated{
    @throw [NSException exceptionWithName:NSObjectNotAvailableException reason:@"Do not use -init. Use +installInMemory: instead" userInfo:nil];
    return nil;
}

+ (id)sharedInstance {
    BBACoreDataStack* stack = [BBAServiceProvider serviceFromClass:[self class]];
    return stack;
}

+(void)installInMemory:(BOOL)yesno{
    BBACoreDataStack* stack = [[BBACoreDataStack alloc]initInMemory:yesno];
    [BBAServiceProvider insertService:stack];
}

-(id)initInMemory:(BOOL)yesno{
    self = [super init];
    if(self){
        [self setupStack:yesno];
    }
    return self;
}

-(void)setupStack:(BOOL)inMemory{
    BBAModel* model = [BBAModel modelFromModelNamed:@"CoreData"];
    BBAStore* store;
    if(inMemory){
        store = [BBAStore inMemoryStoreWithModel:[model managedObjectModel]];
    }else{
        store = [BBAStore storeWithModel:[model managedObjectModel] andStoreFileURL:[self storeFileURL]];
    }
    BBAContext* context = [BBAContext contextWithStore:[store persistentStoreCoordinator]];
    _context = [context managedObjectContext];
}

-(NSURL*)storeFileURL{
    NSURL* documentsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    return [documentsDir URLByAppendingPathComponent:@"storeFile"];
}


+(void)rollbackContext{
    BBACoreDataStack* stack = [BBAServiceProvider serviceFromClass:[self class]];
    [stack rollback];
}

+(BOOL)saveContext:(NSError**)error{
    BBACoreDataStack* stack = [BBAServiceProvider serviceFromClass:[self class]];
    return [stack saveAll:error];
}

+(void)deleteObjectFromContext:(NSManagedObject*)managedObject{
    BBACoreDataStack* stack = [BBAServiceProvider serviceFromClass:[self class]];
    [stack deleteObject:managedObject];
}

+(NSManagedObject*)createObjectInContexOfClass:(Class)aClass{
    BBACoreDataStack* stack = [BBAServiceProvider serviceFromClass:[self class]];
    return [stack insertNewManagedObjectFromClass:aClass];
}

+(NSFetchedResultsController*)fetchedResultsControllerForClass:(Class)aClass{
    BBACoreDataStack* stack = [BBAServiceProvider serviceFromClass:[self class]];
    NSFetchRequest* fetchRequest = [stack fetchRequestForEntityClass:aClass];
    NSSortDescriptor* descriptor = [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES];
    NSArray* sortDescriptors = @[descriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:20];
    return [stack fetchedResultsControllerFromFetchRequest:fetchRequest];
}

+(NSManagedObjectContext*)managedObjectContext{
    BBACoreDataStack* stack = [BBAServiceProvider serviceFromClass:[self class]];
    return stack->_context;
}

/** refactor this later! */
-(NSManagedObject*)insertNewManagedObjectFromClass:(Class)aClass{
    NSString* entityName = NSStringFromClass([aClass class]);
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:_context];
}

-(NSFetchRequest*)fetchRequestForEntityClass:(Class)aClass{
    NSString* entityName = NSStringFromClass([aClass class]);
    return [[NSFetchRequest alloc]initWithEntityName:entityName];
}
     
-(NSFetchedResultsController*)fetchedResultsControllerFromFetchRequest:(NSFetchRequest*)request{
         return [[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                   managedObjectContext:_context
                                                     sectionNameKeyPath:nil
                                                              cacheName:nil];
}

-(void)rollback{
    [_context rollback];
}

-(BOOL)saveAll:(NSError**)error{
    if([_context hasChanges]){
        return [_context save:error];
    }
    return YES;
}

-(void)deleteObject:(NSManagedObject*)object{
    [_context deleteObject:object];
}

@end
