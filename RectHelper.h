#import <Foundation/Foundation.h>

/** Provides helper methods which perform compuations on CGRect structures.
 */
@interface RectHelper : NSObject

/** Returns the rectangle of the cell which has the largest intersection area with the passed in rect.
 @pre Atleast one of the cells passed in must intersect the given rect.
 */
+ (CGRect)largestIntersectionOfViews:(NSArray *)views andRect:(CGRect)rect;

+ (NSArray *)viewsIn:(NSArray *)views intersectingWithRect:(CGRect)rect;

@end
