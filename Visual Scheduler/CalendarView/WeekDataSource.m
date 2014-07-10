#import "CalendarCell.h"
#import "CalendarView.h"
#import "WeekDataSource.h"
#import "AppDelegate.h"
#import "UIView+BBASubviews.h"

@implementation WeekDataSource

- (id)init {
    self = [super init];
    if (self) {
        [self setupDataSource];
    }
    return self;
}

- (void)setupDataSource {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Schedule"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]; // Sorts by title, but should sort by name
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:20];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"title" cacheName:nil];
    [self.fetchedResultsController performFetch:NULL]; // Improper error handling.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSManagedObject *day = [sectionInfo objects][0];
    NSOrderedSet *pictograms = [day valueForKey:@"pictograms"];
    return pictograms.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.fetchedResultsController.sections.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Get the pictogram from core data.
    id <NSFetchedResultsSectionInfo> section = [self.fetchedResultsController sections][indexPath.section];
    NSManagedObject *schedule = [section objects].firstObject;
    NSManagedObject *pictogram = [[schedule valueForKey:@"pictograms"] objectAtIndex:indexPath.item];
    
    // Configure the cell and use it to show the pictoram
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CALENDAR_CELL forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell.contentView firstSubviewWithTag:CELL_TAG_FOR_IMAGE_VIEW];
    NSData *imageData = [pictogram valueForKey:@"image"];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    imageView.image = image;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DAY_OF_WEEK_COLOR forIndexPath:indexPath];
    NSAssert(view, @"Failed to dequeue reusable view.");
    //Schedule *schedule = [_schedules objectAtIndex:indexPath.section];
    //view.backgroundColor = schedule.color;
    return view;
}

@end