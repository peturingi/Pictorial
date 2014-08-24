#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramSelectorDataSource.h"
#import "UICollectionView+CellAtPoint.h"
#import "UILongPressGestureRecognizer+Cancel.h"
#import "UIView+BBASubviews.h"
#import "BottomViewPictogram.h"
#import "Pictogram.h"

@implementation PictogramSelectorViewController

- (IBAction)pictogramTapped:(UITapGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateEnded:
        {
            [self handleTapOnCellAtLocation:[sender locationInView:self.collectionView]];
            break;
        }
        
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
        default:
            break;
    }
}

- (void)handleTapOnCellAtLocation:(CGPoint const)point {
    BottomViewPictogram *cell = [self.collectionView cellAtPoint:point];
    if (cell) {
        [self.collectionView scrollToItemAtIndexPath:[self.collectionView indexPathForCell:cell] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        cell.highlighted = !cell.highlighted;
        [cell showControls:cell.highlighted];
    }
}

- (IBAction)modifyButton:(UIButton *)sender {
    NSLog(@"modify");
}
- (IBAction)deleteButton:(UIButton *)sender {
    BottomViewPictogram * const cell = (BottomViewPictogram *)sender.superview.superview;
    NSIndexPath * const pathToCell = [self.collectionView indexPathForCell:cell];
    Pictogram * const pictogramInCell = [(PictogramSelectorDataSource*)self.collectionView.dataSource pictogramAtIndexPath:pathToCell];
    {
        NSAssert(cell, @"Could not get view owning the delete button.");
        NSAssert(pathToCell, @"Coult not get path to cell owning the delete button.");
        NSAssert(pictogramInCell, @"Could not find the pictogram.");
    } // Assert
    
    /* Show alert box if pictogram is in use, else delete it. */
    if (pictogramInCell.inUse) {
        {
            NSString * const title = @"Can Not Delete";
            NSString * const message = @"Pictogram is being used by a schedule. Remove it from the schedule and try again.";
            NSString * const ok = @"Ok";
            [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:ok otherButtonTitles:nil] show];
        }
        cell.highlighted = NO;
    }
    else {
        {
            NSManagedObjectContext * const moc = pictogramInCell.managedObjectContext;
            [moc deleteObject:pictogramInCell];
            [moc save:nil]; // TODO: error handling
        }
        [self.collectionView deleteItemsAtIndexPaths:@[pathToCell]];
    }
}

- (IBAction)pictogramLongPressed:(UILongPressGestureRecognizer * const)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            if ( ! self.cellDraggingManager ) {
                self.cellDraggingManager = [[CellDraggingManager alloc] initWithSource:self andDestination:self.delegate.targetForPictogramDrops];
            }
            [self handlePictogramSelection:sender];
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        [self.cellDraggingManager pictogramDraggingCancelled];
            break;
        
        case UIGestureRecognizerStateChanged:
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

- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    
    /* Cancel dragging if editing was turned off,
     in order to prevent a crash which occurs if the pictogram
     is released after the pictogram window has disappeared. */
    if (editing == NO) [self.pictogramDragger cancel];
}

@end
