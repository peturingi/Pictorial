#import <UIKit/UIKit.h>

@interface BBANewPictogramViewController : UIViewController {
    __weak IBOutlet UIImageView *photoView;
    __weak IBOutlet UITextField *photoTitle;
}

@property (weak, nonatomic) UIImage *photo;

@end
