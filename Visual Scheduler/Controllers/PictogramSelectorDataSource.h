#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pictogram;

@interface PictogramSelectorDataSource : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (Pictogram *)pictogramAtIndexPath:(NSIndexPath * const)indexPath;

@end