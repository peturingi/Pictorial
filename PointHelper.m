#import "PointHelper.h"

@implementation PointHelper

+ (CGPoint)addPointA:(CGPoint const)a andB:(CGPoint const)b {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

+ (CGPoint)subPointA:(CGPoint const)a fromB:(CGPoint const)b {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

@end
