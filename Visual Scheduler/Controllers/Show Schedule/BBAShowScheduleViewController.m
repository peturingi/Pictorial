#import "BBAShowScheduleViewController.h"
#import "BBAColor.h"
#import "BBAShowScheduleCollectionViewController.h"
#import "BBASelectPictogramViewController.h"
#import "Pictogram.h"
#import "../../Database/Repository.h"

@interface BBAShowScheduleViewController ()
@property (strong, nonatomic) BBAShowScheduleCollectionViewController *showScheduleCollectionViewController;
@property (strong, nonatomic) BBASelectPictogramViewController *selectPictogramViewController;
@property (weak, nonatomic) IBOutlet UIView *scheduleContainer;
@property (weak, nonatomic) IBOutlet UIView *pictogramsContainer;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@end

@implementation BBAShowScheduleViewController

- (void)viewWillAppear:(BOOL)animated {
    [self setTitle:self.schedule.title];
    [self configureScheduleBackgroundColor];
    [self registerForNotifications];
    [self controlAccessToEditButton];
}

- (void)configureScheduleBackgroundColor {
    [[self view] setBackgroundColor:[self.schedule color]];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlAccessToEditButton)
                                                 name:UIAccessibilityGuidedAccessStatusDidChangeNotification
                                               object:nil];
}

- (void)controlAccessToEditButton {
    self.navigationItem.rightBarButtonItem.enabled = !UIAccessibilityIsGuidedAccessEnabled();
}

- (void)BBA_dismissViewController {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSchedule:(Schedule *)schedule {
    if (!schedule || ![schedule isKindOfClass:[Schedule class]]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"A Schedule must be used as an argument." userInfo:nil] raise];
    }
    _schedule = schedule;
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"embedScheduleCollection"]) {
        _showScheduleCollectionViewController = (BBAShowScheduleCollectionViewController *)segue.destinationViewController;
        [_showScheduleCollectionViewController setSchedule:self.schedule];

        Repository *sharedRepository = [Repository sharedStore];
        NSArray *pictogramsInSchedules = [sharedRepository pictogramsForSchedule:self.schedule includingImages:YES];
        [_showScheduleCollectionViewController setDataSource:pictogramsInSchedules];
    }
    if ([[segue identifier] isEqualToString:@"pictogramSelector"]) {
        _selectPictogramViewController = (BBASelectPictogramViewController *)segue.destinationViewController;
        [_selectPictogramViewController setDelegate:self];
    }
}
- (IBAction)editButtonPressed:(id)sender {
    [self toggleEditMode];
}

- (void)toggleEditMode {
#warning does not handle if button is pressed multiple times.The animation will conflict.
    static BOOL inEditMode = NO;
    if (inEditMode == NO) {
        inEditMode = YES;
            [UIView animateWithDuration:0.5f animations:^{
                CGRect currentFrame = self.scheduleContainer.frame;
                currentFrame.origin.x = self.scheduleContainer.superview.frame.origin.x;
                self.scheduleContainer.frame = currentFrame;
            }];
            [UIView animateWithDuration:0.5f animations:^{
                CGRect currentFrame = self.pictogramsContainer.frame;
                currentFrame.origin.x = 200;
                self.pictogramsContainer.frame = currentFrame;
            }];
    } else {
        inEditMode = NO;
        [UIView animateWithDuration:0.5f animations:^{
            CGRect currentFrame = self.scheduleContainer.frame;
            currentFrame.origin.x = CGRectGetMidX(self.scheduleContainer.superview.frame) - CGRectGetWidth(self.scheduleContainer.frame) / 2;
            self.scheduleContainer.frame = currentFrame;
        }];
        [UIView animateWithDuration:0.5f animations:^{
            CGRect currentFrame = self.pictogramsContainer.frame;
            currentFrame.origin.x = CGRectGetMaxX(self.pictogramsContainer.superview.frame);
            self.pictogramsContainer.frame = currentFrame;
        }];
    }
}

#pragma mark Delegate

- (void)BBASelectPictogramViewController:(BBASelectPictogramViewController *)controller didSelectItem:(Pictogram *)item {
    Repository *sharedRepository = [Repository sharedStore];
    NSUInteger numberOfPictogramsInSchedule = [sharedRepository pictogramsForSchedule:self.schedule includingImages:NO].count;
    [sharedRepository addPictogram:item toSchedule:self.schedule atIndex:numberOfPictogramsInSchedule];
    NSArray *pictograms = [sharedRepository pictogramsForSchedule:self.schedule includingImages:YES];
    [self.showScheduleCollectionViewController addPictogram:[pictograms objectAtIndex:numberOfPictogramsInSchedule]];
}

@end
