#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pictogram;

#define CELL_TAG_FOR_IMAGE_VIEW     1
#define CELL_TAG_FOR_LABEL_VIEW     2

@interface PictogramSelectorDataSource : NSObject <UICollectionViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end