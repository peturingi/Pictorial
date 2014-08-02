#import "ScheduleCollectionViewController.h"
#import <CoreData/CoreData.h>
#import "CalendarCell.h"

#import "MasterViewController.h"

@interface ScheduleCollectionViewController ()
@property (strong, nonatomic) NSManagedObjectID *mostRecentlytouchedPictogram;
@property (strong, nonatomic) NSIndexPath *pictogramBeingMoved;
@end

@implementation ScheduleCollectionViewController

#pragma mark -
#pragma mark Remove pictogram from schedule

- (IBAction)removePictogramFromSchedule:(UIButton *)sender
{
    UICollectionViewCell * const sendersCell = (UICollectionViewCell *)sender.superview.superview;
    NSIndexPath * const pictogramToRemove = [self.collectionView indexPathForCell:sendersCell];
    if (pictogramToRemove) {
        [self removePictogramAtIndexPath: pictogramToRemove];
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
    NSManagedObject * const schedule = [self scheduleForSection:path.section];
    NSAssert(schedule, @"Expected a schedule.");
    [[schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS] removeObjectAtIndex:path.item];
    [self saveSchedule];
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
    
    /*
     Algorithm:
     
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
    
    // (1)
    NSIndexPath *pictogramAtDropPoint = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:point fromView:view]]; // target := nil, if release was not on a pictogram
    NSManagedObject *targetSchedule;
    NSIndexPath *destination;
    /* Offset the final location by one if the pictogram was dropped on a target, but below its vertical center. */
    if (pictogramAtDropPoint) {
        
        // Offset by one if below center
        CGPoint const dropLocation = [self.collectionView convertPoint:point fromView:view];
        CGPoint const centerOfCellAtDropLocation = [self.collectionView cellForItemAtIndexPath:pictogramAtDropPoint].center;
        NSInteger offset = (centerOfCellAtDropLocation.y - dropLocation.y < 0) ? 1 : 0;
        destination = [NSIndexPath indexPathForItem:(pictogramAtDropPoint.item + offset) inSection:pictogramAtDropPoint.section];
        
        targetSchedule = [self scheduleForSection:pictogramAtDropPoint.section];
        
    }
    // (2)
    else {
        /* Get all CalendarCell from the collection view. */
        NSMutableArray * const calendarCells = [[NSMutableArray alloc] initWithCapacity:self.collectionView.subviews.count];
        for (CalendarCell *cell in self.collectionView.subviews ) {
            if ([cell isMemberOfClass:[CalendarCell class]]) [calendarCells addObject:cell];
        }
        /* Find all cells intersecting the dragged pictogram. */
        CGRect const draggedRect = CGRectMake([self.collectionView convertPoint:point fromView:view].x - PICTOGRAM_SIZE_WHILE_DRAGGING / 2,
                                        [self.collectionView convertPoint:point fromView:view].y - PICTOGRAM_SIZE_WHILE_DRAGGING / 2,
                                        PICTOGRAM_SIZE_WHILE_DRAGGING,
                                        PICTOGRAM_SIZE_WHILE_DRAGGING);
        NSArray * const intersectingCells = [self collectionViewCellsIn:calendarCells intersecting:draggedRect];
        CGRect const largestIntersectingRect = [self largestIntersectionOf:intersectingCells and:draggedRect];
        
        /* Get the pictogram currently occupying the area containing the largest intersecting rect. */
        NSIndexPath * const pathToPictogramAtDestination = [self.collectionView indexPathForItemAtPoint:largestIntersectingRect.origin];
        
        /* Offset by one if below the center */
        CGPoint const centerOfPictogramAtDestination = [self.collectionView cellForItemAtIndexPath:pathToPictogramAtDestination].center;
        NSInteger const offset = (centerOfPictogramAtDestination.y - [self.collectionView convertPoint:point fromView:view].y < 0) ? 1 : 0;
        destination = [NSIndexPath indexPathForItem:(pathToPictogramAtDestination.item + offset) inSection:pathToPictogramAtDestination.section];
        
        targetSchedule = [self scheduleForSection:pathToPictogramAtDestination.section];
    }
    
    [self insertPictogramWithID:objectID inSchedule:targetSchedule atIndexPath:destination];
    
    if (NO == [self.dataSource.managedObjectContext save:nil]) return NO;
    else return YES;
}

/** Filters the passed in cells and returns the cells which intersect the passed in rectangle.
 */
- (NSArray *)collectionViewCellsIn:(NSArray * const)collectionViewCells intersecting:(CGRect const)rect
{
    NSMutableArray *intersectingCells = [[NSMutableArray alloc] init];
    for (UICollectionViewCell *cell in collectionViewCells) {
        if (CGRectIntersectsRect(cell.frame, rect)) {
            [intersectingCells addObject:cell];
        }
    }
    return intersectingCells;
}

/** Returns the rectangle of the cell which has the largest intersection area with the passed in rect.
 @pre Atleast one of the cells passed in must intersect the given rect.
 */
- (CGRect)largestIntersectionOf:(NSArray *)collectionviewCells and:(CGRect)rect
{
    NSAssert(collectionviewCells, @"Expected collectionViewCells.");
    
    CGRect rectWithLargestIntersectionArea = CGRectZero;
    for (UICollectionViewCell *cell in collectionviewCells) {
        CGRect const intersection = CGRectIntersection(cell.frame, rect);
        if (intersection.size.height * intersection.size.width > rectWithLargestIntersectionArea.size.height * rectWithLargestIntersectionArea.size.width) {
            rectWithLargestIntersectionArea = intersection;
        }
    }
    NSAssert(CGRectEqualToRect(rectWithLargestIntersectionArea, CGRectZero) == NO, @"Unexpected results. Failed to find the largest intersection.");
    
    return rectWithLargestIntersectionArea;
}

- (void)insertPictogramWithID:(NSManagedObjectID * const)objectID
                   inSchedule:(NSManagedObject * const)schedule
                  atIndexPath:(NSIndexPath * const)indexPath
{
    NSManagedObject * const pictogramContainer = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer"
                                                                               inManagedObjectContext:self.managedObjectContext];
    [pictogramContainer setValue:[self.managedObjectContext objectWithID:objectID] forKey:@"pictogram"];
    [[schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS] insertObject:pictogramContainer atIndex:indexPath.item];
    [pictogramContainer setValue:schedule forKeyPath:@"schedule"];
    
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

#pragma mark -

/** Convinience method
 */
- (NSManagedObjectContext *)managedObjectContext
{
    return self.dataSource.managedObjectContext;
}


/** Persists changes made to the managed object context.
 @throw NSException if the managed object context can not be saved.
 */
- (void)saveSchedule
{
    NSAssert(self.dataSource.managedObjectContext, @"The data source does not have a managed object context.");
    if ([self.dataSource.managedObjectContext hasChanges] == NO) return;
    
    NSError *error;
    if ([self.dataSource.managedObjectContext save:&error] == NO) {
        @throw [NSException exceptionWithName:@"Error saving deletion from schedule." reason:error.localizedFailureReason userInfo:nil];
    }
}

#pragma mark - Rearrange pictograms

- (IBAction)pictogramLongPressed:(UILongPressGestureRecognizer * const)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) [self handleItemSelection:sender];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSAssert(self.pictogramBeingMoved, @"Must not be nil.");
        /* Two animations will be performed during a move. One on insert and one on delete.
         Unless they are grouped, the UI might in some cases not end up in a consistent state. */
        [UICollectionView beginAnimations:nil context:nil];
        {
            [self.delegate handleAddPictogramToScheduleAt:[sender locationInView:self.view] relativeTo:self.view];
            
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
    
    if (sender.state == UIGestureRecognizerStateCancelled) {
        // TODO deal with the cancelation
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        [self.delegate handleItemMovedTo:[sender locationInView:self.view] relativeTo:self.view];
    }
}

- (void)handleItemSelection:(UILongPressGestureRecognizer * const)sender
{
    self.pictogramBeingMoved = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
    self.mostRecentlytouchedPictogram = [self getPictogramAtIndexPath:self.pictogramBeingMoved].objectID;
    [self notifyDelegateOfItemSelectionWithObjectID:self.mostRecentlytouchedPictogram atLocation:[sender locationInView:self.view]];
}

/** Returns the touched item.
 */
- (NSManagedObject *)getPictogramAtIndexPath:(NSIndexPath * const)indexPath
{
    WeekDataSource * const dataSource = (WeekDataSource *)self.collectionView.dataSource;
    NSManagedObject * const schedule = [[dataSource.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.section];
    NSManagedObject * const pictogramContainer = [[schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS] objectAtIndex:indexPath.item];
    return [pictogramContainer valueForKey:CD_ENTITY_PICTOGRAM];
}

/** Tells the delegate which item was touched, and its location.
 */
- (void)notifyDelegateOfItemSelectionWithObjectID:(NSManagedObjectID * const)objectID atLocation:(CGPoint const)location
{
    [self.delegate selectedPictogramToAdd:objectID atLocation:location relativeTo:self.view];
}

@end
