#import "PictogramView.h"

#define ASSERT_DEPRECATED NSAssert(nil, @"Deprecated, use initWithFrame:andImage:")

@implementation PictogramView

- (id)init { ASSERT_DEPRECATED; return nil; }
- (id)initWithFrame:(CGRect)frame { ASSERT_DEPRECATED; return nil; }
- (id)initWithCoder:(NSCoder *)aDecoder { ASSERT_DEPRECATED; return nil; }

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)anImage;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self getAutoresizingImageViewRepresenting:anImage]];
        [self setupBorder];
    }
    NSAssert(self, @"Failed to init.");
    return self;
}

- (UIImageView *)getAutoresizingImageViewRepresenting:(UIImage *)anImage {
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
    self.clipsToBounds = YES; // The border marks the bounds.
}

@end
