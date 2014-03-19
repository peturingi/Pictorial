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

#pragma mark - Activity
- (NSFetchedResultsController *)fetchedResultsControllerForActivity;

#pragma mark - Category
- (NSFetchedResultsController *)fetchedResultsControllerForCategory;

#pragma mark - Pictogram
- (NSFetchedResultsController *)fetchedResultsControllerForPictogram;
- (Pictogram *)pictogramWithTitle:(NSString *)title withImage:(UIImage *)image;

#pragma mark - Schedule
- (NSFetchedResultsController *)fetchedResultsControllerForSchedule;
- (Schedule *)scheduleWithTitle:(NSString *)title withBackgroundColour:(NSInteger)colourIndex;
@end
