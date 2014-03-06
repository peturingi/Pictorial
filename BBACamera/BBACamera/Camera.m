#import "Camera.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface Camera ()
    @property (strong, nonatomic) UIImagePickerController *cameraUI;
@end

@implementation Camera

- (id)init {
    return [self initWithViewController:nil usingDelegate:nil];
}

- (id)initWithViewController:(UIViewController *)controller usingDelegate:(id)delegate {
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
    return self;
}

- (void)configureCamera {
    _cameraUI = [[UIImagePickerController alloc] init];
    _cameraUI.delegate = self;
    _cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    _cameraUI.allowsEditing = YES;
}

- (BOOL)show {
    if ([Camera isAvailable]) {
        [self.controller presentViewController:self.cameraUI animated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(cameraDidAppear:)]) {
                [self.delegate cameraDidAppear:self];
            }
        }];
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
    UIImage *editedImage;
    UIImage *originalImage;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage , 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        lastPhotoCaptured = editedImage ? editedImage : originalImage;
    }
    [self hide];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self deletePreviouslyCapturedPhoto];
    [self hide];
}

- (void)deletePreviouslyCapturedPhoto {
    lastPhotoCaptured = nil;
}

#pragma mark - Code

- (void)hide {
    [self.controller dismissViewControllerAnimated:YES completion:^{
        if (lastPhotoCaptured) {
            if ([self.delegate respondsToSelector:@selector(cameraDidSnapPhoto:)]) {
                [self.delegate cameraDidSnapPhoto:self];
            }
        }
        if ([self.delegate respondsToSelector:@selector(cameraDidDisappear:)]) {
            [self.delegate cameraDidDisappear:self];
        }
    }];
}

- (UIImage *)developPhoto {
    UIImage *photo = lastPhotoCaptured;
    lastPhotoCaptured = nil;
    return photo;
}

- (void)setDelegate:(id<CameraDelegate>)delegate {
    if (delegate && ![delegate conformsToProtocol:@protocol(CameraDelegate)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"Delegate object does not conform to the delegate protocol"
                               userInfo:nil] raise];
    }
    _delegate = delegate;
}

@end