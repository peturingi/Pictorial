#import "EmptyCalendarCell.h"

@implementation EmptyCalendarCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.border = [self dottedBorder];
        [self.layer addSublayer:self.border];
    }
    return self;
}

- (CAShapeLayer *)dottedBorder
{
    CAShapeLayer * const dottedBorder = [CAShapeLayer layer];
    dottedBorder.strokeColor = PICTOGRAM_BORDER_COLOR;
    dottedBorder.fillColor = nil; // Do not fill.
    dottedBorder.lineDashPattern = PICTOGRAM_BORDER_PATTERN;
    dottedBorder.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:PICTOGRAM_CORNER_RADIUS].CGPath;
    return dottedBorder;
}

- (void)layoutSubviews {
    [self layoutBorder];
}

- (void)layoutBorder {
    self.border.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:PICTOGRAM_BORDER_RADIUS].CGPath;
    self.border.frame = self.bounds;
}

@end
