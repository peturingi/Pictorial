#import "CalendarCell.h"

@implementation CalendarCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupImageView];
        [self setupBorder];
    }
    NSAssert(self, @"Failed to init.");
    return self;
}

- (void)setupImageView
{
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    NSAssert(_imageView, @"Failed to create an imageView");
    _imageView.layer.cornerRadius = PICTOGRAM_BORDER_RADIUS;
    _imageView.clipsToBounds = YES;
    [self setBackgroundView:_imageView];
}

- (void)setupBorder
{
    self.layer.borderWidth = PICTOGRAM_BORDER_WIDTH;
    self.layer.cornerRadius = PICTOGRAM_BORDER_RADIUS;
    self.layer.borderColor = PICTOGRAM_BORDER_COLOR;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageView.image = nil;
}

@end