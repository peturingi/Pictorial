#import "PictogramSelectorDataSource.h"
#import "UIView+BBASubviews.h"

#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@implementation PictogramSelectorDataSource

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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Pictogram"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:20];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController performFetch:NULL];
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
    NSData *imageData = [object valueForKey:@"image"];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    imageView.image = image;
    
    UILabel *labelView = (UILabel *)[cell.contentView firstSubviewWithTag:CELL_TAG_FOR_LABEL_VIEW];
    labelView.text = [object valueForKey:@"title"];
    
    imageView.layer.borderWidth = PICTOGRAM_PICTOGRAM_BORDER_WIDTH;
    imageView.layer.cornerRadius = PICTOGRAM_CORNER_RADIUS;
}

@end