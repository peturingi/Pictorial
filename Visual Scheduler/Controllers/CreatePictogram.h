#import <UIKit/UIKit.h>

@interface CreatePictogram : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *photoTitle;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@property (weak, nonatomic) UIImage *photo;
@property (weak, nonatomic) id delegate;

@end
