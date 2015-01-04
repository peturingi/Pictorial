#import "MasterViewController.h"
#import "CreatePictogram.h"
#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CameraPicker.h"
#import "AlbumPicker.h"
#import "ImageSourceTableViewController.h"
#import "Pictogram.h"
#import "UIBarButtonItem+EditButton.h"
#import "HidableBarButtonItem.h"

@interface MasterViewController ()

@property (weak, nonatomic) IBOutlet HidableBarButtonItem *configureBackground;
@property (strong) UIPopoverController *imageSourcePopover;
@property (weak, nonatomic) IBOutlet HidableBarButtonItem *importPhotoButton;

@end

@implementation MasterViewController

- (void)dealloc {
    picker = nil;
}

- (void)viewDidLoad {
    /* Disable the border underneath the navigation bar. */
    {
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }
    /* The pictogram selection window is intially hidden, 
     as well as the bar button items which are revelaed during
     pictogram selection. */
    {
        [self.editButtonItem setEditMode:YES];
        [self editButton:self.editButtonItem];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
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
        _bottomViewController = segue.destinationViewController;
        _bottomViewController.delegate = self;
    }
    
    // Know the top views controller
    if ([segue.identifier isEqualToString:@"SEGUE_EMBED_TOPVIEW"]) {
        ScheduleCollectionViewController * const destination = segue.destinationViewController;
        destination.delegate = self;
        _topViewController = destination;
    }
    
    if ([segue.identifier isEqualToString:@"SEGUE_IMAGE_SOURCE"]) {
        // Set self as delegate of ImageSource controller
        ImageSourceTableViewController * const destination = segue.destinationViewController;
        destination.delegate = self;
        
        // ImageSource is shown as popover, remember the controller so I can dismiss it.
        self.imageSourcePopover = ((UIStoryboardPopoverSegue*)segue).popoverController;
        {
            NSAssert(self.imageSourcePopover, @"Failed to get popoverController.");
        } // Assert
    }
}

#pragma mark - Import Image

- (void)showCameraPicker {
    [self showPicker:[CameraPicker class]];
}

- (void)showAlbumPicker {
    [self showPicker:[AlbumPicker class]];
}

- (void)showPicker:(Class)pickerClass {
    {
        NSAssert([pickerClass isSubclassOfClass:[Picker class]], @"Invalid class.");
        NSAssert(self.imageSourcePopover, @"Failed to get popovercontroller.");
    } // Assert
    [self.imageSourcePopover dismissPopoverAnimated:NO];
    self.imageSourcePopover = nil;
    
    picker = [[pickerClass alloc] init];
    picker.delegate = self;
    [picker show];
}

- (void)pickerDisappearedWithoutPickingPhoto:(Picker *)sender {
    picker = nil;
}

- (void)pickerDisappearedAfterPickingPhoto:(Picker * )sender {
    [self performSegueWithIdentifier:SEGUE_NEW_PICTOGRAM sender:nil];
}

#pragma mark - Change View Modes

- (IBAction)showDayView:(id)sender {
    [_topViewController switchToDayLayout];
}

- (IBAction)showWeekView:(id)sender {
    [_topViewController switchToWeekLayout];
}

#pragma mark - 

- (IBAction)editButton:(UIBarButtonItem *)sender {
    [sender setEditMode                 : ! sender.editMode ];
    
    /* Hide / Show bar button items */
    {
        self.importPhotoButton.hidden   = sender.editMode;
        self.configureBackground.hidden = sender.editMode;
    }
    
    sender.title                        = sender.editMode ? @"Done" : @"Edit";
    NSUInteger const heightDuringEdit   = floor(self.view.frame.size.height / 3.0f);
    NSUInteger const heightWhenClosed   = 0;
    [self setHeightOfPictogramSelector  : (sender.editMode ? heightDuringEdit : heightWhenClosed) ];
    [_topViewController setEditing      : sender.editMode ];
    [_bottomViewController setEditing   : sender.editMode ];
}

- (void)setHeightOfPictogramSelector:(CGFloat const)height {
    [self.view layoutIfNeeded];
    bottomViewHeight.constant = height;
    [self.view layoutIfNeeded];
}

- (UICollectionViewController<AddPictogramWithID>*)targetForPictogramDrops {
    return _topViewController;
}

@end
