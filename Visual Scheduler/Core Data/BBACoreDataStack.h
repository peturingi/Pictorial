#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Schedule.h"
#import "Pictogram.h"

@interface BBACoreDataStack : NSObject


/**
 
 [BBACoreData rollbackContext];
 [BBACoreData saveContext];
 [BBACoreData createObjectInContextOfClass: … ]
 [BBACoreData deleteObjectFromContext: … ];
 [BBACoreData fetchedResultsControllerForClass: … ]
 */

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;

+ (id)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectContext *)sharedManagedObjectContext;

#pragma mark - Pictogram
- (NSFetchedResultsController *)fetchedResultsControllerForPictogram;
- (Pictogram *)pictogramWithTitle:(NSString *)title withImage:(UIImage *)image;

#pragma mark - Schedule
- (NSFetchedResultsController *)fetchedResultsControllerForSchedule;
- (Schedule *)scheduleWithTitle:(NSString *)title withBackgroundColour:(NSInteger)colourIndex;
@end
