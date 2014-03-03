#import <UIKit/UIKit.h>
#import "../../CameraComponent/Camera/CameraDelegate.h"

@interface BBAAddScheduleViewController : UIViewController <CameraDelegate> {
    __weak IBOutlet UISwitch *showTitle;
    __weak IBOutlet UISwitch *showSteps;
    __weak IBOutlet UIView *backgroundColor;
    __weak IBOutlet UITextField *schedulesTitle;
}

@end
