#import "ScheduleCollectionViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramCalendarCell.h"
#import "RectHelper.h"
#import "NSArray+ObjectsOfType.h"
#import "Schedule.h"

#import "MasterViewController.h"

@interface ScheduleCollectionViewController ()
@property (strong, nonatomic) NSManagedObjectID *mostRecentlytouchedPictogram;
@property (strong, nonatomic) NSIndexPath *pictogramBeingMoved;
@end

@implementation ScheduleCollectionViewController

#pragma mark -


- (void)viewDidLoad {
    // Gestures should disabled as the application starts in non-edit mode.
    _movePictogramGestureRecognizer.enabled = self.isEditing;
}

- (IBAction)pictogramLongPressed:(UILongPressGestureRecognizer * const)sender
{
    /* Initial touch down on a pictogram to be moved. */
    if (sender.state == UIGestureRecognizerStateBegan) {
        LOG_METHOD
        NSLog(@"State began"); // DEBUG
        [self handlePictogramSelection:sender];
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        [self.delegate pictogramBeingDraggedMovedToPoint:[sender locationInView:self.view] relativeToView:self.view];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSAssert(self.pictogramBeingMoved, @"Must not be nil.");
        LOG_METHOD
        NSLog(@"State ended"); // DEBUG
        
        /* Two animations will be performed during a move. One on insert and one on delete.
         Unless they are grouped, the UI might in some cases not end up in a consistent state. */
        [UICollectionView beginAnimations:nil context:nil];
        {
            NSLog(@"Inside animation"); // DEBUG
            if (NO == [self.delegate handleAddPictogramToScheduleAtPoint:[sender locationInView:self.view] relativeToView:self.view]) {
                [UICollectionView commitAnimations];
                LOG_METHOD
                NSLog(@"Aborting...");
                self.pictogramBeingMoved = nil;
                return; // No need to continue after failed insertion, as we do not want to delete the source pictogram as it was not moved.
            }
            
            /* If the pictogram is being moved higher up in its schedule
             its original position will be assigned a new indexPath. An
             offset of one on indexPath.item will counter it. */
            CGPoint const touchUp = [sender locationInView:sender.view]; // dead code
            NSIndexPath * const destination = [self.collectionView indexPathForItemAtPoint:[sender locationInView:sender.view]];
            NSLog(@"Destination used to calculate offset: %@", destination); // DEBUG
            BOOL const movingWithinASchedule = self.pictogramBeingMoved.section == destination.section;
            BOOL const movingUp = self.pictogramBeingMoved.item > destination.item;
            NSUInteger const offset = (movingWithinASchedule && movingUp) ? 1 : 0;
            NSLog(@"Offset: %ld", offset); // DEBUG
            
            NSIndexPath *toBeRemoved = [NSIndexPath indexPathForItem:(self.pictogramBeingMoved.item + offset) inSection:self.pictogramBeingMoved.section];
            NSLog(@"toBeRemoved: %@", toBeRemoved); // DEBUG
            [self removePictogramAtIndexPath:toBeRemoved];
            LOG_METHOD
        }
        [UICollectionView commitAnimations];
        
        self.pictogramBeingMoved = nil;
    }
    
    /* The gesture recognizer disabled while it was in use. */
    if (sender.state == UIGestureRecognizerStateCancelled) {
        [self.delegate pictogramDraggingCancelled];
    }
}

#pragma mark - Remove pictogram from schedule

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
    LOG_METHOD
    NSLog(@"section: %ld", section); // DEBUG
    id <NSFetchedResultsSectionInfo> const sectionContainingSchedule = self.dataSource.fetchedResultsController.sections[section];
    NSAssert([sectionContainingSchedule objects].count == 1, @"There should be a single schedule per section!");
    NSLog(@"%@", [sectionContainingSchedule objects].firstObject); // DEBUG
    return [sectionContainingSchedule objects].firstObject;
}

/** Removes a pictogram from the schedule.
 @pre A pictogram exists in the schedule at the given index.
 */
- (void)removePictogramAtIndexPath:(NSIndexPath * const)path
{
    LOG_METHOD // DEBUG
    NSLog(@"path to pictogram to remove: %@", path); // DEBUG
    NSAssert(self.isEditing, @"Cannot remove pictogram unless editing.");
    Schedule * const schedule = (Schedule*)[self scheduleForSection:path.section]; // TODO caller should not cast
    NSAssert(schedule, @"Expected a schedule.");

    PictogramContainer * const container = [[schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS] objectAtIndex:path.item];
    NSAssert(container, @"Failed to get container.");
    NSLog(@"Container to be deleted: %@", container); // DEBUG
    [[self managedObjectContext] deleteObject:(NSManagedObject*)container];
    
    [self.dataSource save];
    [self.collectionView deleteItemsAtIndexPaths:@[path]];
}

#pragma mark -
#pragma  mark Add pictogram to schedule

- (BOOL)addPictogramWithID:(NSManagedObjectID *const)objectID
                   atPoint:(const CGPoint)point
            relativeToView:(UIView *)view
{
    NSAssert(objectID, @"Expected objectID.");
    NSAssert(view, @"Expected a relative view.");
    NSAssert(self.isEditing, @"Cannot add a pictogram unless editing.");
    
    LOG_METHOD // DEBUG
    NSLog(@"ObjectID: %@", objectID); // DEBUG
    NSLog(@"point: (%f,%f)", point.x, point.y); // DEBUG
    NSLog(@"relative view: %@", view); // DEBUG
    
    CGPoint const relativeDropPoint = [self.collectionView convertPoint:point fromView:view];
    NSLog(@"relative drop point: (%f,%f)", relativeDropPoint.x, relativeDropPoint.y); // DEBUG
    
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
    
    // (0)
    // Abort if the pictogram was not dropped on the collection view.
    if (NO == [self.collectionView pointInside:relativeDropPoint withEvent:nil]) {
        NSLog(@"Point not inside collection view. Aborting."); // DEBUG
        return NO;
    }
    NSLog(@"Point inside collection view."); // DEBUG
    
    // (1)
    // nil, if release was not on a pictogram
    NSIndexPath * const pictogramAtTouchUpLocation = [self.collectionView indexPathForItemAtPoint:relativeDropPoint];
    NSLog(@"Pictogram at touchup Location %@", pictogramAtTouchUpLocation); // DEBUG
    BOOL const touchedUpOverPictogram = [[[self.collectionView cellForItemAtIndexPath:pictogramAtTouchUpLocation] class]isSubclassOfClass:[PictogramCalendarCell class]];
    NSLog(@"Touchedup over pictogram: %d", touchedUpOverPictogram); // DEBUG
    
    NSManagedObject *targetSchedule;
    NSIndexPath *destination;
    /* Offset the final location by one if the pictogram was dropped on another pictogram, but below its vertical center. */
    if (pictogramAtTouchUpLocation) {
        CGPoint const centerOfCellAtDropLocation = [self.collectionView cellForItemAtIndexPath:pictogramAtTouchUpLocation].center;
        NSLog(@"Center of cell at drop location: (%f,%f)", centerOfCellAtDropLocation.x, centerOfCellAtDropLocation.y); // DEBUG
        // Offset by one, if the touchup was below the center of another pictogram.
        NSInteger offset = (centerOfCellAtDropLocation.y - relativeDropPoint.y < 0 && touchedUpOverPictogram) ? 1 : 0;
        NSLog(@"offset: %ld", (long)offset); // DEBUG
        destination = [NSIndexPath indexPathForItem:(pictogramAtTouchUpLocation.item + offset) inSection:pictogramAtTouchUpLocation.section];
        NSLog(@"destination: %@", destination); // DEBUG
        
        targetSchedule = [self scheduleForSection:pictogramAtTouchUpLocation.section];
        LOG_METHOD // DEBUG
        NSLog(@"targetSchedule: %@", targetSchedule);
    }
    // (2) Touchup not over pictogram, base insertion on intersection area (if any).
    else {
        NSLog(@"Touchuedup not over pictogram, calculate intersection area..."); // DEBUG
        /* Get all CalendarCell from the collection view. */
        NSMutableArray * const calendarCells = [[NSMutableArray alloc] initWithArray:[self.collectionView.subviews objectsOfType:[CalendarCell class]]];
        
        /* Find all cells intersecting the dragged pictogram. */
        CGRect const draggedRect = CGRectMake(relativeDropPoint.x - PICTOGRAM_SIZE_WHILE_DRAGGING / 2, relativeDropPoint.y - PICTOGRAM_SIZE_WHILE_DRAGGING / 2,
                                        PICTOGRAM_SIZE_WHILE_DRAGGING, PICTOGRAM_SIZE_WHILE_DRAGGING);
        NSArray * const intersectingCells = [RectHelper viewsIn:calendarCells intersectingWithRect:draggedRect];
        
        /* If no cells are intersecting, then the pictogram was dropped in an invalid location. Abort. */
        if (intersectingCells.count == 0) return NO;
        
        NSLog(@"Intersecting cells: %@", intersectingCells); // DEBUG
        CGRect const largestIntersectingRect = [RectHelper largestIntersectionOf:intersectingCells and:draggedRect];
        NSLog(@"Largest intersecting rect: x:%f y:%f height:%f width:%f", largestIntersectingRect.origin.x, largestIntersectingRect.origin.y, largestIntersectingRect.size.height, largestIntersectingRect.size.width); // DEBUG
        /* Get the pictogram currently occupying the area containing the largest intersecting rect. */
        NSIndexPath * const pathToPictogramAtDestination = [self.collectionView indexPathForItemAtPoint:largestIntersectingRect.origin];
        NSLog(@"PathToPictogramAtDestination: %@", pathToPictogramAtDestination); // DEBUG
        
        CGPoint const centerOfPictogramAtDestination = [self.collectionView cellForItemAtIndexPath:pathToPictogramAtDestination].center;
        NSLog(@"Center of pictogram at desitnation: (%f,%f)", centerOfPictogramAtDestination.x, centerOfPictogramAtDestination.y); // DEBUG
        /* Offset by one if below the center */
        NSInteger const offset = (centerOfPictogramAtDestination.y - relativeDropPoint.y < 0 && touchedUpOverPictogram) ? 1 : 0;
        NSLog(@"Offset: %ld", (long)offset); // DEBUG
        destination = [NSIndexPath indexPathForItem:(pathToPictogramAtDestination.item + offset) inSection:pathToPictogramAtDestination.section];
        NSLog(@"destination: %@", destination); // DEBUG
        
        targetSchedule = [self scheduleForSection:pathToPictogramAtDestination.section];
        LOG_METHOD
        NSLog(@"targetSchedule: %@", targetSchedule); // DEBUG
    }
    
    [self insertPictogramWithID:objectID inSchedule:targetSchedule atIndexPath:destination];
    
    if (NO == [self.dataSource.managedObjectContext save:nil]) return NO;
    else return YES;
}

- (void)insertPictogramWithID:(NSManagedObjectID * const)objectID
                   inSchedule:(NSManagedObject * const)schedule
                  atIndexPath:(NSIndexPath * const)indexPath
{
    NSAssert(self.isEditing, @"Cannot insert pictogram unless editing.");
    NSManagedObject * const pictogramContainer = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer"
                                                                               inManagedObjectContext:self.managedObjectContext];
    [pictogramContainer setValue:[self.managedObjectContext objectWithID:objectID] forKey:@"pictogram"];
    [[schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS] insertObject:pictogramContainer atIndex:indexPath.item];
    [pictogramContainer setValue:schedule forKeyPath:@"schedule"];
    
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

#pragma mark -

- (NSManagedObjectContext *)managedObjectContext {
    return self.dataSource.managedObjectContext;
}

#pragma mark - Rearrange pictograms

- (void)handlePictogramSelection:(UILongPressGestureRecognizer * const)sender
{
    LOG_METHOD // DEBUG
    // TODO move next two lines into category of UICollectionViewCell
    NSIndexPath * const pathToSelectedCell = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
    NSLog(@"path to selected cell: %@", pathToSelectedCell); // DEBUG
    UICollectionViewCell * const selectedCell = (CalendarCell *)[self.collectionView cellForItemAtIndexPath:pathToSelectedCell];
    
    BOOL debugIsmember = [selectedCell isMemberOfClass:[PictogramCalendarCell class]]; // DEBUG
    NSLog(@"Is member of PictogramCalendarCell: %d", debugIsmember); // DEBUG
    if ([selectedCell isMemberOfClass:[PictogramCalendarCell class]]) {
        NSLog(@"inside about to notify Delegate of item selection"); // DEBUG
        self.pictogramBeingMoved = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
        self.mostRecentlytouchedPictogram = [self.dataSource pictogramAtIndexPath:self.pictogramBeingMoved].objectID;
        NSLog(@"self.pictogramBeingMoved: %@", self.pictogramBeingMoved); // DEBUG
        NSLog(@"most recently touched pictogram: %@", self.mostRecentlytouchedPictogram); // DEBUG
        [self notifyDelegateOfItemSelectionWithObjectID:self.mostRecentlytouchedPictogram atLocation:[sender locationInView:self.view]];
    } else {
        NSLog(@"About to cancel gesture recognizer."); // DEBUG
        /* Cancels the gesture recognizer */
        sender.enabled = NO;
        sender.enabled = YES;
    }
}

/** Tells the delegate which item was touched, and its location.
 */
- (void)notifyDelegateOfItemSelectionWithObjectID:(NSManagedObjectID * const)objectID atLocation:(CGPoint const)location {
    [self.delegate selectedPictogramToAdd:objectID atLocation:location relativeTo:self.view];
}

- (void)setEditing:(BOOL)editing {
    
    // Set cells removable.
    for (CalendarCell *cell in self.collectionView.visibleCells) {
        if ([cell isKindOfClass:[PictogramCalendarCell class]]) {
            ((PictogramCalendarCell *)cell).deleteButton.alpha = (editing) ? 1.0f : 0.0f;
            ((PictogramCalendarCell *)cell).deleteButton.enabled = editing;
        }
    }
    
    /* Show/Hide empty boxes in collection view. */
    self.dataSource.editing = editing;
    [self.collectionView reloadData];
    
    _movePictogramGestureRecognizer.enabled = editing; // Moves to cancelled state if currently in use.

    [super setEditing:editing];
}

@end
