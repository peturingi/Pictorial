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
    [[schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS] removeObjectAtIndex:index];
}

/** Persists changes made to the managed object context.
 @throw NSException if the managed object context can not be saved.
 */
- (void)saveSchedule
{
    NSAssert(self.dataSource.managedObjectContext, @"The data source does not have a managed object context.");
    if ([self.dataSource.managedObjectContext hasChanges] == NO) return;
    
    NSError *error;
    if ([self.dataSource.managedObjectContext save:&error] == NO) {
        @throw [NSException exceptionWithName:@"Error saving deletion from schedule." reason:error.localizedFailureReason userInfo:nil];
    }
}

- (BOOL)addPictogramWithID:(NSManagedObjectID *const)objectID atPoint:(const CGPoint)point
{
    NSIndexPath * const target = [self.collectionView indexPathForItemAtPoint:point];
    if (target) {
        NSManagedObject * const targetSection = [self scheduleInSection:target.section];
        [self insertPictogramWithID:objectID inSchedule:targetSection atIndexPath:target];
    } else return NO;
    
    if (NO == [self.dataSource.managedObjectContext save:nil]) return NO;
    
    return YES;
}

- (void)insertPictogramWithID:(NSManagedObjectID * const)objectID inSchedule:(NSManagedObject * const)schedule atIndexPath:(NSIndexPath * const)indexPath {
    [[schedule valueForKeyPath:CD_KEY_SCHEDULE_PICTOGRAMS] insertObject:[self.dataSource.managedObjectContext objectWithID:objectID] atIndex:indexPath.item];
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

@end
