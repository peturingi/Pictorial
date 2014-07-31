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
}

- (void)showCameraPicker;
- (void)showAlbumPicker;

- (void)selectedPictogramToAdd:(NSManagedObjectID *)pictogramIdentifier atLocation:(CGPoint)location relativeTo:(UIView *)view;
- (void)itemDroppedAt:(CGPoint const)location relativeTo:(UIView * const)view;
- (void)itemMovedTo:(CGPoint)point relativeTo:(UIView *)view;

@end
