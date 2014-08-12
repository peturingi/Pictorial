#import "ScheduleCollectionViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramCalendarCell.h"
#import "RectHelper.h"
#import "NSArray+ObjectsOfType.h"
#import "Schedule.h"
#import "MasterViewController.h"
#import "UILongPressGestureRecognizer+Cancel.h"
#import "UICollectionView+CellAtPoint.h"
#import "DayCollectionViewLayout.h"

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
            [self.delegate pictogramBeingDraggedMovedToPoint:[sender locationInView:self.view] relativeToView:self.view];
            break;
            
        /* Gesture recognizer disabled while in use. */
        case UIGestureRecognizerStateCancelled:
            [self.delegate pictogramDraggingCancelled];
            break;
            
        /* Pictogram dropped. */
        case UIGestureRecognizerStateEnded:
            NSAssert(self.pictogramsSourceLocation, @"Must not be nil.");
            /* Two animations will be performed during a move. One on insert and one on delete. */
            [UICollectionView beginAnimations:nil context:nil];
            {
                if (NO == [self.delegate handleAddPictogramToScheduleAtPoint:[sender locationInView:self.view] relativeToView:self.view]) {
                    [UICollectionView commitAnimations];
                    self.pictogramsSourceLocation = nil;
                    return; // No need to continue after failed insertion, as we do not want to delete the source pictogram as it was not moved.
                }
                
                [self adjustPictogramsSourceLocation];
                [self removePictogramAtIndexPath:self.pictogramsSourceLocation];
            }
            [UICollectionView commitAnimations];
            self.pictogramsSourceLocation = nil;
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
        default:
            break;
    }
}

#pragma mark - Adjust Location

/**
 Take into count that a pictogram might have been moved up within its own schedule.
 The insertion of a pictogram higher up in the same schedule will invalidate the currently known
 source indexPath, resulting in internal inconsistency if for example the source was to be deleted during a move
 of the pictogram.
 */
- (void)adjustPictogramsSourceLocation {
    NSAssert(self.pictogramsSourceLocation, @"Unknown source location.");
    NSUInteger const offset = [self pictogramBeingMovedUpWithinSchedule] ? 1 : 0;
    NSIndexPath * const newLocation = [NSIndexPath indexPathForItem:(self.pictogramsSourceLocation.item + offset) inSection:self.pictogramsSourceLocation.section];
    self.pictogramsSourceLocation = newLocation;
}

/**
 Evaluates whether the currently dragged pictogram, was released in a higher location within the same schedule.
 @note A schedule represents a single day.
 @pre The source and destination locations are known.
 */
- (BOOL)pictogramBeingMovedUpWithinSchedule {
    NSAssert(self.pictogramsSourceLocation, @"Source has not been set.");
    NSAssert(self.pictogramsDestinationLocation, @"Destination has not been set.");
    BOOL const movedWithinSchedule = self.pictogramsDestinationLocation.section == self.pictogramsSourceLocation.section;
    BOOL const movedIntoHigherPosition = self.pictogramsDestinationLocation.item < self.pictogramsSourceLocation.item;
    return movedWithinSchedule && movedIntoHigherPosition;
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
        [self removePictogramAtIndexPath:pictogramToRemove];
    }
}

/** A section in the collection view represents a single schedule.
 @pre The specified section contains one schedule.
 */
- (NSManagedObject *)scheduleForSection:(NSUInteger)section
{
    id <NSFetchedResultsSectionInfo> const sectionContainingSchedule = self.dataSource.fetchedResultsController.sections[section];
    NSAssert([sectionContainingSchedule objects].count == 1, @"There should be a single schedule per section!");
    return [sectionContainingSchedule objects].firstObject;
}

/** Removes a pictogram from the schedule.
 @pre A pictogram exists in the schedule at the given index.
 */
- (void)removePictogramAtIndexPath:(NSIndexPath * const)path
{
    NSAssert(self.isEditing, @"Cannot remove pictogram unless editing.");
    Schedule * const schedule = (Schedule*)[self scheduleForSection:path.section]; // TODO caller should not cast
    NSAssert(schedule, @"Expected a schedule.");

    PictogramContainer * const container = [[schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS] objectAtIndex:path.item];
    NSAssert(container, @"Failed to get container.");
    [[self managedObjectContext] deleteObject:(NSManagedObject*)container];
    
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
    NSAssert(objectID, @"Expected objectID.");
    NSAssert(view, @"Expected a relative view.");
    NSAssert(self.isEditing, @"Cannot add a pictogram unless editing.");
    
    /*
     Algorithm:
     (0) if point is not within the collection view, abort.
     
     (1)
     If point is on a pictogram:
        If point is on an empty pictogram cell, add new pictogram above.
        If point is above vertical center of pictogram, add new pictogram above
        If point s below vertical center of pictogram, add new pictogram below
     (2)
     Else
        X := pictogram with largest interserction area, intersecting the released pictogram
        if X is not empty
            if point is above vertical center of x, add new pictogram above X
            if point is below vertical center of pictogram, add new pictogram below
     */
    
     CGPoint const releasePointInCollectionView = [self.collectionView convertPoint:point fromView:view];
    
    // (0) Abort if the pictogram was not dropped inside of this controllers collection view.
    if ([self.collectionView pointInside:releasePointInCollectionView withEvent:nil] == NO) {
        return NO;
    }
    
    // (1)
    // nil, if release was not on a pictogram
    NSIndexPath * const pathTocellAtReleasePoint = [self.collectionView indexPathForItemAtPoint:releasePointInCollectionView];
    
    NSManagedObject *destinationSchedule;
    
    /* Offset the final location by one if the pictogram was dropped on another pictogram, but below its vertical center. */
    if (pathTocellAtReleasePoint) {
        
        // Offset by one, if the touchup was below the center of another pictogram.
        CGPoint const centerOfCellAtReleasePoint = [self.collectionView cellForItemAtIndexPath:pathTocellAtReleasePoint].center;
        BOOL const touchedUpOverPictogram = [[[self.collectionView cellForItemAtIndexPath:pathTocellAtReleasePoint] class]isSubclassOfClass:[PictogramCalendarCell class]];
        NSInteger offset = (touchedUpOverPictogram && centerOfCellAtReleasePoint.y - releasePointInCollectionView.y < 0) ? 1 : 0;
        self.pictogramsDestinationLocation = [NSIndexPath indexPathForItem:(pathTocellAtReleasePoint.item + offset) inSection:pathTocellAtReleasePoint.section];
        
        destinationSchedule = [self scheduleForSection:pathTocellAtReleasePoint.section];
    }
    // (2) Touchup not over a cell but within the collectionview, base insertion on intersection area (if any).
    else {
        /* Get all CalendarCell from the collection view. */
        NSMutableArray * const calendarCells = [[NSMutableArray alloc] initWithArray:[self.collectionView.subviews objectsOfType:[CalendarCell class]]];
        
        /* Find all cells intersecting the dragged pictogram. */
        CGRect const draggedRect = CGRectMake(releasePointInCollectionView.x - PICTOGRAM_SIZE_WHILE_DRAGGING / 2, releasePointInCollectionView.y - PICTOGRAM_SIZE_WHILE_DRAGGING / 2, PICTOGRAM_SIZE_WHILE_DRAGGING, PICTOGRAM_SIZE_WHILE_DRAGGING);
        NSArray * const intersectingCells = [RectHelper viewsIn:calendarCells intersectingWithRect:draggedRect];
        
        /* If no cells are intersecting, then the pictogram is not to be added. Abort. */
        if (intersectingCells.count == 0) return NO;
        
        CGRect const largestIntersectingRect = [RectHelper largestIntersectionOf:intersectingCells and:draggedRect];
        NSAssert(largestIntersectingRect.size.height != 0 && largestIntersectingRect.size.width != 0, @"Invalid intersection.");
        
        /* Get the pictogram currently occupying the area containing the largest intersecting rect. */
        NSIndexPath * const pathToPictogramAtDestination = [self.collectionView indexPathForItemAtPoint:largestIntersectingRect.origin];
        NSAssert(pathToPictogramAtDestination, @"Must not be nil.");
        CGPoint const centerOfPictogramAtDestination = [self.collectionView cellForItemAtIndexPath:pathToPictogramAtDestination].center;
        
        /* Offset by one if below the center of another pictogram */
        UICollectionViewCell *targetCell = [self.collectionView cellForItemAtIndexPath:pathToPictogramAtDestination];
        BOOL targetIsPictogramCell = [targetCell isKindOfClass:[PictogramCalendarCell class]];
        NSInteger const offset = (targetIsPictogramCell && centerOfPictogramAtDestination.y - releasePointInCollectionView.y < 0) ? 1 : 0;
        self.pictogramsDestinationLocation = [NSIndexPath indexPathForItem:(pathToPictogramAtDestination.item + offset) inSection:pathToPictogramAtDestination.section];
        
        destinationSchedule = [self scheduleForSection:pathToPictogramAtDestination.section];
    }
    
    [self insertPictogramWithID:objectID inSchedule:destinationSchedule atIndexPath:self.pictogramsDestinationLocation];
    [self.dataSource save];
    
    return YES;
}

- (void)insertPictogramWithID:(NSManagedObjectID * const)objectID
                   inSchedule:(NSManagedObject * const)schedule
                  atIndexPath:(NSIndexPath * const)indexPath
{
    NSAssert(self.isEditing, @"Cannot insert pictogram unless editing.");
    NSManagedObject * const pictogramContainer = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer"
                                                                               inManagedObjectContext:self.managedObjectContext];
    NSAssert(pictogramContainer, @"Failed to create pictogram container.");
    [pictogramContainer setValue:[self.managedObjectContext objectWithID:objectID] forKey:@"pictogram"];
    [[schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS] insertObject:pictogramContainer atIndex:indexPath.item];
    [pictogramContainer setValue:schedule forKeyPath:@"schedule"];
    
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - Rearrange pictograms

/** Tells the delegate which item was touched, and its location.
 */
- (void)handlePictogramSelection:(UILongPressGestureRecognizer * const)sender
{
    UICollectionViewCell * const selectedCell = [self.collectionView cellAtPoint:[sender locationInView:self.collectionView]];
    
    if (selectedCell && [selectedCell isMemberOfClass:[PictogramCalendarCell class]]) {
        self.pictogramsSourceLocation = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
        NSManagedObject * const mostRecentlytouchedPictogram = [self.dataSource pictogramAtIndexPath:self.pictogramsSourceLocation];
        
        [self.delegate selectedPictogramToAdd:mostRecentlytouchedPictogram.objectID fromRect:[self.view convertRect:selectedCell.frame fromView:self.collectionView] atLocation:[sender locationInView:self.view] relativeTo:self.view];
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
    DayCollectionViewLayout *layout = [[DayCollectionViewLayout alloc] init];
    [self.collectionView setCollectionViewLayout:layout animated:YES];
    [self.collectionView reloadData];
}

- (void)switchToWeekLayout {
    NSLog(@"Not implemented.");
}

#pragma mark -

- (NSManagedObjectContext *)managedObjectContext {
    return self.dataSource.managedObjectContext;
}

@end
