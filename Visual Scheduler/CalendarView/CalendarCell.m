#import "CalendarCell.h"

#define BORDER_WIDTH    2.0f
#define BORDER_RADIUS   5.0f

@implementation CalendarCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
        [self setupBorder];
    }
    return self;
}

- (void)setupImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _imageView.layer.cornerRadius = BORDER_RADIUS;
    _imageView.clipsToBounds = YES;
    [self setBackgroundView:_imageView];
}

- (void)setupBorder {
    self.contentView.layer.borderWidth = BORDER_WIDTH;
    self.contentView.layer.cornerRadius = BORDER_RADIUS;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.image = nil;
}

@end