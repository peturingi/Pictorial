#import "NowCollectionViewLayout.h"

@implementation NowCollectionViewLayout


- (NSDictionary *)cellAttributes {
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionaryWithCapacity:1];
    NSInteger today = [self sectionRepresentingToday];
    self.maxNumRows = [self.collectionView numberOfItemsInSection:today];
    
    for (NSInteger item = 0; item < self.maxNumRows; item++) {
        NSIndexPath *pathToItem = [NSIndexPath indexPathForItem:item inSection:today];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:pathToItem];
        attributes.frame = [self frameForItemAtIndexPath:pathToItem];
        [cellInformation setObject:attributes forKey:pathToItem];
    }
    
    return cellInformation;
}

- (CGPoint)originForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = [self sizeOfItems];
    CGFloat x = [self collectionViewContentSize].width / 2.0f + self.collectionView.contentOffset.x - itemSize.width / 2.0f;
    CGFloat y = [self headerSize].height + self.insets.top + indexPath.item * (itemSize.height + self.insets.top + self.insets.bottom);
    return CGPointMake(x, y);
}

- (CGSize)sizeOfItems {
    CGFloat edge = (self.collectionView.bounds.size.height / 3.0f) - (self.insets.top + self.insets.bottom) - [self headerSize].height / 3.0f;
    return CGSizeMake(edge, edge);
}

- (CGPoint)originForHeaderOfSection:(NSUInteger)section {
    CGSize headerSize = [self headerSize];
    
    CGFloat x = [self collectionViewContentSize].width / 2.0f - headerSize.width / 2.0f + self.collectionView.contentOffset.x;
    CGFloat y = self.collectionView.contentOffset.y;
    return CGPointMake(x, y);
}

@end
