#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramSelectorDataSource.h"

@implementation PictogramSelectorViewController

- (IBAction)pictogramLongPressed:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)   [self handleItemSelection:sender];
    if (sender.state == UIGestureRecognizerStateEnded)   [self.delegate itemSelectionEnded];
    if (sender.state == UIGestureRecognizerStateChanged) [self.delegate itemMovedTo:[sender locationInView:self.view]];
}

- (void)handleItemSelection:(UILongPressGestureRecognizer *)sender
{
    NSIndexPath *indexPathOfSelectedItem = [self.collectionView indexPathForItemAtPoint:[sender locationInView:sender.view]];
    const NSManagedObject *selectedItem = [self getItemAtIndexPath:indexPathOfSelectedItem];
    [self notifyDelegateOfItemSelectionWithObjectID:selectedItem.objectID atLocation:[sender locationInView:sender.view]];
}

/** Returns the touched item.
 */
- (NSManagedObject *)getItemAtIndexPath:(NSIndexPath *)indexPath
{
    const PictogramSelectorDataSource *dataSource = (PictogramSelectorDataSource *)self.collectionView.dataSource;
    return [[dataSource fetchedResultsController] objectAtIndexPath:indexPath];
}

/** Tells the delegate which item was touched, and its location.
 */
- (void)notifyDelegateOfItemSelectionWithObjectID:(NSManagedObjectID *)objectID atLocation:(CGPoint)location
{
     [self.delegate selectedPictogramToAdd:objectID atLocation:location];
}


@end
