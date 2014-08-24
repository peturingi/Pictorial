#import "ScheduleCollectionViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramCalendarCell.h"
#import "RectHelper.h"
#import "NSArray+ObjectsOfType.h"
#import "MasterViewController.h"
#import "UILongPressGestureRecognizer+Cancel.h"
#import "UICollectionView+CellAtPoint.h"
#import "DayCollectionViewLayout.h"
#import "WeekCollectionViewLayout.h"
/* Models */
#import "Pictogram.h"
#import "PictogramContainer.h"
#import "Schedule.h"

@implementation ScheduleCollectionViewController

- (void)viewDidLoad {
    // Gestures should disabled as the application starts in non-edit mode.
    _movePictogramGestureRecognizer.enabled = self.isEditing;
}

- (IBAction)pictogramLongPressed:(UILongPressGestureRecognizer * const)sender
{
    switch (sender.state) {
        /* Initial touchdown on a pictogram. */
        case UIGestureRecognizerStateBegan:
            [self handlePictogramSelection:sender];
            break;
            
        /* Pictogram being dragged around. */
        case UIGestureRecognizerStateChanged:
            [self.cellDraggingManager pictogramDraggedToPoint:[sender locationInView:self.view] relativeToView:self.view];
            break;
            
        /* Gesture recognizer disabled while in use. */
        case UIGestureRecognizerStateCancelled:
            [self.cellDraggingManager pictogramDraggingCancelled];
            self.cellDraggingManager = nil;
            break;
            
        /* Pictogram dropped. */
        case UIGestureRecognizerStateEnded:
            [self movePictogram:sender];
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
        default:
            break;
    }
}

- (void)movePictogram:(UILongPressGestureRecognizer *)sender
{
    {
        NSAssert(self.cellDraggingManager, @"Must not be nil.");
    } // Assert
    
    /* Two animations will be performed during a move. One on insert and one on delete. */
    [UICollectionView beginAnimations:nil context:nil];
    {
        if (NO == [self.cellDraggingManager handleAddPictogramToScheduleAtPoint:[sender locationInView:self.view] relativeToView:self.view]) {
            [UICollectionView commitAnimations];
            self.cellDraggingManager = nil;
            return; // No need to continue after failed insertion, as we do not want to delete the source pictogram as it was not moved.
        }
        [self removePictogramAtIndexPath:[self.dataSource indexPathToPictogramContainer:self.touchedPictogramContainer inCollectionView:self.collectionView]];
    }
    [UICollectionView commitAnimations];
    self.cellDraggingManager = nil;
}

#pragma mark - Remove from Schedule

/** Called by UI remove button */
- (IBAction)removePictogramFromSchedule:(UIButton *)sender
{
    NSAssert(self.isEditing, @"Cannot remove pictogram unless editing.");
    NSAssert(sender, @"Sender was nil.");
    UICollectionViewCell * const sendersCell = (UICollectionViewCell *)sender.superview.superview;
    NSIndexPath * const pictogramToRemove = [self.collectionView indexPathForCell:sendersCell];
    if (pictogramToRemove) {
        {
            NSAssert(self.isEditing, @"Cannot remove pictogram unless editing.");
        } // Assert
        [self removePictogramAtIndexPath:pictogramToRemove];
    }
}

/** Removes a pictogram from the schedule.
 @pre A pictogram exists in the schedule at the given index.
 */
- (void)removePictogramAtIndexPath:(NSIndexPath * const)path
{
    Schedule * const schedule = [self.dataSource scheduleForSection:path.section];
    {
        NSAssert(schedule, @"Expected a schedule.");
        NSAssert(self.isEditing, @"Cannot remove pictogram unless editing.");
    } // Assert
    [schedule removePictogramAtIndexPath:path];
    [self.dataSource save];
    [self.collectionView deleteItemsAtIndexPaths:@[path]];
}

#pragma mark - Add pictogram to schedule

/**
 @return YES Pictogram was added.
 @return NO Pictogram was not added as it was dropped outside or far away from any cell.
 */
- (BOOL)addPictogramWithID:(NSManagedObjectID *const)objectID
                   atPoint:(const CGPoint)point
            relativeToView:(UIView *)view
{
    {
        NSAssert(objectID, @"Expected objectID.");
        NSAssert(view, @"Expected a relative view.");
        NSAssert(self.isEditing, @"Cannot add a pictogram unless editing.");
    } // Assert
    CGPoint const releasePointInCollectionView = [self.collectionView convertPoint:point fromView:view];
    
    // Abort if the pictogram was not dropped inside of this controllers collection view.
    if ([self.collectionView pointInside:releasePointInCollectionView withEvent:nil] == NO) {
        return NO;
    }
    else { // Was released in this controllers collection view.
        
        /* Offset the final location by one if the pictogram was dropped on another pictogram, but below its vertical center. */
        // Get all CalendarCell from the collection view.
        NSMutableArray * const calendarCells = [[NSMutableArray alloc] initWithArray:[self.collectionView.subviews objectsOfType:[CalendarCell class]]];
        
        // Find all cells intersecting the dragged pictogram.
        CGRect const draggedRect = CGRectMake(releasePointInCollectionView.x - PICTOGRAM_SIZE_WHILE_DRAGGING / 2, releasePointInCollectionView.y - PICTOGRAM_SIZE_WHILE_DRAGGING / 2, PICTOGRAM_SIZE_WHILE_DRAGGING, PICTOGRAM_SIZE_WHILE_DRAGGING);
        NSArray * const intersectingCells = [RectHelper viewsIn:calendarCells intersectingWithRect:draggedRect];
        
        // If no cells are intersecting, then the pictogram is not to be added. Abort.
        if (intersectingCells.count == 0) return NO;
        
        CGRect const largestIntersectingRect = [RectHelper largestIntersectionOfViews:intersectingCells andRect:draggedRect];
        {
            NSAssert(largestIntersectingRect.size.height != 0 && largestIntersectingRect.size.width != 0, @"Invalid intersection.");
        } // Assert
        
        /* Get the pictogram currently occupying the area containing the largest intersecting rect. */
        NSIndexPath * const pathToPictogramAtDestination = [self.collectionView indexPathForItemAtPoint:largestIntersectingRect.origin];
        {
            NSAssert(pathToPictogramAtDestination, @"Must not be nil.");
        } // Assert
        CGPoint const centerOfPictogramAtDestination = [self.collectionView cellForItemAtIndexPath:pathToPictogramAtDestination].center;
        
        /* Offset by one if below the center of another pictogram */
        UICollectionViewCell *targetCell = [self.collectionView cellForItemAtIndexPath:pathToPictogramAtDestination];
        BOOL targetIsPictogramCell = [targetCell isKindOfClass:[PictogramCalendarCell class]];
        NSInteger const offset = (targetIsPictogramCell && centerOfPictogramAtDestination.y - releasePointInCollectionView.y < 0) ? 1 : 0;
        self.pictogramsDestinationLocation = [NSIndexPath indexPathForItem:(pathToPictogramAtDestination.item + offset) inSection:pathToPictogramAtDestination.section];
        
        /* Insert pictogram and save. */
        Schedule * const schedule = [self.dataSource scheduleForSection:pathToPictogramAtDestination.section];
        [schedule insertPictogramWithID:objectID atIndexPath:self.pictogramsDestinationLocation];
        [self.collectionView insertItemsAtIndexPaths:@[self.pictogramsDestinationLocation]];
        [self.dataSource save];
        
        return YES;
    }
}

#pragma mark - Rearrange pictograms

/** Tells the delegate which item was touched, and its location.
 */
- (void)handlePictogramSelection:(UILongPressGestureRecognizer * const)sender
{
    CGPoint const gestureLocation = [sender locationInView:self.collectionView];
    UICollectionViewCell * const selectedCell = [self.collectionView cellAtPoint:gestureLocation];
    
    if (selectedCell && [selectedCell isMemberOfClass:[PictogramCalendarCell class]])
    {
        NSIndexPath * const touchedItem = [self.collectionView indexPathForItemAtPoint:gestureLocation];
        self.touchedPictogramContainer = [self.dataSource pictogramContainerAtIndexPath:touchedItem];
        
        self.cellDraggingManager = [[CellDraggingManager alloc] initWithSource:self andDestination:self];
        self.cellDraggingManager.locationRestriction = self.view.frame;
        [self.cellDraggingManager setPictogramToDrag:self.touchedPictogramContainer.pictogram.objectID
                                            fromRect:[self.view convertRect:selectedCell.frame fromView:self.collectionView]
                                          atLocation:[sender locationInView:self.view]
                                          relativeTo:self.view];
    } else {
        [sender cancel];
    }
}

#pragma mark - Toggle Edit Mode

- (void)setEditing:(BOOL)editing {
    [self setPictogramCellsRemovable:editing];
    [self showEmptyCells:editing];
    _movePictogramGestureRecognizer.enabled = editing; //Triggers cancelled state.
    [super setEditing:editing];
}

- (void)setPictogramCellsRemovable:(BOOL const)removable {
    for (CalendarCell *cell in self.collectionView.visibleCells) {
        if ([cell isKindOfClass:[PictogramCalendarCell class]]) {
            ((PictogramCalendarCell *)cell).deleteButton.alpha = (removable) ? 1.0f : 0.0f;
            ((PictogramCalendarCell *)cell).deleteButton.enabled = removable;
        }
    }
}

/**
 Show/Hide empty boxes in collection view.
 The boxes are used as an indication of where to place new pictograms.
 */
- (void)showEmptyCells:(BOOL const)value {
    self.dataSource.editing = value;
    [self.collectionView reloadData];
}

#pragma mark - Switching Layouts

- (void)switchToDayLayout {
    DayCollectionViewLayout *layout = [[DayCollectionViewLayout alloc] initWithCoder:nil];
    [self.collectionView setCollectionViewLayout:layout animated:NO];
    [self.collectionView reloadData];
}

- (void)switchToWeekLayout {
    WeekCollectionViewLayout *layout = [[WeekCollectionViewLayout alloc] initWithCoder:nil];
    [self.collectionView setCollectionViewLayout:layout animated:NO];
    [self.collectionView reloadData];
}

#pragma mark -

@end
