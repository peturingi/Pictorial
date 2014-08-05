#import "PickerDelegate.h"
#import "Picker.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PictogramView.h"
#import "ScheduleCollectionViewController.h"


@interface MasterViewController : UIViewController <PickerDelegate> {
    Picker *picker;
    __weak ScheduleCollectionViewController *_topViewController;
    __weak IBOutlet UIView *bottomView;
    
    __weak PictogramView *_pictogramBeingMoved;
    NSManagedObjectID *_idOfPictogramBeingMoved;
    __weak IBOutlet NSLayoutConstraint *bottomViewHeight;
}

- (void)showCameraPicker;
- (void)showAlbumPicker;

- (void)selectedPictogramToAdd:(NSManagedObjectID *)pictogramIdentifier atLocation:(CGPoint)location relativeTo:(UIView *)view;
- (BOOL)handleAddPictogramToScheduleAtPoint:(CGPoint const)location relativeToView:(UIView * const)view;
- (void)pictogramBeingDraggedMovedToPoint:(CGPoint)point relativeToView:(UIView *)view;
- (void)pictogramDraggingCancelled;
@end
