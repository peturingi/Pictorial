#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Schedule.h"
#import "Pictogram.h"

@interface BBACoreDataStack : NSObject

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;

+ (id)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectContext *)sharedManagedObjectContext;

#pragma mark - Models
- (NSFetchedResultsController *)fetchedResultsControllerForSchedule;
- (Schedule *)scheduleWithTitle:(NSString *)title withPictogramAsLogo:(Pictogram *)pictogram withBackgroundColour:(NSInteger)colourIndex;
@end
