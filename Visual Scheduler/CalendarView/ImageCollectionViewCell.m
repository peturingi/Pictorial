#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (void)prepareForReuse {
    [self.imageView setImage:nil];
}

@end
