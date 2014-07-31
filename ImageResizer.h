#import <UIKit/UIKit.h>

/** Creates a new image, resized to a given size.
 */
@interface ImageResizer : NSObject

@property UIImage *image;

- (id)initWithImage:(UIImage *)anImage;
- (UIImage *)getImageResizedTo:(CGSize)size;

@end
