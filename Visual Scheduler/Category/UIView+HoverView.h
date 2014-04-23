#import <UIKit/UIKit.h>

@interface UIView (HoverView)

/** Rounds to border to predefined values.
 @note the values are predefined in .pch
 */
- (void)roundBorder;

/** Adds hovereffect in form of a shadow.
 @note the values are predefined in .pch
 */
- (void)addHoverShadow;
@end