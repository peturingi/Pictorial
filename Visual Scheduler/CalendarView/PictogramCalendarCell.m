#import "PictogramCalendarCell.h"

@implementation PictogramCalendarCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupBorder];
        [self setupImageView];
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

- (void)setupImageView
{
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    NSAssert(_imageView, @"Failed to create an imageView");
    _imageView.layer.cornerRadius = PICTOGRAM_BORDER_RADIUS;
    _imageView.clipsToBounds = YES;
    [self setBackgroundView:_imageView];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageView.image = nil;
}

@end