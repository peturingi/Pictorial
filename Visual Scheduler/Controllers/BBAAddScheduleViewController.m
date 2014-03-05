#import "BBAAddScheduleViewController.h"
#import "BBACoreDataStack.h"
#import "Pictogram.h"
#import "BBASelectPictogramViewController.h"

@interface BBAAddScheduleViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) UIImage *image;

@end

@implementation BBAAddScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [[BBACoreDataStack sharedInstance] insertScheduleWithTitle:schedulesTitle.text logo:imageView.image backgroundColor:0];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)imageViewTouched:(id)sender {
    [self performSegueWithIdentifier:@"showPictogramSelector" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showPictogramSelector"]) {
        BBASelectPictogramViewController *destinationView = [segue destinationViewController];
        [destinationView setDelegate:self];
    }
}

- (void)BBASelectPictogramViewController:(BBASelectPictogramViewController *)controller didSelectItem:(Pictogram *)item {
    UIImage *pictogramImage = [UIImage imageWithContentsOfFile:item.imageURL];
    [imageView setImage:pictogramImage];
}


@end
