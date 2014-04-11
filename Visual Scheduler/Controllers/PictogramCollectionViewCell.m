#import "PictogramCollectionViewCell.h"

@implementation PictogramCollectionViewCell

- (void)setPictogram:(Pictogram *)pictogram {
    imageView.image = pictogram.image;
}

@end
