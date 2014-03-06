#import <Foundation/Foundation.h>
#import "CameraDelegate.h"

@interface MockCameraDelegate : NSObject <CameraDelegate> {
    BOOL receivedCameraDidAppear;
}

- (BOOL)receivedCameraDidAppear;

@end
