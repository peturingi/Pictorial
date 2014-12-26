#import <UIKit/UIKit.h>

@interface CreatePictogram : UIViewController

/** Input for Title */
@property (weak, nonatomic) IBOutlet UITextField *photoTitle;

/** Holds photo of pictogram to be added */
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

/** Photo of pictogram to be added */
@property (strong, nonatomic) UIImage *photo;

@property (weak, nonatomic) id delegate;

@end