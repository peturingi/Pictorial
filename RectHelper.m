#import "RectHelper.h"

@implementation RectHelper

+ (CGRect)makeRectWithSize:(CGSize const)size andOrigin:(CGPoint const)origin {
    CGRect rect = CGRectZero;
    rect.origin = origin;
    rect.size = size;
    return rect;
}

+ (CGRect)largestIntersectionOfViews:(NSArray *)views andRect:(CGRect)rect
{
    NSAssert(views, @"Expected collectionViewCells.");
    
    CGRect rectWithLargestIntersectionArea = CGRectZero;
    for (UIView *cell in views) {
        CGRect const intersection = CGRectIntersection(cell.frame, rect);
        if (intersection.size.height * intersection.size.width > rectWithLargestIntersectionArea.size.height * rectWithLargestIntersectionArea.size.width) {
            rectWithLargestIntersectionArea = intersection;
        }
    }
    NSAssert(CGRectEqualToRect(rectWithLargestIntersectionArea, CGRectZero) == NO, @"Unexpected results. Failed to find the largest intersection.");
    
    return rectWithLargestIntersectionArea;
}

/** Filters the passed in views and returns the views which intersect the passed in rectangle.
 */
+ (NSArray *)viewsIn:(NSArray *)views intersectingWithRect:(CGRect)rect {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (UIView *view in views) {
        if (CGRectIntersectsRect(view.frame, rect)) {
            [result addObject:view];
        }
    }
    return result;
}

@end
