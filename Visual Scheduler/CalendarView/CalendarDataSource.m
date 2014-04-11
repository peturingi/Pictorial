#import "CalendarDataSource.h"
#import "../Database/Repository.h"
#import "ImageCollectionViewCell.h"

#import "../Protocols/ImplementsCount.h"
#import "../Protocols/ContainsImage.h"

@implementation CalendarDataSource

- (void)awakeFromNib {
    // TODO This class should not konw about the Repository. Refactor ASAP.
    _sections = [[Repository sharedStore] allSchedules];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<ImplementsCount> selectedSection = [self.sections objectAtIndex:section];
    return selectedSection.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PICTOGRAM_CELL" forIndexPath:indexPath];
    id<ImplementsObjectAtIndex> selectedSection = [self.sections objectAtIndex:indexPath.section];
    id<ContainsImage> objWithImage = [selectedSection objectAtIndex:indexPath.item];
    cell.imageView.image = objWithImage.image;
    return cell;
}

#pragma mark - Helpers

- (NSInteger)pictogramCount {
    NSInteger counter = 0;
    for (Schedule *s in self.sections) {
        counter += s.pictograms.count;
    }
    return counter;
}

@end
