#import "UIView+ContraintInfo.h"

@implementation UIView (ContraintInfo)

- (NSArray *)constraintsOfSelfAndSubviews {
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:self.constraints];
    for (UIView *subview in self.subviews) {
        [constraints addObjectsFromArray:subview.constraints];
    }
    NSAssert(constraints, nil);
    return constraints;
}

@end
