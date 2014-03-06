#import "MockManagedObjectContext.h"

@interface MockManagedObjectContext ()
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@end

@implementation MockManagedObjectContext

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}



- (NSPersistentStoreCoordinator*)persistentStoreCoordinator;
{
    if (persistentStoreCoordinator) return persistentStoreCoordinator;
    
    NSBundle* bundle = [NSBundle mainBundle];
    NSURL* url = [bundle URLForResource:@"CoreData" withExtension:@"momd"];
    
    NSError* error = nil;
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:mom];
    
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                  configuration:nil
                                                            URL:nil
                                                        options:nil
                                                          error:&error]) {
        return nil;
    }
    return persistentStoreCoordinator;
}

@end
