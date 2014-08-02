#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface WeekDataSource : NSObject <UICollectionViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property BOOL editing;

- (NSManagedObject *)pictogramAtIndexPath:(NSIndexPath * const)indexPath;

/** Save any changes made to the data source.
 */
- (void)save;

@end