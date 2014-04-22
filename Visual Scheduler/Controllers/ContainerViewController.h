#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController {
    UILongPressGestureRecognizer *topViewGestureRecognizer;
    UILongPressGestureRecognizer *bottomViewGestureRecognizer;
    BOOL isShowingBottomView;
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end