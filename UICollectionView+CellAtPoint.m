#import "UICollectionView+CellAtPoint.h"

@implementation UICollectionView (CellAtPoint)

- (UICollectionViewCell *)cellAtPoint:(const CGPoint)point {
    NSIndexPath * const pathToSelectedCell = [self indexPathForItemAtPoint:point];
    return [self cellForItemAtIndexPath:pathToSelectedCell];
}

@end
