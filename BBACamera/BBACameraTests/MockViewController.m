#import "MockViewController.h"

@implementation MockViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    self.wasAskedToPresentViewController = YES;
}

@end
