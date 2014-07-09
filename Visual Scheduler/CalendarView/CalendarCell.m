#import "CalendarCell.h"

@implementation CalendarCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupImageView];
        [self setupBorder];
    }
    return self;
}

- (void)setupImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _imageView.layer.cornerRadius = PICTOGRAM_BORDER_RADIUS;
    _imageView.clipsToBounds = YES;
    [self setBackgroundView:_imageView];
}

- (void)setupBorder {
    self.contentView.layer.borderWidth = PICTOGRAM_BORDER_WIDTH;
    self.contentView.layer.cornerRadius = PICTOGRAM_BORDER_RADIUS;
    self.contentView.layer.borderColor = PICTOGRAM_BORDER_COLOR;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.image = nil;
}

@end