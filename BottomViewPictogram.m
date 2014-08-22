#import "BottomViewPictogram.h"

@implementation BottomViewPictogram

-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.highlighted) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 1, 0, 0, 1);
        CGContextFillRect(context, self.bounds);
    }
}

@end
