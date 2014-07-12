#import "MasterViewController.h"
#import "CreatePictogram.h"

@implementation MasterViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_NEW_PICTOGRAM]) {
        CreatePictogram *destinationController = segue.destinationViewController;
        
        if (camera)
        {
            destinationController.photo = [camera develop];
            camera = nil; // Free the camera
        }
        else
        {
            @throw [NSException exceptionWithName:@"Camera now found." reason:@"Camera was nil." userInfo:nil];
        }
    }
}

#pragma mark Camera

- (IBAction)cameraButton:(id)sender
{
    camera = [[Camera alloc] init];
    camera.delegate = self;
    [camera show];
}

- (void)cameraDisappearedWithoutSnappingPhoto:(Camera *)sender
{
    camera = nil; // Free the camera.
}

- (void)cameraDisappearedAfterSnappingPhoto:(Camera *)sender
{
    [self performSegueWithIdentifier:SEGUE_NEW_PICTOGRAM sender:nil];
}

@end