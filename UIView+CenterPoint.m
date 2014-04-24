#import "UIView+CenterPoint.h"
@implementation UIView (CenterPoint)
-(CGPoint)centerPoint{
    CGFloat midX = CGRectGetMidX(self.layer.bounds);
    CGFloat midY = CGRectGetMidY(self.layer.bounds);
    CGPoint point = CGPointMake(midX, midY);
    return point;
}
@end
