#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramSelectorDataSource.h"

@interface PictogramSelectorViewController ()
    @property (strong, nonatomic) NSManagedObjectID *mostRecentlytouchedPictogram;
@end

@implementation PictogramSelectorViewController

- (IBAction)pictogramLongPressed:(UILongPressGestureRecognizer * const)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)   [self handlePictogramSelection:sender];
    if (sender.state == UIGestureRecognizerStateChanged) [self.delegate pictogramBeingDraggedMovedToPoint:[sender locationInView:self.view] relativeToView:self.view];
    if (sender.state == UIGestureRecognizerStateEnded)   [self.delegate handleAddPictogramToScheduleAtPoint:[sender locationInView:self.view] relativeToView:self.view];
    
    if (sender.state == UIGestureRecognizerStateCancelled) {
        // TODO deal with the cancelation
    }
}

- (void)handlePictogramSelection:(UILongPressGestureRecognizer * const)sender
{
    NSIndexPath * const indexPathToTouchedPictogram = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
    self.mostRecentlytouchedPictogram = [self getPictogramAtIndexPath:indexPathToTouchedPictogram].objectID;
    [self notifyDelegateOfItemSelectionWithObjectID:self.mostRecentlytouchedPictogram atLocation:[sender locationInView:self.view]];
}

/** Returns the touched pictogram.
 */
- (NSManagedObject *)getPictogramAtIndexPath:(NSIndexPath * const)indexPath
{
    NSAssert(indexPath, @"Must not be nil.");
    PictogramSelectorDataSource * const dataSource = (PictogramSelectorDataSource *)self.collectionView.dataSource;
    return [[dataSource fetchedResultsController] objectAtIndexPath:indexPath];
}

/** Tells the delegate which item was touched, and its location.
 */
- (void)notifyDelegateOfItemSelectionWithObjectID:(NSManagedObjectID * const)objectID atLocation:(CGPoint const)location
{
     [self.delegate selectedPictogramToAdd:objectID atLocation:location relativeTo:self.view];
}

@end
