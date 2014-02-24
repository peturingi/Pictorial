//
//  Camera.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "Camera.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface Camera ()
    @property (strong, nonatomic) UIImagePickerController *cameraUI;
@end

@implementation Camera

- (id)initWithViewController:(UIViewController *)controller usingDelegate:(id)delegate {
    NSAssert(controller, @"Must not be nil!");
    NSAssert(delegate, @"Must not be nil!");
    
    self = [super init];
    if (self) {
        if ([Camera isAvailable]) {
            _delegate = delegate;
            _controller = controller;
            [self configureCamera];
        } else {
            return nil;
        }
    }
    
    /* Post */
    NSAssert(_delegate, @"Must not be nil.");
    NSAssert(_controller, @"Must not be nil.");
    return self;
}

- (void)configureCamera {
    /* Pre */
    NSAssert([Camera isAvailable], @"Camera is not available. Cannot configure!");
    
    _cameraUI = [[UIImagePickerController alloc] init];
    _cameraUI.delegate = self;
    _cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    _cameraUI.allowsEditing = YES;
    
    /* Post */
    NSAssert(self.cameraUI, @"Must not be nil!");
}

- (BOOL)show {
    NSAssert(self.delegate, @"Must not be nil!");
    
    if ([Camera isAvailable]) {
        // Asks the controller to show the camera and inform the delegate after it has appeared.
        [self.controller presentViewController:self.cameraUI animated:YES completion:^{[self.delegate cameraAppeared];}];
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isAvailable {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSAssert(picker, @"Must not be nil!");
    NSAssert(info, @"Must not be nil!");
    
    UIImage *editedImage;
    UIImage *originalImage;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // If a photo was taken.
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage , 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        // Override a previous photo if it has not been developed.
        lastPhotoCaptured = editedImage ? editedImage : originalImage;
        NSAssert(lastPhotoCaptured, @"Must not be nil!");
        
        [self.delegate cameraSnappedPhoto];
    }
    [self hide];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSAssert(self.controller, @"Must not be nil!");
    [self hide];
}

#pragma mark - Code

- (void)hide {
    NSAssert(self.controller, @"Can not find the controller responsible for hiding the camera.");
    
    // Asks the controller to hide the camera and informs the delegate when it has disappeared.
    [self.controller dismissViewControllerAnimated:YES completion:^{[self.delegate cameraDidDisappear];}];
}

- (UIImage *)developPhoto {
    UIImage *photo = lastPhotoCaptured;
    lastPhotoCaptured = nil;
    return photo;
}

@end