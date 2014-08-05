#import <UIKit/UIKit.h>

@interface CalendarCell : UICollectionViewCell

@property IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end