#import "PictogramCollectionViewCell.h"

@implementation PictogramCollectionViewCell

- (void)setPictogram:(Pictogram *)pictogram {
    imageView.image = pictogram.image;
}

- (void)prepareForReuse {
    self.pictogram = nil;
    imageView.image = nil;
}

@end
