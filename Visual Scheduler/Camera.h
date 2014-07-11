#import <UIKit/UIKit.h>
#import "CameraDelegate.h"

@interface Camera : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    __strong UIImage *lastPhotoCaptured;
}

@property IBOutlet UIViewController <CameraDelegate> *delegate;

/** Show the camera
*/
- (IBAction)show:(id)sender;

- (void)hide;

/** Develops the photo contained within the camera.
 @return photo if the camera contains a photo.
 @return nil if no photo is contained in the camera.
 @warning Developing a photo removes it from the camera.
 */
- (UIImage *)developPhoto;

+ (BOOL)isAvailable;

@end

