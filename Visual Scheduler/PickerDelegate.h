#import <Foundation/Foundation.h>

@class Picker;

@protocol PickerDelegate <NSObject>

@optional
- (void)pickerDisappearedWithoutPickingPhoto:(Picker *)picker;
- (void)pickerDidAppear:(Picker *)picker;
- (void)pickerDisappearedAfterPickingPhoto:(Picker *)picker;

@end
