#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController {
    UILongPressGestureRecognizer *topViewGestureRecognizer;
    UILongPressGestureRecognizer *bottomViewGestureRecognizer;
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end