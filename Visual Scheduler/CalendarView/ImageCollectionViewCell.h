#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

- (id)init __unavailable;
- (id)initWithFrame:(CGRect)frame __unavailable;
@end
