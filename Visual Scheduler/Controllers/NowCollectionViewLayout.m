#import "NowCollectionViewLayout.h"

@implementation NowCollectionViewLayout

- (CGSize)sizeOfItems {
    CGFloat edge = (self.collectionView.bounds.size.height / 3.0f) - (self.insets.top + self.insets.bottom) - HEADER_HEIGHT / 3.0f;
    return CGSizeMake(edge, edge);
}

@end