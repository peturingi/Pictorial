#import <UIKit/UIKit.h>

@interface UIView (BBASubviews)

/** Returns the first subview matching the given tag.
 @throws Exception if no view was found.
 */
- (UIView *)firstSubviewWithTag:(NSInteger)tagOfView;

@end