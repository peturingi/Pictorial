#import "ScheduleCollectionViewController.h"
#import <CoreData/CoreData.h>
#import "CalendarCell.h"
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
    if (sender.state == UIGestureRecognizerStateBegan) [self handlePictogramSelection:sender];
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        [self.delegate pictogramBeingDraggedMovedToPoint:[sender locationInView:self.view] relativeToView:self.view];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSAssert(self.pictogramBeingMoved, @"Must not be nil.");
        /* Two animations will be performed during a move. One on insert and one on delete.
         Unless they are grouped, the UI might in some cases not end up in a consistent state. */
        [UICollectionView beginAnimations:nil context:nil];
        {
            if (NO == [self.delegate handleAddPictogramToScheduleAtPoint:[sender locationInView:self.view] relativeToView:self.view]) return;
            
            /* If the pictogram is being moved higher up in its schedule
             its original position will be assigned a new indexPath. An
             offset of one on indexPath.item will counter it. */
            NSIndexPath * const destination = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.view]];
            NSUInteger const offset = (self.pictogramBeingMoved.section == destination.section && self.pictogramBeingMoved.item >= destination.item) ? 1 : 0;
            [self removePictogramAtIndexPath:[NSIndexPath indexPathForItem:(self.pictogramBeingMoved.item + offset) inSection:self.pictogramBeingMoved.section]];
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

    //[schedule removePictogramsAtIndexes:[NSIndexSet indexSetWithIndex:path.item]];
    PictogramContainer * const container = [[schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS] objectAtIndex:path.item];
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
    
    CGPoint const relativeDropPoint = [self.collectionView convertPoint:point fromView:view];
    
    /*
     Algorithm:
     (0) if point is not within the collection view, abort.
     
     (1)
     If point is on a pictogram:
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
    if (NO == [self.collectionView pointInside:relativeDropPoint withEvent:nil]) return NO;
    
    // (1)
    // nil, if release was not on a pictogram
    NSIndexPath * const pictogramAtDropPoint = [self.collectionView indexPathForItemAtPoint:relativeDropPoint];
    
    NSManagedObject *targetSchedule;
    NSIndexPath *destination;
    /* Offset the final location by one if the pictogram was dropped on a target, but below its vertical center. */
    if (pictogramAtDropPoint) {
        
        // Offset by one if below center
        CGPoint const centerOfCellAtDropLocation = [self.collectionView cellForItemAtIndexPath:pictogramAtDropPoint].center;
        NSInteger offset = (centerOfCellAtDropLocation.y - relativeDropPoint.y < 0) ? 1 : 0;
        destination = [NSIndexPath indexPathForItem:(pictogramAtDropPoint.item + offset) inSection:pictogramAtDropPoint.section];
        
        targetSchedule = [self scheduleForSection:pictogramAtDropPoint.section];
        
    }
    // (2)
    else {
        /* Get all CalendarCell from the collection view. */
        NSMutableArray * const calendarCells = [[NSMutableArray alloc] initWithArray:[self.collectionView.subviews objectsOfType:[CalendarCell class]]];
        
        /* Find all cells intersecting the dragged pictogram. */
        CGRect const draggedRect = CGRectMake(relativeDropPoint.x - PICTOGRAM_SIZE_WHILE_DRAGGING / 2,
                                        relativeDropPoint.y - PICTOGRAM_SIZE_WHILE_DRAGGING / 2,
                                        PICTOGRAM_SIZE_WHILE_DRAGGING,
                                        PICTOGRAM_SIZE_WHILE_DRAGGING);
        //NSArray * const intersectingCells = [self collectionViewCellsIn:calendarCells intersecting:draggedRect];
        NSArray * const intersectingCells = [RectHelper viewsIn:calendarCells intersectingWithRect:draggedRect];
        CGRect const largestIntersectingRect = [RectHelper largestIntersectionOf:intersectingCells and:draggedRect];
        
        /* Get the pictogram currently occupying the area containing the largest intersecting rect. */
        NSIndexPath * const pathToPictogramAtDestination = [self.collectionView indexPathForItemAtPoint:largestIntersectingRect.origin];
        
        /* Offset by one if below the center */
        CGPoint const centerOfPictogramAtDestination = [self.collectionView cellForItemAtIndexPath:pathToPictogramAtDestination].center;
        NSInteger const offset = (centerOfPictogramAtDestination.y - relativeDropPoint.y < 0) ? 1 : 0;
        destination = [NSIndexPath indexPathForItem:(pathToPictogramAtDestination.item + offset) inSection:pathToPictogramAtDestination.section];
        
        targetSchedule = [self scheduleForSection:pathToPictogramAtDestination.section];
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
    self.pictogramBeingMoved = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
    self.mostRecentlytouchedPictogram = [self.dataSource pictogramAtIndexPath:self.pictogramBeingMoved].objectID;
    [self notifyDelegateOfItemSelectionWithObjectID:self.mostRecentlytouchedPictogram atLocation:[sender locationInView:self.view]];
}

/** Tells the delegate which item was touched, and its location.
 */
- (void)notifyDelegateOfItemSelectionWithObjectID:(NSManagedObjectID * const)objectID atLocation:(CGPoint const)location {
    [self.delegate selectedPictogramToAdd:objectID atLocation:location relativeTo:self.view];
}

- (void)setEditing:(BOOL)editing {
    
    // Set cells removable.
    for (CalendarCell *cell in self.collectionView.visibleCells) {
        cell.deleteButton.alpha = (editing) ? 1.0f : 0.0f;
        cell.deleteButton.enabled = editing;
        self.dataSource.editing = editing;
    }
    
    _movePictogramGestureRecognizer.enabled = editing; // Moves to cancelled state if currently in use.

    [super setEditing:editing];
}

@end
