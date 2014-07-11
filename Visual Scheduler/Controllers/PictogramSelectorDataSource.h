#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PictogramSelectorDataSource : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end