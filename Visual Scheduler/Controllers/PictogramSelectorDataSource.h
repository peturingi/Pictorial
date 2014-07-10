#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pictogram;

@interface PictogramSelectorDataSource : NSObject <UICollectionViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end