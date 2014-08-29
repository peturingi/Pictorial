#import "ColorView.h"

@implementation ColorView

- (void)dealloc {
    _color = nil;
}

- (void)setColor:(UIColor *)color {
    NSAssert(color, @"Expected a color.");
    _color = color;
    [self setBackgroundColor:color];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
}

@end
