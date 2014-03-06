#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MockManagedObjectContext : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext;

@end
