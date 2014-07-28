#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramSelectorDataSource.h"

@implementation PictogramSelectorViewController

- (IBAction)pictogramLongPressed:(UILongPressGestureRecognizer * const)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)   [self handleItemSelection:sender];
    if (sender.state == UIGestureRecognizerStateEnded)   [self.delegate itemSelectionEndedAtLocation:[sender locationInView:self.view]];
    if (sender.state == UIGestureRecognizerStateChanged) [self.delegate itemMovedTo:[sender locationInView:self.view]];
}

- (void)handleItemSelection:(UILongPressGestureRecognizer * const)sender
{
    NSIndexPath * const indexPathOfSelectedItem = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
    NSManagedObject * const selectedItem = [self getItemAtIndexPath:indexPathOfSelectedItem];
    
    // self.view is the topmost view in this controllers view hierarchy.
    [self notifyDelegateOfItemSelectionWithObjectID:selectedItem.objectID atLocation:[sender locationInView:self.view]];
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
     [self.delegate selectedPictogramToAdd:objectID atLocation:location];
}

@end
