#import <UIKit/UIKit.h>
#import "PickerDelegate.h"

/**
 Abstract Class.
 */
@interface Picker : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImagePickerControllerSourceType _source;
}

@property (weak, nonatomic) UIViewController <PickerDelegate> *delegate;

/*
 Class protected methods are defined in a class extension.
 */

- (void)show;
- (void)dismiss;

/** Returns the last picked image.
 */
- (UIImage *)image;

@end
