#import "CalendarCell.h"

@implementation CalendarCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupBorder];
    }
    NSAssert(self, @"Failed to init.");
    return self;
}

- (void)setupBorder
{
    self.layer.borderWidth = PICTOGRAM_BORDER_WIDTH;
    self.layer.cornerRadius = PICTOGRAM_BORDER_RADIUS;
    self.layer.borderColor = PICTOGRAM_BORDER_COLOR;
}

@end
