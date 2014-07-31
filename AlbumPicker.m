#import "AlbumPicker.h"
#import "Picker+Protected.h"

@implementation AlbumPicker

- (id)init
{
    self = [super initWithImagePickerControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    return self;
}

@end
