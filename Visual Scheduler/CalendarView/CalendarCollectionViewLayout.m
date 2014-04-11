#import "CalendarCollectionViewLayout.h"

static const NSInteger DaysInWeek = 7;
static const CGFloat HorizontalSpacing = 10;

@implementation CalendarCollectionViewLayout

// Returns Width and Height of the area within the collection view.
// If the are is larger than the view, then it becomes scrollable.
- (CGSize)collectionViewContentSize {
    // Don't scroll horizontally
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    //TODO Calculate max height based on longest schedule.
    CGSize contentSize = CGSizeMake(contentWidth, 1111);
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
