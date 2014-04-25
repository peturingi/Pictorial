#import "ContainerViewController.h"
#import "Camera.h"
@interface ContainerViewController (Camera) <CameraDelegate>

@property (strong, nonatomic) Camera *camera;

@end
