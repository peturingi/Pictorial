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
            [self setup];
        }
        else {
            // TODO handle errors, possibly by returning nil or requesting users to use camera if available.
        }
    }
    NSAssert(self, @"init failed.");
    return self;
}

- (void)dealloc {
    _cameraUI = nil;
}

+ (BOOL)isAvailable
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setup
{
    _cameraUI = [[UIImagePickerController alloc] init];
    _cameraUI.delegate = self;
    _cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    _cameraUI.allowsEditing = YES;
}

- (void)show
{
    NSAssert(self.delegate, @"The delegate has not been set.");
    [self.delegate presentViewController:self.cameraUI animated:YES completion:nil];
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
        
        photo = editedImage ? editedImage : originalImage;
    }
    [self dismiss];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismiss];
}

#pragma mark - Code

- (void)dismiss
{
    [self.delegate dismissViewControllerAnimated:YES completion:^{
        if (photo) {
            [self.delegate cameraDisappearedAfterSnappingPhoto:self];
        }
        [self.delegate cameraDisappearedWithoutSnappingPhoto:self];
    }];
}

- (UIImage *)develop
{
    NSAssert(photo, @"Trying to develop a nonexcisting photo.");
    return photo;
}

@end