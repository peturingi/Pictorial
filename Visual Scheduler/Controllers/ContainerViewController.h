#import <UIKit/UIKit.h>
#import "../Camera.h"

@interface ContainerViewController : UIViewController <CameraDelegate> {
    UILongPressGestureRecognizer *topViewGestureRecognizer;
    UILongPressGestureRecognizer *bottomViewGestureRecognizer;
    BOOL isShowingBottomView;
    Camera *camera;
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end