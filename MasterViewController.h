#import "CameraDelegate.h"
#import "Camera.h"
#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController <CameraDelegate>

@property IBOutlet Camera *camera;

@end
