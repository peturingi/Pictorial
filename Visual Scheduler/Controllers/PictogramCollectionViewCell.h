#import <UIKit/UIKit.h>
#import "Pictogram.h"

@interface PictogramCollectionViewCell : UICollectionViewCell {
    IBOutlet UIImageView *imageView;
}
@property (strong, nonatomic) Pictogram *pictogram;
@end
