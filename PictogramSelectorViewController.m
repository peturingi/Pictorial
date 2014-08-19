#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramSelectorDataSource.h"
#import "UICollectionView+CellAtPoint.h"
#import "UILongPressGestureRecognizer+Cancel.h"
#import "UIView+BBASubviews.h"

@implementation PictogramSelectorViewController

- (IBAction)pictogramLongPressed:(UILongPressGestureRecognizer * const)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            if (self.cellDraggingManager == NO) {
                self.cellDraggingManager = [[CellDraggingManager alloc] initWithSource:self andDestination:self.delegate.targetForPictogramDrops];
            }
            [self handlePictogramSelection:sender];
            break;
            
        case UIGestureRecognizerStateCancelled:
        [self.cellDraggingManager pictogramDraggingCancelled];
            break;
        
        case UIGestureRecognizerStateChanged:
            // TODO: if current position is near the edge of the collection view, start scrolling the collectionview.
            [self.cellDraggingManager pictogramDraggedToPoint:[sender locationInView:self.view] relativeToView:self.view];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self.cellDraggingManager handleAddPictogramToScheduleAtPoint:[sender locationInView:self.view] relativeToView:self.view];
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
        default:
            break;
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
        
        [self.cellDraggingManager setPictogramToDrag:mostRecentlytouchedPictogram
                                     fromRect:[self.view convertRect:imageView.frame fromView:imageView]
                                   atLocation:[sender locationInView:self.view] relativeTo:self.view];
    } else {
        [sender cancel];
    }
}

@end
