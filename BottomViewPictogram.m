#import "BottomViewPictogram.h"

@implementation BottomViewPictogram

- (void)showControls:(BOOL)truthValue {
    self.title.hidden = truthValue;
    
    self.deleteButton.enabled = truthValue;
    self.deleteButton.hidden = !truthValue;
    
    self.modifyButton.enabled = truthValue;
    self.modifyButton.hidden = !truthValue;
    [self setNeedsDisplay];
}

@end
