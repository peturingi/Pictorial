#import "AppDelegate.h"
#import "PictogramSelectorDataSource.h"
#import "UIView+BBASubviews.h"

@implementation PictogramSelectorDataSource

- (id)init {
    self = [super init];
    if (self) {
        [self setupDataSource];
    }
    NSAssert(self, @"Failed to init");
    return self;
}

- (void)setupDataSource {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CD_ENTITY_PICTOGRAM];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:CD_KEY_PICTOGRAM_TITLE ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:20];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:NULL]; // Improper error handling
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *reusableCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pictogramSelector" forIndexPath:indexPath];
    [self configureCell:reusableCell atIndexPath:indexPath];
    return reusableCell;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView firstSubviewWithTag:CELL_TAG_FOR_IMAGE_VIEW];
    NSData *imageData = [object valueForKey:CD_KEY_PICTOGRAM_IMAGE];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    imageView.image = image;
    
    UILabel *labelView = (UILabel *)[cell.contentView firstSubviewWithTag:CELL_TAG_FOR_LABEL_VIEW];
    labelView.text = [object valueForKey:CD_KEY_PICTOGRAM_TITLE];
    
    imageView.layer.borderWidth = PICTOGRAM_BORDER_WIDTH;
    imageView.layer.cornerRadius = PICTOGRAM_CORNER_RADIUS;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [NSFetchedResultsController deleteCacheWithName:[controller cacheName]];
    [controller performFetch:nil]; // poor error handling
    // TODO, update the bottom view, the above code might be wrong.
}

@end