#import "PictogramView.h"

@implementation PictogramView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)anImage;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self autoresizingImageViewRepresenting:anImage]];
        [self setupBorder];
    }
    NSAssert(self, @"Failed to init.");
    return self;
}

- (UIImageView *)autoresizingImageViewRepresenting:(UIImage *)anImage {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = anImage;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
    return imageView;
}

- (void)setupBorder {
    self.layer.borderWidth = PICTOGRAM_BORDER_WIDTH;
    self.layer.cornerRadius = PICTOGRAM_BORDER_RADIUS;
    self.layer.borderColor = PICTOGRAM_BORDER_COLOR;
    self.clipsToBounds = YES;
}

@end
