#import "BBAAddScheduleViewController.h"
#import "BBASelectPictogramViewController.h"
#import "BBACoreDataStack.h"
#import "Schedule.h"
#import "Pictogram.h"

@interface BBAAddScheduleViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) Pictogram *pictogramLogo;

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
    // TODO No date is not inserted.
    Schedule* schedule = (Schedule*)[BBACoreDataStack createObjectInContexOfClass:[Schedule class]];
    [schedule setTitle:schedulesTitle.text];
    [schedule setColour:[NSNumber numberWithInt:0]];
    [schedule setDate:[NSDate date]];
    NSError* saveError;
    BOOL success;
    success = [BBACoreDataStack saveContext:&saveError];
    if(!success){
        // Do something about it, eh!?
        [NSException raise:@"CantSaveException" format:@"Fix, so that we can have nice things"];
    }
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
    [self setPictogramLogo:item];
}


@end
