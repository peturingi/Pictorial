#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PictogramSelectorDataSource : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (NSManagedObject *)pictogramAtIndexPath:(NSIndexPath * const)indexPath;

@end