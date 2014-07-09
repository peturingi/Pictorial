#import "UIView+HoverView.h"

@implementation UIView (HoverView)

- (void)roundBorder {
    [self.layer setBorderWidth:PICTOGRAM_PICTOGRAM_BORDER_WIDTH];
    [self.layer setCornerRadius:PICTOGRAM_CORNER_RADIUS];
    [self.layer setBorderColor:PICTOGRAM_BORDER_COLOR];
    [self.layer setMasksToBounds:YES];
}

- (void)addHoverShadow {
    self.layer.shadowColor = PICTOGRAM_SHADOW_COLOR;
    self.layer.shadowOffset = PICTOGRAM_SHADOW_OFFSET;
    self.layer.shadowOpacity = PICTOGRAM_SHADOW_OPACITY;
    self.layer.shadowRadius = PICTOGRAM_SHADOW_RADIUS;
}

@end