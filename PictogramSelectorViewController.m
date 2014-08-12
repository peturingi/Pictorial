#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramSelectorDataSource.h"
#import "UICollectionView+CellAtPoint.h"
#import "UILongPressGestureRecognizer+Cancel.h"

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

/** Tells the delegate which item was touched, and its location.
 */
- (void)handlePictogramSelection:(UILongPressGestureRecognizer * const)sender
{
    UICollectionViewCell * const selectedCell = [self.collectionView cellAtPoint:[sender locationInView:self.collectionView]];
    
    if (selectedCell && [selectedCell isKindOfClass:[UICollectionViewCell class]]) {
        NSIndexPath * const indexPathToTouchedPictogram = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
        self.mostRecentlytouchedPictogram = [(PictogramSelectorDataSource *)self.collectionView.dataSource pictogramAtIndexPath:indexPathToTouchedPictogram].objectID;
        
        [self.delegate selectedPictogramToAdd:self.mostRecentlytouchedPictogram fromRect:[self.view convertRect:selectedCell.frame fromView:self.collectionView] atLocation:[sender locationInView:self.view] relativeTo:self.view];
    } else {
        [sender cancel];
    }
}

@end
