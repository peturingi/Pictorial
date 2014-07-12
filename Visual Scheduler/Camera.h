#import <UIKit/UIKit.h>
#import "CameraDelegate.h"

@interface Camera : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    __strong UIImage *photo;
}

@property IBOutlet UIViewController <CameraDelegate> *delegate;

/** Show the camera
*/
- (void)show;

- (void)dismiss;

/** Develops the photo contained within the camera.
 @return photo if the camera contains a photo.
 @return nil if no photo is contained in the camera.
 @warning Developing a photo removes it from the camera.
 */
- (UIImage *)develop;

+ (BOOL)isAvailable;

@end

