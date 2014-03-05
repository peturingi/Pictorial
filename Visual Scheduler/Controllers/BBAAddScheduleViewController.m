#import "BBAAddScheduleViewController.h"
#import "../../CameraComponent/Camera/Camera.h"
#import "BBACoreDataStack.h"

@interface BBAAddScheduleViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) Camera *camera;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIPopoverController *cameraOrPictogramSelection;
@end

@implementation BBAAddScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCamera];
}

- (void)setupCamera {
    _camera = [[Camera alloc] initWithViewController:self usingDelegate:self];
}

- (IBAction)showCamera:(id)sender {
    [_camera show];
}
- (IBAction)showLibrary:(id)sender {
}
- (IBAction)showPictograms:(id)sender {
}


- (IBAction)done:(id)sender {
    if ([self verifyTitle]) {
        [self createScheduleFromInput];
        [self dismiss:nil];
    } else {
        [self alertUserOfInvalidInput];
    }
}

- (void)createScheduleFromInput {
    [[BBACoreDataStack sharedInstance] insertScheduleWithTitle:schedulesTitle.text logo:nil backgroundColor:0];
}

- (BOOL)verifyTitle {
    NSString *title = schedulesTitle.text;
    if (title.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)alertUserOfInvalidInput {
    UIAlertView *invalidInput = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You must specify a title for the schedule." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [invalidInput show];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CameraDelegate

- (void)cameraDidSnapPhoto:(Camera *)camera {
    _image = [_camera developPhoto];
}

#pragma mark - Error Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
