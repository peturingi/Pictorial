#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramSelectorDataSource.h"
#import "UICollectionView+CellAtPoint.h"
#import "UILongPressGestureRecognizer+Cancel.h"
#import "UIView+BBASubviews.h"

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
        NSManagedObjectID * const mostRecentlytouchedPictogram = [(PictogramSelectorDataSource *)self.collectionView.dataSource pictogramAtIndexPath:indexPathToTouchedPictogram].objectID;
        
        UIView * const imageView = [selectedCell.contentView firstSubviewWithTag:CELL_TAG_FOR_IMAGE_VIEW];
        {
            NSAssert(imageView, @"imageView not found.");
        } // Assert
        
        [self.delegate selectedPictogramToAdd:mostRecentlytouchedPictogram
                                     fromRect:[self.view convertRect:imageView.frame fromView:imageView]
                                   atLocation:[sender locationInView:self.view] relativeTo:self.view];
    } else {
        [sender cancel];
    }
}

@end
