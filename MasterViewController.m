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
    
    // Know the top views controller
    if ([segue.identifier isEqualToString:@"SEGUE_EMBED_TOPVIEW"]) {
        _topViewController = segue.destinationViewController;
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
    _idOfPictogramBeingMoved = pictogramIdentifier;
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

- (void)itemSelectionEndedAtLocation:(CGPoint)location
{
    BOOL const pictogramWasAdded = [_topViewController addPictogramWithID:_idOfPictogramBeingMoved
                                                                  atPoint:[_topViewController.collectionView convertPoint:location
                                                                                                                 fromView:bottomView]];
    if (pictogramWasAdded) [_pictogramBeingMoved removeFromSuperview];
    else [self animatePictogramBackToOriginalPosition];
}

- (void)animatePictogramBackToOriginalPosition {
    [_pictogramBeingMoved removeFromSuperview]; // TODO animate , currently this removes it immadiately instead of animating.
}

#pragma mark Top View

- (BOOL)locationIsASchedule:(CGPoint const)location {
    
    /** TODO
     Currently checks if dropped over another pictogram.
     It should check if dropped in a valid schedule, as it is possible that
     the user drops between two pictograms, in case the current code would
     not insert the dropped pictogram into the schedule.
     */
    NSIndexPath * const pathToItemAtLocation = [_topViewController.collectionView indexPathForItemAtPoint:location];
    NSLog(@"%@", pathToItemAtLocation);
    return pathToItemAtLocation != nil ? YES : NO;
}

@end