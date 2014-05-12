#import "ContainerViewController+Camera.h"
#import "CreatePictogram.h"

@implementation ContainerViewController (Camera)
@dynamic camera;

- (void)setupCamera {
    _camera = [[Camera alloc] initWithViewController:self usingDelegate:self];
}

- (void)showCamera {
    [self setupCamera];
    
    BOOL success = [_camera show];
    if (!success) {
        [self alertUserCameraIsNotAvailable];
    }
}

#pragma mark Delegate

- (void)cameraDidSnapPhoto:(Camera *)aCamera {
    [self showCreatePictogramView];
}

- (void)showCreatePictogramView {
    NSAssert(_camera, @"The camera must not be nil.");
    CreatePictogram *viewController = [[CreatePictogram alloc] init];
    viewController.photo = [_camera developPhoto];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:viewController animated:YES completion:^{
        _camera = nil;
    }];
}

- (void)alertUserCameraIsNotAvailable {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The camera is unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
