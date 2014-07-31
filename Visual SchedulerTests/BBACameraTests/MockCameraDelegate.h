#import <Foundation/Foundation.h>
#import "CameraDelegate.h"

@interface MockCameraDelegate : NSObject <PickerDelegate> {
    BOOL receivedCameraDidAppear;
}

- (BOOL)receivedCameraDidAppear;

@end
