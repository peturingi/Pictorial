#import "CALayer+WithSizeAndPosition.h"
@implementation CALayer (WithSizeAndPosition)
+(CALayer*)layerWithSize:(CGRect)rect andPosition:(CGPoint)point{
    CALayer* layer = [CALayer new];
    [layer setContentsScale:[[UIScreen mainScreen] scale]];
    [layer setBounds:rect];
    [layer setPosition:point];
    return layer;
}
@end
