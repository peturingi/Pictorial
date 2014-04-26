#import <UIKit/UIKit.h>
#import "Pictogram.h"
#import "Camera.h"

@interface ContainerViewController : UIViewController <CameraDelegate> {
    UILongPressGestureRecognizer *_topViewGestureRecognizer;
    UILongPressGestureRecognizer *_bottomViewGestureRecognizer;
    Camera *_camera;
    
    UIView *_viewFollowingFinger;
    Pictogram *_pictogramBeingDragged;
    CGRect _originOfTouchedPictogram;
    __weak IBOutlet UISegmentedControl *dayWeekSegment;
    
    
    __weak IBOutlet NSLayoutConstraint *heightOfBottomView;
}

/** Container view for the calendar. */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** Container view for the pictogram selector. */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end