#import "MasterViewController.h"
#import "CreatePictogram.h"
#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#define PICTOGRAM_EDGE  100

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

- (void)selectedPictogramToAdd:(NSManagedObjectID *)pictogramIdentifier atLocation:(CGPoint)location{
    NSLog(@"Selected to add: %@", pictogramIdentifier);
    
    //Get image of pictogram which was selected
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSManagedObject *managedObject = [managedObjectContext objectWithID:pictogramIdentifier];
    NSData *imageData = [managedObject valueForKey:CD_KEY_PICTOGRAM_IMAGE];
    UIImage *image = [UIImage imageWithData:imageData];
    
    //Construct view containing the image of the pictogram and show it
    CGPoint locationInView = [self.view convertPoint:location fromView:bottomView];
    PictogramView *pictogramView = [[PictogramView alloc] initWithFrame:[self frameForPictogramAtPoint:locationInView] andImage:image];
    pictogramView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pictogramView];
    pictogramBeingMoved = pictogramView;
}

- (void)itemMovedTo:(CGPoint)point {
    NSLog(@"Make Pictogram follow finger.");
    CGPoint locationInView = [self.view convertPoint:point fromView:bottomView];
    pictogramBeingMoved.frame = [self frameForPictogramAtPoint:locationInView];
}

- (void)itemSelectionEnded {
    // TODO Add pictogram to location when released.
    [pictogramBeingMoved removeFromSuperview];
}

- (CGRect)frameForPictogramAtPoint:(CGPoint)aPoint {
    return CGRectMake(aPoint.x - PICTOGRAM_EDGE/2.0f, aPoint.y - PICTOGRAM_EDGE/2.0f, PICTOGRAM_EDGE, PICTOGRAM_EDGE);
}

@end