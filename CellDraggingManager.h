#import <Foundation/Foundation.h>
#import "AddPictogramWithID.h"
@class PictogramView;
@class NSManagedObjectID;

@interface CellDraggingManager : NSObject {
    __weak PictogramView *_pictogramBeingMoved;
    NSManagedObjectID *_idOfPictogramBeingMoved;
    
    __weak UICollectionViewController *_source;
    __weak UICollectionViewController <AddPictogramWithID> *_destination;
}

- (id)initWithSource:(UICollectionViewController * const)source andDestination:(UICollectionViewController <AddPictogramWithID> * const)destination;

- (void)setPictogramToDrag:(NSManagedObjectID *)pictogramIdentifier fromRect:(CGRect const)rect atLocation:(CGPoint)location relativeTo:(UIView *)view;
- (void)pictogramDraggedToPoint:(CGPoint const)point relativeToView:(UIView *)view;
- (void)animatePictogramBackToOriginalPosition;
- (void)pictogramDraggingCancelled;
- (BOOL)handleAddPictogramToScheduleAtPoint:(CGPoint)location relativeToView:(UIView * const)view;

@end
