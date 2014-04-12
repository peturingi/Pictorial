#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupImageView];
    [self setupBorder];
}

- (void)setupImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self setBackgroundView:_imageView];
}

- (void)setupBorder {
    self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
    self.contentView.layer.borderWidth = 1.0f;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
