#import "MockCameraDelegate.h"

@implementation MockCameraDelegate

- (BOOL)receivedCameraDidAppear {
    return receivedCameraDidAppear;
}

- (void)cameraDidAppear:(Camera *)camera {
    receivedCameraDidAppear = YES;
}

@end
