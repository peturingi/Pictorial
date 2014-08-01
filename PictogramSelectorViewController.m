#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramSelectorDataSource.h"

@interface PictogramSelectorViewController ()
    @property (strong, nonatomic) NSManagedObjectID *mostRecentlytouchedPictogram;
@end

@implementation PictogramSelectorViewController

- (IBAction)pictogramLongPressed:(UILongPressGestureRecognizer * const)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)   [self handleItemSelection:sender];
    if (sender.state == UIGestureRecognizerStateEnded)   [self.delegate handleItemDropAt:[sender locationInView:self.view] relativeTo:self.view];
    if (sender.state == UIGestureRecognizerStateChanged) [self.delegate handleItemMovedTo:[sender locationInView:self.view] relativeTo:self.view];
}

- (void)handleItemSelection:(UILongPressGestureRecognizer * const)sender
{
    NSIndexPath * const indexPathToTouchedPictogram = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
    self.mostRecentlytouchedPictogram = [self getItemAtIndexPath:indexPathToTouchedPictogram].objectID;
    [self notifyDelegateOfItemSelectionWithObjectID:self.mostRecentlytouchedPictogram atLocation:[sender locationInView:self.view]];
}

/** Returns the touched item.
 */
- (NSManagedObject *)getItemAtIndexPath:(NSIndexPath * const)indexPath
{
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
