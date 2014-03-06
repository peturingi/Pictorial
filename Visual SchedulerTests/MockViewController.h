#import <UIKit/UIKit.h>

@interface MockViewController : UIViewController {
    BOOL BBA_wasAskedToPresentViewController;
    BOOL BBA_wasAskedToDismissViewController;
}

- (BOOL)wasAskedToPresentViewController;
- (BOOL)wasAskedToDismissViewController;

@end
