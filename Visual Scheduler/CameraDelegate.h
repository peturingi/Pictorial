#import <Foundation/Foundation.h>

@class Camera;

@protocol CameraDelegate <NSObject>

@optional
- (void)cameraDisappearedWithoutSnappingPhoto:(Camera *)camera;
- (void)cameraDidAppear:(Camera *)camera;
- (void)cameraDisappearedAfterSnappingPhoto:(Camera *)camera;

@end
