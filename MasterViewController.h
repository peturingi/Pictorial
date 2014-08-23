#import "PickerDelegate.h"
#import "Picker.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PictogramView.h"
#import "ScheduleCollectionViewController.h"
#import "PictogramSelectorViewController.h"
#import "AddPictogramWithID.h"

@class PictogramSelectorViewController;

@interface MasterViewController : UIViewController <PickerDelegate> {
    Picker *picker;
    
    __weak ScheduleCollectionViewController<AddPictogramWithID> *_topViewController;
    __weak PictogramSelectorViewController *_bottomViewController;
    __weak IBOutlet UIView *bottomView;
    
    __weak IBOutlet NSLayoutConstraint *bottomViewHeight;
    __weak IBOutlet UIBarButtonItem *importPhotosButton;
    __weak IBOutlet UIBarButtonItem *toggleEdit;
}

- (void)showCameraPicker;
- (void)showAlbumPicker;

- (UICollectionViewController<AddPictogramWithID>*)targetForPictogramDrops;

@end
