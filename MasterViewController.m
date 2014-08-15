#import "MasterViewController.h"
#import "CreatePictogram.h"
#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CameraPicker.h"
#import "AlbumPicker.h"
#import "ImageSourceTableViewController.h"
#import "Pictogram.h"

@implementation MasterViewController

- (void)viewDidLoad {
    [self downButton:nil];
}

/* Most of these are executed when view is created and loads.*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_NEW_PICTOGRAM]) {
        CreatePictogram * const destinationController = segue.destinationViewController;
        
        if (picker) {
            destinationController.photo = picker.image;
            picker = nil;
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
        ScheduleCollectionViewController * const destination = segue.destinationViewController;
        destination.delegate = self;
        _topViewController = destination;
        
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

- (void)showCameraPicker {
    [self showPicker:[CameraPicker class]];
}

- (void)showAlbumPicker {
    [self showPicker:[AlbumPicker class]];
}

- (void)showPicker:(Class)pickerClass {
    NSAssert([pickerClass isSubclassOfClass:[Picker class]], @"Invalid class.");
    picker = [[pickerClass alloc] init];
    picker.delegate = self;
    [picker show];
}

- (void)pickerDisappearedWithoutPickingPhoto:(Picker *)sender {
    picker = nil;
}

- (void)pickerDisappearedAfterPickingPhoto:(Picker * )sender {
    [self performSegueWithIdentifier:SEGUE_NEW_PICTOGRAM sender:nil];
    // TODO merge into pickerDisappeared which returns a photo. Then check if photo is nil and perform segue.
}

#pragma mark - Touching

- (void)selectedPictogramToAdd:(NSManagedObjectID *)pictogramIdentifier fromRect:(CGRect const)rect atLocation:(CGPoint)location relativeTo:(UIView *)view {
    _idOfPictogramBeingMoved = pictogramIdentifier;
    
    /* Animate the selected pictogram, to the finger. Resize it if needed.*/
    // Compute frames
    CGPoint const touchLocation = [self.view convertPoint:location fromView:view];
    CGRect const source = [self.view convertRect:rect fromView:view];
    CGRect const destination = CGRectMake(touchLocation.x-PICTOGRAM_SIZE_WHILE_DRAGGING/2, touchLocation.y-PICTOGRAM_SIZE_WHILE_DRAGGING/2, PICTOGRAM_SIZE_WHILE_DRAGGING, PICTOGRAM_SIZE_WHILE_DRAGGING);
    // Add as subview
    // TODO resize the image. No need to move a full size image around.
    UIImage * const image = ((Pictogram *)[[self appDelegate] objectWithID:pictogramIdentifier]).uiImage;
    PictogramView * const pictogramView = [[PictogramView alloc] initWithFrame:source andImage:image];
    _pictogramBeingMoved = pictogramView;
    [self.view addSubview:pictogramView];
    // Animate
    [UIView animateWithDuration:ANIMATION_DURATION_MOVE_TO_FINGER_ON_SELECTION animations:^(void){
        _pictogramBeingMoved.frame =  destination;
    }];
}

#pragma mark Moving in Bottom View

- (void)pictogramBeingDraggedMovedToPoint:(CGPoint const)point relativeToView:(UIView *)view
{
    const CGPoint locationInView = [self.view convertPoint:point fromView:view];
    _pictogramBeingMoved.frame = [PictogramView frameAtPoint:locationInView];
}

#pragma mark Dropping from Bottom View

/**
 Deal with what should happen when user drops an item (after dragging).
 Users drop items (pictograms) on a schedule where they are to be added.
 @param location The location where the pictogram was dropped.
 @param view The view to which the location is relative.
 @return YES Pictogram was added.
 @return NO Pictogram was not added.
 */
- (BOOL)handleAddPictogramToScheduleAtPoint:(CGPoint)location relativeToView:(UIView * const)view
{
    NSAssert(view, @"The view must not be empty.");
    
    BOOL const wasAdded = [_topViewController addPictogramWithID:_idOfPictogramBeingMoved
                                                        atPoint:location
                                                  relativeToView:view];
    if (wasAdded) {
        [_pictogramBeingMoved removeFromSuperview];
    }
    else {
        [self animatePictogramBackToOriginalPosition];
    }
    return wasAdded;
}

- (void)animatePictogramBackToOriginalPosition {
    [_pictogramBeingMoved removeFromSuperview]; // TODO animate , currently this removes it immadiately instead of animating.
}

#pragma mark Top View

- (void)pictogramDraggingCancelled {
    [_pictogramBeingMoved removeFromSuperview]; // TODO maby call animatePictogramToOriginalPosition instead.
}

#pragma mark - Change View Modes

- (IBAction)showDayView:(id)sender {
    [_topViewController switchToDayLayout];
}

- (IBAction)showWeekView:(id)sender {
    [_topViewController switchToWeekLayout];
}


#pragma mark - 

- (AppDelegate *)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}
- (IBAction)downButton:(id)sender {
    [_topViewController setEditing:NO];
    [self hideImportPhotosButton];
    [self hideHidePictogramSelectorButton];
    [self showShowPictogramSelectorButton];
    [self setHeightOfPictogramSelector:0];
}
- (IBAction)upButton:(id)sender {
    [_topViewController setEditing:YES];
    [self showHidePictogramSelectorButton];
    [self hideShowPictogramSelectorButton];
    [self showImportPhotosButton];
    [self setHeightOfPictogramSelector:floor(self.view.frame.size.height / 3.0f)];
}

- (void)setHeightOfPictogramSelector:(CGFloat const)height {
    [self.view layoutIfNeeded];
    bottomViewHeight.constant = height;
    [self.view layoutIfNeeded];
}

- (void)showImportPhotosButton { importPhotosButton.enabled = YES; }
- (void)hideImportPhotosButton { importPhotosButton.enabled = NO; }

- (void)showShowPictogramSelectorButton { showPictogramSelectorButton.enabled = YES; }
- (void)hideShowPictogramSelectorButton { showPictogramSelectorButton.enabled = NO; }

- (void)showHidePictogramSelectorButton { hidePictogramSelectorButton.enabled = YES; }
- (void)hideHidePictogramSelectorButton { hidePictogramSelectorButton.enabled = NO; }

@end
