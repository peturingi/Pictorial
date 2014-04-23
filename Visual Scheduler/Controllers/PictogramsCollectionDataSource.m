#import "PictogramsCollectionDataSource.h"
#import "Repository.h"
#import "UIView+BBASubviews.h"

@implementation PictogramsCollectionDataSource

- (id)init {
    self = [super init];
    if (self) {
        [self setupDataSource];
    }
    return self;
}

- (void)setupDataSource {
    Repository *repo = [Repository defaultRepository];
    if (!repo) {
        @throw [NSException exceptionWithName:@"Could not setup data source." reason:@"Failed to get shared repository." userInfo:nil];
    }
    _data = [repo allPictograms];
    if (!_data) {
        @throw [NSException exceptionWithName:@"Failed to fetch pictograms from data source." reason:@"Unknown." userInfo:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSAssert(_data != nil, @"No datasource.");
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *reusableCell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID_PICTOGRAM_SELECTOR forIndexPath:indexPath];
    [self configureCell:reusableCell atIndexPath:indexPath];
    return reusableCell;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Pictogram *pictogram = [self pictogramAtIndexPath:indexPath];
    NSAssert(pictogram && pictogram.title.length > 0 && pictogram.image, @"Invalid pictogram");

    UIImageView *imageView = (UIImageView *)[cell.contentView firstSubviewWithTag:CELL_TAG_FOR_IMAGE_VIEW];
    imageView.image = pictogram.image;
    
    UILabel *labelView = (UILabel *)[cell.contentView firstSubviewWithTag:CELL_TAG_FOR_LABEL_VIEW];
    labelView.text = pictogram.title;
    
    imageView.layer.borderWidth = PICTOGRAM_BORDER_WIDTH;
    imageView.layer.cornerRadius = PICTOGRAM_CORNER_RADIUS;
}

#pragma mark - Public

- (Pictogram *)pictogramAtIndexPath:(NSIndexPath *)indexPath {
    Pictogram *pictogram = nil;
    @try {
        pictogram = [_data objectAtIndex:indexPath.item];
    }
    @catch (NSException *e){
        if ([e.name isEqualToString:NSRangeException]) {
            NSString *reasonForException = [NSString stringWithFormat:@"No pictogram is located at indexPath %@", indexPath];
            @throw [NSException exceptionWithName:@"Pictogram not found." reason:reasonForException userInfo:nil];
        }
    }
    @finally {
        return pictogram;
    }
    return pictogram;
}

@end