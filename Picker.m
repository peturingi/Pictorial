#import "Picker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Picker+Protected.h"

@interface Picker ()

@property (strong, nonatomic) UIImagePickerController *cameraUI;
@property (strong, nonatomic) UIImage *image;

@end

@implementation Picker

- (id)init {
    NSAssert(false, @"This is an abstract method.");
    return nil;
}

- (id)initWithImagePickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType
{
    self = [super init];
    if (self) {
        self.source = sourceType;
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.cameraUI = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImage;
    UIImage *originalImage;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage , 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self setImage:editedImage ? editedImage : originalImage];
    }
    [self dismiss];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismiss];
}

- (void)dismiss
{
    [self.delegate dismissViewControllerAnimated:YES completion:^{
        if (self.image) {
            [self.delegate pickerDisappearedAfterPickingPhoto:self];
        }
        [self.delegate pickerDisappearedWithoutPickingPhoto:self];
    }];
}

- (UIImage *)image
{
    return _image;
}

- (BOOL)isAvailable
{
    if ([UIImagePickerController isSourceTypeAvailable:self.source]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setup
{
    self.cameraUI = [[UIImagePickerController alloc] init];
    self.cameraUI.delegate = self;
    self.cameraUI.sourceType = self.source;
    self.cameraUI.allowsEditing = YES;
}

- (void)show
{
    NSAssert(self.delegate, @"The delegate has not been set.");
    [self.delegate presentViewController:self.cameraUI animated:YES completion:nil];
}

#pragma mark - Getters and Setters

- (void)setSource:(UIImagePickerControllerSourceType)source {
    _source = source;
}

- (UIImagePickerControllerSourceType)source {
    return _source;
}

@end
