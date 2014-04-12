#import "CalendarCell.h"

@implementation CalendarCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self setBackgroundView:_imageView];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.image = nil;
}

@end