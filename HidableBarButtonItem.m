#import "HidableBarButtonItem.h"

@implementation HidableBarButtonItem

- (void)setHidden:(BOOL const)hidden {
    _hidden = hidden;
    
    self.enabled = hidden ? YES : NO;
    self.tintColor = hidden ? [UIApplication sharedApplication].keyWindow.tintColor : [UIColor clearColor];
}

@end
