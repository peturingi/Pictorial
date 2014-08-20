#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Schedule;
@class Pictogram;
@class PictogramContainer;

@interface WeekDataSource : NSObject <UICollectionViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property BOOL editing;

- (Pictogram *)pictogramAtIndexPath:(NSIndexPath * const)indexPath;
- (PictogramContainer *)pictogramContainerAtIndexPath:(NSIndexPath * const)indexPath;

- (Schedule *)scheduleForSection:(NSUInteger const)section;

/** Save any changes made to the data source.
 */
- (void)save;

- (NSIndexPath *)indexPathToPictogramContainer:(PictogramContainer * const)pictogramContainer inCollectionView:(UICollectionView * const)collectionView;
@end