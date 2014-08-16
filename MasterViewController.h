#import "PickerDelegate.h"
#import "Picker.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PictogramView.h"
#import "ScheduleCollectionViewController.h"
#import "AddPictogramWithID.h"


@interface MasterViewController : UIViewController <PickerDelegate> {
    Picker *picker;
    __weak ScheduleCollectionViewController<AddPictogramWithID> *_topViewController;
    __weak IBOutlet UIView *bottomView;
    
    __weak IBOutlet NSLayoutConstraint *bottomViewHeight;
    __weak IBOutlet UIBarButtonItem *importPhotosButton;
    __weak IBOutlet UIBarButtonItem *showPictogramSelectorButton;
    __weak IBOutlet UIBarButtonItem *hidePictogramSelectorButton;
}

- (void)showCameraPicker;
- (void)showAlbumPicker;

- (UICollectionViewController<AddPictogramWithID>*)targetForPictogramDrops;

@end
