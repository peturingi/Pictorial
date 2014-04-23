#import "PictogramsCollectionViewDelegateFlowLayout.h"

#define CELL_HEIGHT 135
#define CELL_WIDTH  100

@implementation PictogramsCollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
    return size;
}

@end