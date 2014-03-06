#import "MockViewController.h"

@implementation MockViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    BBA_wasAskedToPresentViewController = YES;
}

- (BOOL)wasAskedToPresentViewController {
    return BBA_wasAskedToDismissViewController;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    BBA_wasAskedToDismissViewController = YES;
}
- (BOOL)wasAskedToDismissViewController {
    return BBA_wasAskedToDismissViewController;
}



@end
