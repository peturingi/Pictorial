#import "CalendarCell.h"
#import "CalendarView.h"
#import "WeekDataSource.h"
#import "AppDelegate.h"
#import "UIView+BBASubviews.h"

@implementation WeekDataSource

- (id)init
{
    self = [super init];
    if (self) {
        [self setupDataSource];
    }
    NSAssert(self, @"Failed to init");
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
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    if (error) @throw [NSException exceptionWithName:@"Core Data: Fetch failed." reason:error.localizedFailureReason userInfo:nil];
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
    
    // Return the schedules pictogram count.
    NSManagedObject * const schedule = [sectionInfo objects].firstObject;
    NSOrderedSet * const pictograms = [schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS];
    return pictograms.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get section containing the schedule which contains the pictogram I want to display.
    id <NSFetchedResultsSectionInfo> const section = [self.fetchedResultsController sections][indexPath.section];
    NSAssert([section objects].count == 1, @"Each day (section) must contain only a single schedule.");
    NSManagedObject * const schedule = [section objects].firstObject;
    
    // Get the pictogram I want to display.
    NSArray * const pictogramsInSchedule = [schedule valueForKey:CD_KEY_SCHEDULE_PICTOGRAMS];
    NSManagedObject * const pictogramContainer = pictogramsInSchedule[indexPath.item];
    NSManagedObject * const pictogram = [pictogramContainer valueForKey:@"pictogram"];
    
    // Return the pictogram in a collectionView cell.
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CALENDAR_CELL forIndexPath:indexPath];
    UIImageView * const imageView = (UIImageView *)[cell.contentView firstSubviewWithTag:CELL_TAG_FOR_IMAGE_VIEW];
    NSData *imageData = [pictogram valueForKey:CD_KEY_PICTOGRAM_IMAGE];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    imageView.image = image;
    NSAssert(imageView.image, @"Failed to present the pictogram.");
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
    
    // Set the color
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:[schedule valueForKey:CD_KEY_SCHEDULE_COLOR]];
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                        withReuseIdentifier:DAY_HEADER
                                                                               forIndexPath:indexPath];
    view.backgroundColor = color;
    
    // Set the name of the day
    UILabel *dayLabel = (UILabel *)[view firstSubviewWithTag:STORYBOARD_TAG_DAY_LABEL];
    NSAssert(dayLabel, @"Expected a label.");
    dayLabel.text = [schedule valueForKey:CD_KEY_SCHEDULE_TITLE];
    
    return view;
}

@end