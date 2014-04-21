#import "WeekCollectionViewLayout.h"

@implementation WeekCollectionViewLayout

- (NSDictionary *)cellAttributes {
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];
    
    self.maxNumRows = 0;
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++){
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        self.maxNumRows = MAX(numberOfItemsInSection, self.maxNumRows);
    }
    
    NSInteger firstDay = MONDAY;
    NSInteger lastDay  = SUNDAY;
    
    for (NSInteger day = firstDay; day <= lastDay; day++) {
        NSInteger numberOfItemsToday = [self.collectionView numberOfItemsInSection:day];
        for (NSInteger item = 0; item < numberOfItemsToday; item++) {
            NSIndexPath *pathToItem = [NSIndexPath indexPathForItem:item inSection:day];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:pathToItem];
            attributes.frame = [self frameForItemAtIndexPath:pathToItem];
            [cellInformation setObject:attributes forKey:pathToItem];
        }
    }
    return cellInformation;
}

- (CGPoint)originForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = [self sizeOfItems];
    CGFloat x = self.insets.left + indexPath.section * (itemSize.width + self.insets.top + self.insets.right);
    CGFloat y = ([self headerSize].height + self.insets.top) + indexPath.item * (itemSize.height + self.insets.top + self.insets.bottom);
    return CGPointMake(x, y);
}

- (CGSize)sizeOfItems {
    CGFloat edge = (self.collectionView.bounds.size.width / self.collectionView.numberOfSections) - (self.insets.right+self.insets.left);
    return CGSizeMake(edge, edge);
}

- (NSDictionary *)headerAttributes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:DAYS_IN_WEEK];
    
    NSInteger firstDay = MONDAY;
    NSInteger lastDay = SUNDAY;
    
    for (NSInteger day = firstDay; day <= lastDay; day++) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:day]; // assume there is always an item, so we can calculate offset of header.
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:path];
        attributes.frame = [self frameForHeaderOfSection:day];
        attributes.zIndex = 1024;
        [dictionary setObject:attributes forKey:path];
    }
    return dictionary;
}

- (CGPoint)originForHeaderOfSection:(NSUInteger)section {
    CGSize headerSize = [self headerSize];
    CGFloat x = section * headerSize.width;
    CGFloat y = self.collectionView.contentOffset.y; // Moves the headers location up, so it is drawn above the first item
    return CGPointMake(x, y);
}

@end