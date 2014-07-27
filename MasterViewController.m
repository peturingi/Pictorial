#import "MasterViewController.h"
#import "CreatePictogram.h"
#import "PictogramSelectorViewController.h"

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
    
    // Set self as the pictogram selectors delegate.
    if ([segue.identifier isEqualToString:@"SEGUE_EMBED_PICTORAM_SELECTOR"]) {
        PictogramSelectorViewController *destination = segue.destinationViewController;
        destination.delegate = self;
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

#pragma mark Touching

- (void)selectedPictogramToAdd:(NSManagedObjectID *)pictogramIdentifier {
    NSLog(@"Selected to add: %@", pictogramIdentifier);
    
    NSLog(@"Animate pictogram to finger.");
    
    NSLog(@"Make Pictogram follow finger.");
}

- (void)itemMovedTo:(CGPoint)point {
    NSLog(@"Current location (x,y): %f,%f", point.x, point.y);
}

- (void)itemSelectionEnded {
    NSLog(@"Add pictogram to location when released.");
}

@end