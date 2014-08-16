#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Schedule;

@interface WeekDataSource : NSObject <UICollectionViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property BOOL editing;

- (NSManagedObject *)pictogramAtIndexPath:(NSIndexPath * const)indexPath;

- (Schedule *)scheduleForSection:(NSUInteger const)section;

/** Save any changes made to the data source.
 */
- (void)save;

@end