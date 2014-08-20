#import "WeekDataSource.h"
#import "AppDelegate.h"
#import "UIView+BBASubviews.h"
#import "PictogramCalendarCell.h"
#import "Schedule.h"
#import "EmptyCalendarCell.h"
#import "PictogramContainer.h"
#import "Pictogram.h"

@implementation WeekDataSource

- (id)init
{
    self = [super init];
    if (self) {
        [self setupDataSource];
        [self fetchData];
    }
    return self;
}

- (void)setupDataSource
{
    AppDelegate * const delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    NSAssert(_managedObjectContext, @"Failed to get managedObjectContext.");
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CD_ENTITY_SCHEDULE];
    
    NSSortDescriptor * const sort = [[NSSortDescriptor alloc] initWithKey:CD_KEY_SCHEDULE_DATE ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:CD_FETCH_BATCH_SIZE];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:@"date"
                                                                               cacheName:nil];
    NSAssert(_fetchedResultsController, @"Failed to get fetchedResultsController.");
}

- (void)fetchData {
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    if (error) @throw [NSException exceptionWithName:@"Core Data: Fetch failed." reason:error.localizedFailureReason userInfo:nil];
}

#pragma mark - Pictograms and Schedules

- (Pictogram *)pictogramAtIndexPath:(NSIndexPath * const)indexPath
{
    PictogramContainer * const pictogramContainer = [self pictogramContainerAtIndexPath:indexPath];
    return (Pictogram*)pictogramContainer.pictogram;
}

- (PictogramContainer *)pictogramContainerAtIndexPath:(NSIndexPath *const)indexPath
{
    Schedule * const schedule = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.section];
    return [schedule.pictograms objectAtIndex:indexPath.item];
}



/**
 @return NSIndexPath to container if found.
 @return nil if not found.
 */
- (NSIndexPath *)indexPathToPictogramContainer:(PictogramContainer * const)pictogramContainer inCollectionView:(UICollectionView * const)collectionView
{
    for (NSUInteger section = 0; section < [self numberOfSectionsInCollectionView:collectionView]; section++) {
        Schedule * const schedule = [[self.fetchedResultsController fetchedObjects] objectAtIndex:section];
        for (NSUInteger index = 0; index < schedule.pictograms.count; index++) {
            NSIndexPath * const indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            PictogramContainer * const container = [schedule.pictograms objectAtIndex:indexPath.item];
            if ([pictogramContainer.objectID isEqual:container.objectID]) return indexPath;
        }
    }
    {
        NSAssert(false, @"Should not be reachable. Container not found.");
    } // Assert
    return nil; // Not found.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger const sectionCount = self.fetchedResultsController.sections.count;
    NSAssert(sectionCount >= 1, @"No sections found. This could mean that no schedule has been created yet.");
    return sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Get the section containing the schedule representing a given day.
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSAssert([sectionInfo objects].count == 1, @"Each day (section) must contain only a single schedule.");
    
    // Get number of pictograms in schedule
    Schedule const * schedule = [sectionInfo objects].firstObject;
    NSOrderedSet * const pictograms = [schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS];
    
    // Increase the real number by one, if the schedule is in edit mode.
    // This allows me to inject an empty box at the bottom of the schedule
    // which is used as an indicator that a pictogram can be dropped there
    NSUInteger const numberOfEmptyBoxes = self.editing ? 1 : 0;
    
    return pictograms.count + numberOfEmptyBoxes;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get section containing the schedule which contains the pictogram I want to display.
    id <NSFetchedResultsSectionInfo> const section = [self.fetchedResultsController sections][indexPath.section];
    NSAssert([section objects].count == 1, @"Each day (section) must contain only a single schedule.");
    NSManagedObject * const schedule = [section objects].firstObject;
 
    // Get all pictograms in schedule
    NSArray * const pictogramsInSchedule = [schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS];
 
    
    /* If schedule is in edit mode, display empty box */
    if (self.editing && indexPath.item+1 > pictogramsInSchedule.count) {
        EmptyCalendarCell * const cell = [collectionView dequeueReusableCellWithReuseIdentifier:EMPTY_CALENDAR_CELL forIndexPath:indexPath];
        return cell;
    }
    
    // Get pictogram to display
    NSManagedObject * const pictogramContainer = pictogramsInSchedule[indexPath.item];
    NSManagedObject * const pictogram = [pictogramContainer valueForKey:@"pictogram"];
    
    // Return the pictogram in a collectionView cell.
    PictogramCalendarCell * const cell = [collectionView dequeueReusableCellWithReuseIdentifier:PICTOGRAM_CALENDAR_CELL forIndexPath:indexPath];
    // Show the cells edit button if we are in editable state.
    cell.deleteButton.alpha = self.editing ? 1.0f : 0.0f;
    cell.deleteButton.enabled = self.editing;
    //set image
    NSData * const imageData = [pictogram valueForKey:CD_KEY_PICTOGRAM_IMAGE];
    UIImage * const image = [[UIImage alloc] initWithData:imageData];
    cell.imageView.image = image;
    NSAssert(cell.imageView.image, @"Failed to present the pictogram.");
    return cell;
}

/**
 Configure the header for each day.
 Each day has a color and a name.
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // Get the schedule which I want to set the color
    id <NSFetchedResultsSectionInfo> section = [self.fetchedResultsController sections][indexPath.section];
    NSManagedObject *schedule = [section objects].firstObject;
    NSAssert(schedule, @"Schedule was not found!");
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:[schedule valueForKey:CD_KEY_SCHEDULE_COLOR]];
    
    UICollectionReusableView *view;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:DAY_HEADER
                                                                                   forIndexPath:indexPath];
        
        
        // Set the name of the day
        UILabel *dayLabel = (UILabel *)[view firstSubviewWithTag:STORYBOARD_TAG_DAY_LABEL];
        NSAssert(dayLabel, @"Expected a label.");
        dayLabel.text = [schedule valueForKey:CD_KEY_SCHEDULE_TITLE];
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                            withReuseIdentifier:DAY_FOOTER
                                                                                   forIndexPath:indexPath];
    }
    
    view.backgroundColor = color;
    
    return view;;
}

/** A section in the collection view represents a single schedule.
 @pre The specified section contains one schedule.
 */
- (Schedule *)scheduleForSection:(NSUInteger const)section
{
    id <NSFetchedResultsSectionInfo> const sectionContainingSchedule = self.fetchedResultsController.sections[section];
    NSAssert([sectionContainingSchedule objects].count == 1, @"There should be a single schedule per section!");
    return [sectionContainingSchedule objects].firstObject;
}

- (void)save {
    NSAssert(self.managedObjectContext, @"The data source does not have a managed object context.");
    if ([self.managedObjectContext hasChanges] == NO) return;
    
    NSError *error;
    if ([self.managedObjectContext save:&error] == NO) {
        @throw [NSException exceptionWithName:@"Error saving deletion from schedule." reason:[error.localizedFailureReason stringByAppendingString:error.localizedDescription] userInfo:nil];
    }
}

@end