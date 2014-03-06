#import "MockViewController.h"

@implementation MockViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    BBA_wasAskedToPresentViewController = YES;
}

- (BOOL)wasAskedToPresentViewController {
    return BBA_wasAskedToPresentViewController;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
    BBA_wasAskedToDismissViewController = YES;
}
- (BOOL)wasAskedToDismissViewController {
    return BBA_wasAskedToDismissViewController;
}

@end
