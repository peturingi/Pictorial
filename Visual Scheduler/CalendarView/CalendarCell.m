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
    self.contentView.layer.borderWidth = 2.0f;
    self.contentView.layer.cornerRadius = 5.0f;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.image = nil;
}

@end