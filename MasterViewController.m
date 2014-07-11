#import "MasterViewController.h"

@implementation MasterViewController

- (void)cameraDidDisappear:(Camera *)camera {
    
}

- (void)cameraDidSnapPhoto:(Camera *)camera {
    [self performSegueWithIdentifier:@"newPictogram" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newPictogram"]) {
        id newPictogram = segue.destinationViewController;
        [newPictogram setValue:self.camera.developPhoto forKeyPath:@"photo"]; // UGly, fix!
        
    }
}

@end