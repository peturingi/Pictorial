#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[self printDatabase];
    //[self populateDatabase];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
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

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Mock Data Generator

- (void)printDatabase {
    // Populate database if it is empty.
     NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Pictogram"];
     NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
     [request setSortDescriptors:[NSArray arrayWithObject:sort]];
     [request setFetchBatchSize:20];
     NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
     [controller performFetch:nil];
    
    for (id i in controller.fetchedObjects) { NSLog(@"%@", i); }
}

- (void)populateDatabase {
     
    /* pictograms */
     NSManagedObject *svane = [NSEntityDescription insertNewObjectForEntityForName:@"Pictogram" inManagedObjectContext:self.managedObjectContext];
     [svane setValue:@"Svane" forKey:@"title"];
     UIImage *image = [UIImage imageNamed:@"svane.png"];
     [svane setValue:UIImagePNGRepresentation(image) forKey:@"image"];
     //
     NSManagedObject *spade = [NSEntityDescription insertNewObjectForEntityForName:@"Pictogram" inManagedObjectContext:self.managedObjectContext];
     [spade setValue:@"Spade" forKey:@"title"];
     UIImage *spadeImage = [UIImage imageNamed:@"spade.png"];
     [spade setValue:UIImagePNGRepresentation(spadeImage) forKey:@"image"];
     
     
     /* days */
     NSManagedObject *s1 = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:self.managedObjectContext];
     NSManagedObject *s2 = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:self.managedObjectContext];
     NSManagedObject *s3 = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:self.managedObjectContext];
     NSManagedObject *s4 = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:self.managedObjectContext];
     NSManagedObject *s5 = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:self.managedObjectContext];
     NSManagedObject *s6 = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:self.managedObjectContext];
     NSManagedObject *s7 = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:self.managedObjectContext];
     //
     [s1 setValue:@"Mánudagur" forKey:@"title"];
     [s2 setValue:@"Þriðjudagur" forKey:@"title"];
     [s3 setValue:@"Miðvikudagur" forKey:@"title"];
     [s4 setValue:@"Fimmtudagur" forKey:@"title"];
     [s5 setValue:@"Föstudagur" forKey:@"title"];
     [s6 setValue:@"Laugardagur" forKey:@"title"];
     [s7 setValue:@"Sunnudagur" forKey:@"title"];
     //
     const NSTimeInterval secondsInDay = 86400;
     NSDate *d1 = [NSDate dateWithTimeIntervalSinceNow: 0 * secondsInDay];
     NSDate *d2 = [NSDate dateWithTimeIntervalSinceNow: 1 * secondsInDay];
     NSDate *d3 = [NSDate dateWithTimeIntervalSinceNow: 2 * secondsInDay];
     NSDate *d4 = [NSDate dateWithTimeIntervalSinceNow: 3 * secondsInDay];
     NSDate *d5 = [NSDate dateWithTimeIntervalSinceNow: 4 * secondsInDay];
     NSDate *d6 = [NSDate dateWithTimeIntervalSinceNow: 5 * secondsInDay];
     NSDate *d7 = [NSDate dateWithTimeIntervalSinceNow: 6 * secondsInDay];
     //
     [s1 setValue:d1 forKey:@"date"];
     [s2 setValue:d2 forKey:@"date"];
     [s3 setValue:d3 forKey:@"date"];
     [s4 setValue:d4 forKey:@"date"];
     [s5 setValue:d5 forKey:@"date"];
     [s6 setValue:d6 forKey:@"date"];
     [s7 setValue:d7 forKey:@"date"];
     //
     [s1 setValue:[NSKeyedArchiver archivedDataWithRootObject:[UIColor yellowColor]] forKey:@"color"];
     [s2 setValue:[NSKeyedArchiver archivedDataWithRootObject:[UIColor redColor]] forKey:@"color"];
     [s3 setValue:[NSKeyedArchiver archivedDataWithRootObject:[UIColor greenColor]] forKey:@"color"];
     [s4 setValue:[NSKeyedArchiver archivedDataWithRootObject:[UIColor blueColor]] forKey:@"color"];
     [s5 setValue:[NSKeyedArchiver archivedDataWithRootObject:[UIColor blackColor]] forKey:@"color"];
     [s6 setValue:[NSKeyedArchiver archivedDataWithRootObject:[UIColor whiteColor]] forKey:@"color"];
     [s7 setValue:[NSKeyedArchiver archivedDataWithRootObject:[UIColor purpleColor]] forKey:@"color"];
     
    /* relations */
    NSManagedObject *c1 = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *c2 = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *c3 = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *c4 = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *c5 = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *c6 = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *c7 = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer" inManagedObjectContext:self.managedObjectContext];
    //
    [c1 setValue:svane forKey:@"pictogram"];
    [c1 setValue:s1 forKey:@"schedule"];
    [c2 setValue:svane forKey:@"pictogram"];
    [c2 setValue:s2 forKey:@"schedule"];
    [c3 setValue:svane forKey:@"pictogram"];
    [c3 setValue:s3 forKey:@"schedule"];
    [c4 setValue:svane forKey:@"pictogram"];
    [c4 setValue:s4 forKey:@"schedule"];
    [c5 setValue:svane forKey:@"pictogram"];
    [c5 setValue:s5 forKey:@"schedule"];
    [c6 setValue:svane forKey:@"pictogram"];
    [c6 setValue:s6 forKey:@"schedule"];
    [c7 setValue:svane forKey:@"pictogram"];
    [c7 setValue:s7 forKey:@"schedule"];
/*
     NSMutableOrderedSet *allDaysAreTheSame = [[NSMutableOrderedSet alloc] initWithObjects:svane, spade, nil];
     
     [s1 setValue:allDaysAreTheSame forKey:@"pictograms"];
     [s2 setValue:allDaysAreTheSame forKey:@"pictograms"];
     [s3 setValue:allDaysAreTheSame forKey:@"pictograms"];
     [s4 setValue:allDaysAreTheSame forKey:@"pictograms"];
     [s5 setValue:allDaysAreTheSame forKey:@"pictograms"];
     [s6 setValue:allDaysAreTheSame forKey:@"pictograms"];
     [s7 setValue:allDaysAreTheSame forKey:@"pictograms"];
  */
     
     [self saveContext];
}

- (NSManagedObject *)objectWithID:(NSManagedObjectID * const)objectID {
    return [self.managedObjectContext objectWithID:objectID];
}


@end
