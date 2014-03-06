#import <UIKit/UIKit.h>
#import "CameraDelegate.h"

@interface Camera : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    __strong UIImage *lastPhotoCaptured;
}

@property (weak, nonatomic) id<CameraDelegate> delegate;
@property (weak, nonatomic) UIViewController *controller;

/** Creates a camera.
 @param controller The viewcontroller responsible for presenting the camera.
 @param delegate The camears delegate.
 @return A camera if if the hardware has one.
 @return nil if the hardware does not have a camera.
 */
- (id)initWithViewController:(UIViewController *)controller usingDelegate:(id<CameraDelegate>)delegate;

/** Show the camera
 @return YES if an attempt was made to show the camera.
 @return NO if camera is not available.
 */
- (BOOL)show;

- (void)hide;

/** Develops the photo contained within the camera.
 @return photo if the camera contains a photo.
 @return nil if no photo is contained in the camera.
 @warning Developing a photo removes it from the camera.
 */
- (UIImage *)developPhoto;

+ (BOOL)isAvailable;

@end

