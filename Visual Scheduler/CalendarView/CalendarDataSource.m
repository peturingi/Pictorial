#import "CalendarDataSource.h"
#import "../Database/Repository.h"
#import "CalendarCell.h"
#import "../Protocols/ImplementsCount.h"
#import "../Protocols/ContainsImage.h"

@implementation CalendarDataSource

- (void)awakeFromNib {
    // TODO This class should not konw about the Repository. Refactor ASAP.
    _sections = [[Repository sharedStore] allSchedules];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<ImplementsCount> obj = [_sections objectAtIndex:section];
    return obj.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _sections.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCell *cell = (CalendarCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PICTOGRAM_CELL" forIndexPath:indexPath];
    id<ImplementsObjectAtIndex> selectedSection = [_sections objectAtIndex:indexPath.section];
    id<ContainsImage> objcontainingImage = [selectedSection objectAtIndex:indexPath.item];
    cell.imageView.image = objcontainingImage.image;
    return cell;
}

@end