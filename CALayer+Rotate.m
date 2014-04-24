#import "CALayer+Rotate.h"
@implementation CALayer (Rotate)
-(void)rotate:(CGFloat)amount{
    self.affineTransform = CGAffineTransformMakeRotation(amount);
}
@end
