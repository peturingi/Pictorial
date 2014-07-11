#import "Camera.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface Camera ()
    @property (strong, nonatomic) UIImagePickerController *cameraUI;
@end

@implementation Camera

- (id)init
{
    self = [super init];
    if (self) {
        if ([Camera isAvailable]) {
            [self configureCamera];
        }
    }
    NSAssert(self, @"init failed.");
    return self;
}

- (void)configureCamera
{
    _cameraUI = [[UIImagePickerController alloc] init];
    _cameraUI.delegate = self;
    _cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    _cameraUI.allowsEditing = YES;
}

- (IBAction)show:(id)sender
{
    if ([Camera isAvailable]) {
        NSAssert(self.delegate, @"The delegate has not been set.");
        [self.delegate presentViewController:self.cameraUI animated:YES completion:nil];
    }
}

+ (BOOL)isAvailable
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self deletePreviouslyCapturedPhoto];
    [self hide];
}

- (void)deletePreviouslyCapturedPhoto
{
    lastPhotoCaptured = nil;
}

#pragma mark - Code

- (void)hide
{
    [self.delegate dismissViewControllerAnimated:YES completion:^{
        if (lastPhotoCaptured) {
            [self.delegate cameraDidSnapPhoto:self];
        }
        [self.delegate cameraDidDisappear:self];
    }];
}

- (UIImage *)developPhoto
{
    UIImage *photo = lastPhotoCaptured;
    lastPhotoCaptured = nil;
    return photo;
}

@end