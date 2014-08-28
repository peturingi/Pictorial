#import "HidableBarButtonItem.h"

@implementation HidableBarButtonItem

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)setHidden:(BOOL const)hidden {
    _hidden = hidden;
    
    self.enabled = hidden ? YES : NO;
    self.tintColor = hidden ? [UIApplication sharedApplication].keyWindow.tintColor : [UIColor clearColor];
}

@end
