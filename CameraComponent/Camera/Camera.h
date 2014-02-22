//
//  Camera.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraDelegate.h"


@interface Camera : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    /** The last photo taken.
     */
    __strong UIImage *_lastPhoto;
}

@property (weak, nonatomic, readonly) id<CameraDelegate> delegate;
@property (weak, nonatomic, readonly) UIViewController *controller;

/** Creates a camera.
 @param controller The viewcontroller responsible for presenting the camera.
 @param delegate The camears delegate.
 @return A camera if if the hardware has one.
 @return nil if the hardware does not have a camera.
 */
- (id)initWithViewController:(UIViewController *)controller usingDelegate:(id)delegate;

/** Show the camera
 @return YES if an attempt was made to show the camera.
 @return NO if camera is not available.
 */
- (BOOL)show;

/** Hide the camera
 */
- (void)hide;

/** Develops the photo contained within the camera.
 @return photo if the camera contains a photo.
 @return nil if no photo is contained in the camera.
 @warning Developing a photo removes it from the camera.
 */
- (UIImage *)developPhoto;

#pragma mark - Class Methods
/** Is the camera device available?
 @return YES The device is available, else NO.
 */
+ (BOOL)isAvailable;

@end

