#import "UIView+BBASubviews.h"

@implementation UIView (BBASubviews)

- (UIView *)firstSubviewWithTag:(NSInteger)tagOfView {
    for (UIView *subview in self.subviews) {
        if (subview.tag == tagOfView) {
            return subview;
        }
    }
    return nil;
}

@end
