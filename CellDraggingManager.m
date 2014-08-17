#import "CellDraggingManager.h"
#import <CoreData/CoreData.h>
#import "PictogramView.h"
#import "Pictogram.h"
#import "AppDelegate.h"
#import "ImageResizer.h"

@implementation CellDraggingManager

- (id)initWithSource:(UICollectionViewController *const)source andDestination:(UICollectionViewController<AddPictogramWithID> *const)destination {
    self = [super init];
    if (self) {
        _source = source;
        _destination = destination;
    }
    return self;
}

/** Pictogram Touched */
- (void)setPictogramToDrag:(NSManagedObjectID *)pictogramIdentifier fromRect:(CGRect const)rect atLocation:(CGPoint)location relativeTo:(UIView *)view {
    {
        NSAssert(_source, @"Must not be nil.");
        NSAssert(_destination, @"Must not be nil.");
        NSAssert(pictogramIdentifier, @"Must not be nil.");
        NSAssert(view, @"Must not be nil.");
    } // Assert
    self.idOfPictogramBeingMoved = pictogramIdentifier;
    
    /* Animate the selected pictogram, to the finger. Resize it if needed.*/
    
    // Add as subview
    // TODO: resize the image. No need to move a full size image around.
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    /* Resize image. Saves about 1,5 MB of RAM. */
    ImageResizer * const imageResizer = [[ImageResizer alloc] initWithImage:((Pictogram *)[delegate objectWithID:pictogramIdentifier]).uiImage];
    UIImage * const image = [imageResizer getImageResizedTo:CGSizeMake(PICTOGRAM_SIZE_WHILE_DRAGGING, PICTOGRAM_SIZE_WHILE_DRAGGING)];
    
    CGRect const source = [_source.view convertRect:rect fromView:view];
    PictogramView * const pictogramView = [[PictogramView alloc] initWithFrame:source andImage:image];
    _pictogramBeingMoved = pictogramView;
    [_source.view addSubview:pictogramView];
    
    // Animate
    CGPoint const touchLocation = [_source.view convertPoint:location fromView:view];
    CGRect const destination = CGRectMake(touchLocation.x-PICTOGRAM_SIZE_WHILE_DRAGGING/2, touchLocation.y-PICTOGRAM_SIZE_WHILE_DRAGGING/2, PICTOGRAM_SIZE_WHILE_DRAGGING, PICTOGRAM_SIZE_WHILE_DRAGGING);
    [UIView animateWithDuration:ANIMATION_DURATION_MOVE_TO_FINGER_ON_SELECTION animations:^(void){
        _pictogramBeingMoved.frame =  destination;
    }];
}

/** Pictogram moved */
- (void)pictogramDraggedToPoint:(CGPoint const)point relativeToView:(UIView *)view
{
    const CGPoint locationInView = [_source.view convertPoint:point fromView:view];
    _pictogramBeingMoved.frame = [PictogramView frameAtPoint:locationInView];
}

- (void)animatePictogramBackToOriginalPosition {
    [_pictogramBeingMoved removeFromSuperview]; // TODO: animate , currently this removes it immadiately instead of animating.
}

- (void)pictogramDraggingCancelled {
    [_pictogramBeingMoved removeFromSuperview];
}

/**
 Deal with what should happen when user drops a pictogram (after dragging).
 Users drop items (pictograms) on a schedule where they are to be added.
 @param location The location where the pictogram was dropped.
 @param view The view to which the location is relative.
 @return YES Pictogram was added.
 @return NO Pictogram was not added.
 */
- (BOOL)handleAddPictogramToScheduleAtPoint:(CGPoint)location relativeToView:(UIView * const)view
{
    NSAssert(view, @"The view must not be empty.");
    
    BOOL const wasAdded = [_destination addPictogramWithID:self.idOfPictogramBeingMoved
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


@end
