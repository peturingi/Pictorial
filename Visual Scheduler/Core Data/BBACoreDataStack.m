#import "BBACoreDataStack.h"
#import "UIApplication+BBA.h"
#import "UIImage+BBA.h"

@interface BBACoreDataStack() {
    
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end

static id sharedInstance = nil;

@implementation BBACoreDataStack

- (id)init {
    [self BBA_throwExceptionIfAlreadyInstantiated];
    self = [super init];
    return self;
}
        
- (void)BBA_throwExceptionIfAlreadyInstantiated {
    if (sharedInstance != nil) {
        @throw [NSException exceptionWithName:NSObjectNotAvailableException reason:@"This is a shared object. New instantiations are not allowed." userInfo:nil];
    }
}

+ (id)sharedInstance {
    if (sharedInstance == nil) {
        @try {
            sharedInstance = [[BBACoreDataStack alloc] init];
        }
        @catch (NSException *e){
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Could not create a shared instance." userInfo:nil];
        }
    }
    return sharedInstance;
}

- (NSManagedObjectContext *)sharedManagedObjectContext {
    return self.managedObjectContext;
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    [self setupManagedObjectModelFromFile];
    return _managedObjectModel;
}

- (void)setupManagedObjectModelFromFile {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        // TODO ERROR HANDLING
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Activity
- (NSFetchedResultsController *)fetchedResultsControllerForActivity {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:30];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Activity"];
    return fetchedResultsController;
}

#pragma mark - Category

- (NSFetchedResultsController*)fetchedResultsControllerForCategory {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PictoCategory" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:30];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Activity"];
    return fetchedResultsController;
}

#pragma mark - Pictogram

- (Pictogram *)pictogramWithTitle:(NSString *)title withImage:(UIImage *)image {
    NSManagedObjectContext *context = [[BBACoreDataStack sharedInstance] sharedManagedObjectContext];
    Pictogram *pictogram = [NSEntityDescription insertNewObjectForEntityForName:@"Pictogram" inManagedObjectContext:context];
    [pictogram setTitle:title];
    NSString *url = [[UIApplication sharedApplication] uniqueFileNameWithPrefix:@"pictogram"];
    [pictogram setImageURL:url];
    [image saveAtLocation:url];
    // TODO this will save the entire context, also other changes we might not be interested in saving at this point in time.
    // TODO is it possible to save only this single object?
    [self saveContext];
    return pictogram;
}

- (NSFetchedResultsController *)fetchedResultsControllerForPictogram {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pictogram" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:30];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Pictogram"];
    return fetchedResultsController;
     
}

#pragma mark - Schedule

- (Schedule *)scheduleWithTitle:(NSString *)title withPictogramAsLogo:(Pictogram *)image withBackgroundColour:(NSInteger)colourIndex {
    NSManagedObjectContext *context = [[BBACoreDataStack sharedInstance] sharedManagedObjectContext];
    Schedule *schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:context];
    [schedule setTitle:title];
    [schedule setDate:[NSDate date]];
    [schedule setColour:[NSNumber numberWithInteger:colourIndex]];
    [schedule setLogo:image];
    if (![context save:nil]) {
        // TODO: Deal with out of space, and different kind of errors.
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Could not save schedule." userInfo:nil];
    }
    return schedule;
}

- (NSFetchedResultsController *)fetchedResultsControllerForSchedule {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:30];
    NSSortDescriptor* descriptor = [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[descriptor]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Schedule"];
    return fetchedResultsController;
}



@end
