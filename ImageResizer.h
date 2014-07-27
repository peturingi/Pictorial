#import <UIKit/UIKit.h>

@interface ImageResizer : NSObject

@property UIImage *image;

- (id)initWithImage:(UIImage *)anImage;
- (UIImage *)getImageResizedTo:(CGSize)size;

@end
