#import "MasterViewController.h"
#import "CreatePictogram.h"
#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CameraPicker.h"
#import "AlbumPicker.h"
#import "ImageSourceTableViewController.h"

@implementation MasterViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_NEW_PICTOGRAM]) {
        CreatePictogram * const destinationController = segue.destinationViewController;
        
        if (picker) {
            destinationController.photo = picker.image;
            picker = nil; // Free the camera
        }
        else { @throw [NSException exceptionWithName:@"Picker now found." reason:@"picker was nil." userInfo:nil]; }
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
    
    if ([segue.identifier isEqualToString:@"SEGUE_IMAGE_SOURCE"]) {
        ImageSourceTableViewController * const destination = segue.destinationViewController;
        destination.delegate = self;
    }
}

- (void)dealloc {
    picker = nil;
    _idOfPictogramBeingMoved = nil;
}

#pragma mark - Import Image

- (void)showCameraPicker
{
    [self showPicker:[CameraPicker class]];
}

- (void)showAlbumPicker
{
    [self showPicker:[AlbumPicker class]];
}

- (void)showPicker:(Class)pickerClass {
    NSAssert([pickerClass isSubclassOfClass:[Picker class]], @"Invalid class.");
    picker = [[pickerClass alloc] init];
    picker.delegate = self;
    [picker show];
}

- (void)pickerDisappearedWithoutPickingPhoto:(Picker *)sender
{
    picker = nil;
}

- (void)pickerDisappearedAfterPickingPhoto:(Picker * )sender
{
    [self performSegueWithIdentifier:SEGUE_NEW_PICTOGRAM sender:nil];
}

#pragma mark - Touching

#pragma mark Bottom View

- (void)selectedPictogramToAdd:(NSManagedObjectID * const)pictogramIdentifier
                    atLocation:(CGPoint const)location
                    relativeTo:(UIView *)view
{
    UIImage * const image = [self imageForPictogramWithID:pictogramIdentifier]; // TODO resize the image. No need to move a full size image around.
    CGPoint const targetLocation = [self.view convertPoint:location fromView:view];
    
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

- (void)itemMovedTo:(CGPoint const)point relativeTo:(UIView *)view
{
    const CGPoint locationInView = [self.view convertPoint:point fromView:view];
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

/**
 Handles the notification of an item drop (after dragging).
 Users drop items (pictograms) on a schedule where they are to be added.
 @param location The location where the pictogram was dropped.
 @param view The view to which the location is relative.
 */
- (void)itemDroppedAt:(CGPoint)location relativeTo:(UIView * const)view
{
    NSAssert(view, @"The view must not be empty.");
    
    BOOL const wasAdded = [_topViewController addPictogramWithID:_idOfPictogramBeingMoved
                                                        atPoint:location
                                                  relativeToView:view];
    if (wasAdded) [_pictogramBeingMoved removeFromSuperview];
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