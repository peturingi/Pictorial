#import <UIKit/UIKit.h>
#import "../Camera.h"

@interface ContainerViewController : UIViewController <CameraDelegate> {
    UILongPressGestureRecognizer *topViewGestureRecognizer;
    UILongPressGestureRecognizer *bottomViewGestureRecognizer;
    BOOL isShowingBottomView;
    Camera *camera;
}

/** Container view for the calendar. */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** Container view for the pictogram selector. */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end