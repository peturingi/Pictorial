#import <Foundation/Foundation.h>

@class Camera;

@protocol CameraDelegate <NSObject>

@optional
- (void)cameraDidDisappear:(Camera *)camera;
- (void)cameraDidAppear:(Camera *)camera;
- (void)cameraDidSnapPhoto:(Camera *)camera;

@end
