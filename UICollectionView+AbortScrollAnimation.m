#import "UICollectionView+AbortScrollAnimation.h"

@implementation UICollectionView (AbortScrollAnimation)

- (void)abortScrollAnimation {
    CGPoint offset = self.contentOffset;
    offset.y += 1;
    [self setContentOffset:offset animated:NO];
    offset.y -= 1;
    [self setContentOffset:offset animated:NO];
}

@end