#import "CameraPicker.h"
#import "Picker+Protected.h"

@implementation CameraPicker

- (id)init
{
    self = [super initWithImagePickerControllerSourceType:UIImagePickerControllerSourceTypeCamera];
    return self;
}

@end
