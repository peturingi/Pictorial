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
    // TODO: merge into pickerDisappeared which returns a photo. Then check if photo is nil and perform segue.
}

#pragma mark - Change View Modes

- (IBAction)showDayView:(id)sender {
    [_topViewController switchToDayLayout];
}

- (IBAction)showWeekView:(id)sender {
    [_topViewController switchToWeekLayout];
}

#pragma mark - 

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

- (UICollectionViewController<AddPictogramWithID>*)targetForPictogramDrops {
    return _topViewController;
}

@end
