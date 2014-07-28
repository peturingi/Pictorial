#import "ScheduleCollectionViewController.h"
#import <CoreData/CoreData.h>

@implementation ScheduleCollectionViewController

#pragma mark - Remove pictogram from schedule

/** Removes the pressed pictogram from the schedule and collection view it belonged to; persists the changes.
 */
- (IBAction)handleRemovalOfPictogramFromScheduleGesture:(UIGestureRecognizer *)sender
{
    NSAssert(sender, @"This method depends on the sender parameter.");
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSIndexPath * const pictogramToRemove = [self.collectionView indexPathForItemAtPoint:[sender locationInView:sender.view]];
        if (pictogramToRemove) {
            [self removePictogramAtIndex:pictogramToRemove.item fromSchedule:[self scheduleInSection:pictogramToRemove.section]];
            [self saveSchedule];
            [self.collectionView deleteItemsAtIndexPaths:@[pictogramToRemove]];
        }
    }
}

/** A section in the collection view represents a single schedule.
 @pre The specified section contains one schedule.
 */
- (NSManagedObject *)scheduleInSection:(NSUInteger)section
{
    id <NSFetchedResultsSectionInfo> const sectionContainingSchedule = self.dataSource.fetchedResultsController.sections[section];
    NSAssert([sectionContainingSchedule objects].count == 1, @"There should be a single schedule per section!");
    return [sectionContainingSchedule objects].firstObject;
}

/** Removes a pictogram from the schedule.
 @pre A pictogram exists in the schedule at the given index.
 */
- (void)removePictogramAtIndex:(NSUInteger)index fromSchedule:(NSManagedObject *)schedule
{
    NSMutableArray *pictogramsInSchedule = [schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS];
    [pictogramsInSchedule removeObjectAtIndex:index];
    [schedule setValue:pictogramsInSchedule forKeyPath:CD_KEY_SCHEDULE_PICTOGRAMS];
}

/** Persists changes made to the managed object context.
 @throw NSException if the managed object context can not be saved.
 */
- (void)saveSchedule
{
    NSError *error;
    [self.dataSource.managedObjectContext save:&error];
    if (error) @throw [NSException exceptionWithName:@"Error saving deletion from schedule." reason:error.localizedFailureReason userInfo:nil];
}

#pragma mark -

@end
