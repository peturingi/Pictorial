#import "MockCameraDelegate.h"

@implementation MockCameraDelegate

- (BOOL)receivedCameraDidAppear {
    return receivedCameraDidAppear;
}

- (void)pickerDidAppear:(CameraPicker *)camera {
    receivedCameraDidAppear = YES;
}

@end
