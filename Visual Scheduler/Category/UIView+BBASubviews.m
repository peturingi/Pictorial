#import "UIView+BBASubviews.h"

@implementation UIView (BBASubviews)

- (UIView *)firstSubviewWithTag:(NSInteger)tagOfView {
    UIView *subview = nil;
    for (subview in self.subviews) {
        if (subview.tag == tagOfView) {
            return subview;
        }
    }
    if (!subview) {
        NSString *reasonForException = [NSString stringWithFormat:@"No subview found matching tag: %ld", tagOfView];
        @throw [NSException exceptionWithName:@"View not found" reason:reasonForException userInfo:nil];
    }
    return nil;
}

@end