#import "BottomViewPictogram.h"

@implementation BottomViewPictogram

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.title.hidden = highlighted;
    
    self.deleteButton.enabled = highlighted;
    self.deleteButton.hidden = !highlighted;
    
    self.modifyButton.enabled = highlighted;
    self.modifyButton.hidden = !highlighted;
}

@end
