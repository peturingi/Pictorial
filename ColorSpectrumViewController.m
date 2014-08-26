#import "ColorSpectrumViewController.h"
#import "UIView+ColorAtPoint.h"

@interface ColorSpectrumViewController ()
@property (weak, nonatomic) UIView *selectedDay;
@end

@implementation ColorSpectrumViewController

- (IBAction)daySelected:(UITapGestureRecognizer * const)sender {
    self.selectedDay = sender.view;
}
- (IBAction)colorSelected:(id)sender {
    UIGestureRecognizer *gr = sender;
    if (gr.state == UIGestureRecognizerStateBegan ||
        gr.state == UIGestureRecognizerStateChanged )
    {
        /* Prevent the gesture recognizer from moving out of the view. */
        CGPoint point = [gr locationInView:gr.view];
        CGSize const size = gr.view.bounds.size;
        if (point.x < 0) point.x = 0;
        if (point.y < 0) point.y = 0;
        if (point.x > size.width)  point.x = size.width;
        if (point.y > size.height) point.y = size.height-1; // TODO: Black color if -1 is omitted. I dont know why.
        
        self.selectedDay.backgroundColor = [gr.view colorAtPoint:point];
    }
}

@end
