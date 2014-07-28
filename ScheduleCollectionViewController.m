#import "ScheduleCollectionViewController.h"
#import <CoreData/CoreData.h>

@implementation ScheduleCollectionViewController

- (IBAction)removePictogramFromSchedule:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSIndexPath * const pathOfPictogramToRemove = [self.collectionView indexPathForItemAtPoint:[sender locationInView:sender.view]];
        if (pathOfPictogramToRemove) {
            const id <NSFetchedResultsSectionInfo> section = [self.dataSource.fetchedResultsController sections][pathOfPictogramToRemove.section];
            NSAssert([section objects].count == 1, @"Each day (section) must contain only a single schedule.");
            const NSManagedObject *schedule = [section objects].firstObject;
    
            // Get the pictogram I want to display.
            NSMutableArray *pictogramsInSchedule = [schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS];
            [pictogramsInSchedule removeObjectAtIndex:pathOfPictogramToRemove.item];
            [schedule setValue:pictogramsInSchedule forKeyPath:CD_KEY_SCHEDULE_PICTOGRAMS];
            // TODO save the context.
            [self.collectionView deleteItemsAtIndexPaths:@[pathOfPictogramToRemove]];
        }
    }
}

@end
