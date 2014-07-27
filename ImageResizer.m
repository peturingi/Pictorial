#import "ImageResizer.h"

@implementation ImageResizer

- (id)init {
    self = [self initWithImage:nil];
    return self;
}

- (id)initWithImage:(UIImage *)anImage {
    self = [super init];
    
    if (self) {
        _image = anImage;
    }
    
    NSAssert(self, @"Super failed to init.");
    return self;
}

- (void)dealloc {
    _image = nil;
}

- (UIImage *)getImageResizedTo:(CGSize)size {
    if (self.image == nil) return nil;
    
    const CGFloat currentScalingFactor = 0.0f;
    UIGraphicsBeginImageContextWithOptions(size, NO, currentScalingFactor);
    [self.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
