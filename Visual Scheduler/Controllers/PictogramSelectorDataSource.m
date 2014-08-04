#import "AppDelegate.h"
#import "PictogramSelectorDataSource.h"
#import "UIView+BBASubviews.h"

@implementation PictogramSelectorDataSource

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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CD_ENTITY_PICTOGRAM];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:CD_KEY_PICTOGRAM_TITLE ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:20];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:delegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    NSError *fetchError;
    BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&fetchError];
    if (fetchSuccessful == NO)
    {
        @throw [NSException exceptionWithName:@"Failed to fetch pictograms from core data." reason:fetchError.localizedFailureReason userInfo:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *reusableCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pictogramSelector" forIndexPath:indexPath];
    NSAssert(reusableCell, @"API should guarantee that a reusable cell is returned.");
    [self configureCell:reusableCell atIndexPath:indexPath];
    return reusableCell;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView firstSubviewWithTag:CELL_TAG_FOR_IMAGE_VIEW];
    NSData *imageData = [object valueForKey:CD_KEY_PICTOGRAM_IMAGE];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    imageView.image = image;
    
    UILabel *labelView = (UILabel *)[cell.contentView firstSubviewWithTag:CELL_TAG_FOR_LABEL_VIEW];
    labelView.text = [object valueForKey:CD_KEY_PICTOGRAM_TITLE];
    
    imageView.layer.borderWidth = PICTOGRAM_BORDER_WIDTH;
    imageView.layer.cornerRadius = PICTOGRAM_CORNER_RADIUS;
    imageView.layer.masksToBounds = YES;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSAssert(self.collectionView, @"The collectionView has not been set.");
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        }
    }
    
}

/** Returns the touched pictogram.
 */
- (NSManagedObject *)pictogramAtIndexPath:(NSIndexPath * const)indexPath
{
    NSAssert(indexPath, @"Must not be nil.");
    return [[self fetchedResultsController] objectAtIndexPath:indexPath];
}

@end