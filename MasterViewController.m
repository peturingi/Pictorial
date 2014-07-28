#import "MasterViewController.h"
#import "CreatePictogram.h"
#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@implementation MasterViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_NEW_PICTOGRAM]) {
        CreatePictogram * const destinationController = segue.destinationViewController;
        
        if (camera) {
            destinationController.photo = [camera develop];
            camera = nil; // Free the camera
        }
        else { @throw [NSException exceptionWithName:@"Camera now found." reason:@"Camera was nil." userInfo:nil]; }
    }
    
    // Set self as the pictogram selectors delegate.
    if ([segue.identifier isEqualToString:@"SEGUE_EMBED_PICTORAM_SELECTOR"]) {
        PictogramSelectorViewController * const destination = segue.destinationViewController;
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

- (void)cameraDisappearedAfterSnappingPhoto:(Camera * )sender
{
    [self performSegueWithIdentifier:SEGUE_NEW_PICTOGRAM sender:nil];
}

#pragma mark - Touching

#pragma mark Bottom View

- (void)selectedPictogramToAdd:(NSManagedObjectID * const)pictogramIdentifier atLocation:(CGPoint const)location
{
    UIImage * const image = [self imageForPictogramWithID:pictogramIdentifier]; // TODO resize the image. No need to move a full size image around.
    CGPoint const targetLocation = [self.view convertPoint:location fromView:bottomView];
    
    PictogramView * const pictogramView = [[PictogramView alloc] initWithFrame:[self frameForPictogramAtPoint:targetLocation] andImage:image];
    pictogramView.backgroundColor = [UIColor whiteColor];
    
    _pictogramBeingMoved = pictogramView;
    [self.view addSubview:pictogramView];
}

- (UIImage *)imageForPictogramWithID:(NSManagedObjectID * const)objectID
{
    return [self imageForPictogram:[self itemWithID:objectID]];
}

- (UIImage *)imageForPictogram:(NSManagedObject * const)pictogram
{
    NSData * const imageData = [pictogram valueForKeyPath:CD_KEY_PICTOGRAM_IMAGE];
    return [UIImage imageWithData:imageData];
}

- (NSManagedObject *)itemWithID:(NSManagedObjectID * const)objectID
{
    NSManagedObjectContext * const sharedContext = [self appDelegate].managedObjectContext;
    return [sharedContext objectWithID:objectID];
}

- (AppDelegate *)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

- (void)itemMovedTo:(CGPoint const)point
{
    const CGPoint locationInView = [self.view convertPoint:point fromView:bottomView];
    _pictogramBeingMoved.frame = [self frameForPictogramAtPoint:locationInView];
}

- (CGRect)frameForPictogramAtPoint:(CGPoint const)aPoint
{
    CGFloat const edgeLength = PICTOGRAM_SIZE_WHILE_DRAGGING;
    return CGRectMake(aPoint.x - edgeLength/2.0f,
                      aPoint.y - edgeLength/2.0f,
                      edgeLength,
                      edgeLength);
}

- (void)itemSelectionEnded
{
    // TODO Add pictogram to location when released.
    /**
     if pictogram location is in schedule
        find destination index in schedule
        add pictogram to destination
     else slide pictogram back
     */
    [_pictogramBeingMoved removeFromSuperview];
}

#pragma mark Top View



@end