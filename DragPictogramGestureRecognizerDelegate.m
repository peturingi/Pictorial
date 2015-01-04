#import "DragPictogramGestureRecognizerDelegate.h"

@implementation DragPictogramGestureRecognizerDelegate

// Cancel any other gesture recognizer, so gesture do not fall through the drag pictogram gesture recognizer, into the
// collection view, causing it to scroll when the pictogram is being dragged.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    for (UIGestureRecognizer *gr in gestureRecognizer.view.gestureRecognizers) {
        if ([gr isKindOfClass:[UILongPressGestureRecognizer class]] == NO) {
            
            gr.enabled = NO;
            gr.enabled = YES;
        }
    }
    return YES;
}

// Allow another finger to be used to move a collectionview around at the same time a picotgram is being dragged.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
