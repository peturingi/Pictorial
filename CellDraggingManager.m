#import "CellDraggingManager.h"
#import <CoreData/CoreData.h>
#import "PictogramView.h"
#import "Pictogram.h"
#import "AppDelegate.h"
#import "ImageResizer.h"

/* Math Helpers */
#import "RectHelper.h"
#import "PointHelper.h"

/* Used to keep track of the original position of the pictogram to be dragged,
 so that it is possible to animate it back if needed. */
@interface CellDraggingManager ()
@property CGRect sourceFrame;
@property CGPoint sourceOffset;
@end

@implementation CellDraggingManager

- (id)initWithSource:(UICollectionViewController * const)source andDestination:(UICollectionViewController<AddPictogramWithID> * const)destination {
    self = [super init];
    if (self) {
        _source = source;
        _destination = destination;
        self.locationRestriction = CGRectZero;
    }
    return self;
}

/** Pictogram Touched */
- (void)setPictogramToDrag:(NSManagedObjectID * const)pictogramIdentifier fromRect:(CGRect const)rect atLocation:(CGPoint const)location relativeTo:(UIView * const)view {
    {
        NSAssert(_source, @"Must not be nil.");
        NSAssert(_destination, @"Must not be nil.");
        NSAssert(pictogramIdentifier, @"Must not be nil.");
        NSAssert(view, @"Must not be nil.");
    } // Assert
    
    /* Store orignal location of pictogram, so it is possible to animate it back if needed. */
    {
        self.sourceOffset = _source.collectionView.contentOffset;
        self.sourceFrame = [_source.view convertRect:rect fromView:view];
    }
    
    self.idOfPictogramBeingMoved = pictogramIdentifier;
    
    /* Animate the selected pictogram, to the finger. */
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    /* Resize image. Saves about 1,5 MB of RAM. */
    ImageResizer * const imageResizer = [[ImageResizer alloc] initWithImage:((Pictogram *)[delegate objectWithID:pictogramIdentifier]).uiImage];
    UIImage * const image = [imageResizer getImageResizedTo:CGSizeMake(PICTOGRAM_SIZE_WHILE_DRAGGING, PICTOGRAM_SIZE_WHILE_DRAGGING)];
    
    // Add as subview
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
    CGPoint const locationInView = [_source.view convertPoint:point fromView:view];
    CGRect frame = [PictogramView frameAtPoint:locationInView];
    
    /* Adjust new frame if there is restriction on where it can be placed. */
    if ([self restrictedMovement])
    {
        CGSize const size = self.locationRestriction.size;
        CGPoint const origin = self.locationRestriction.origin;
        
        /* Up */
        CGFloat const minY = origin.y;
        if (frame.origin.y < minY) frame.origin.y = minY;
        
        /* Down */
        CGFloat const maxY = minY + size.height - _pictogramBeingMoved.frame.size.height;
        if (frame.origin.y > maxY) frame.origin.y = maxY;
        
        /* Left */
        CGFloat const minX = origin.x;
        if (frame.origin.x < minX) frame.origin.x = minX;
        
        // Right
        CGFloat const maxX = minX + size.width - _pictogramBeingMoved.frame.size.width;
        if (frame.origin.x > maxX) frame.origin.x = maxX;
    }
    _pictogramBeingMoved.frame = frame;
}

/**
 Has the dragging of a pictogram been restricted to a given rectangle?
 @return YES Movement is restricted.
 @return NO Movement is not restricted.
 */
- (BOOL)restrictedMovement {
    return  self.locationRestriction.size.height != 0 ||
            self.locationRestriction.size.width != 0 ||
            self.locationRestriction.origin.x != 0 ||
            self.locationRestriction.origin.y != 0;
}

/** Animates the pictogram back into its original position. 
 The method takes into account that the collection view might have scrolled.
 */
- (void)animatePictogramBackToOriginalPosition
{
    CGPoint const differenceInOffset = [PointHelper subPointA:self.sourceOffset fromB:_source.collectionView.contentOffset];
    CGPoint const destinationOrigin = [PointHelper addPointA:self.sourceFrame.origin andB:differenceInOffset];
    CGRect const destinationFrame = [RectHelper makeRectWithSize:self.sourceFrame.size andOrigin:destinationOrigin];
    
    [UIView animateWithDuration:ANIMATION_DURING_MOVE_BACK_PICTOGRAM
                     animations:^(void)
    {
        _pictogramBeingMoved.frame = destinationFrame;
    }
                     completion:^(BOOL finished)
    {
        if (finished) [_pictogramBeingMoved removeFromSuperview];
    }];
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
