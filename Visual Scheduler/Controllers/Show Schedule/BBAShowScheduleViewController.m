#import "BBAShowScheduleViewController.h"
#import "BBAColor.h"
#import "BBAShowScheduleCollectionViewController.h"
#import "BBASelectPictogramViewController.h"
#import "Pictogram.h"
#import "Schedule.h"

@interface BBAShowScheduleViewController ()
@property (strong, nonatomic) BBAShowScheduleCollectionViewController *showScheduleCollectionViewController;
@property (strong, nonatomic) BBASelectPictogramViewController *selectPictogramViewController;

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
    NSUInteger backgroundColorIndex = [[self.schedule colour] integerValue];
    [[self view] setBackgroundColor:[BBAColor colorForIndex:backgroundColorIndex]];
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
    if (!schedule || ![schedule isKindOfClass:[NSManagedObject class]]) {
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
    }
    if ([[segue identifier] isEqualToString:@"pictogramSelector"]) {
        _selectPictogramViewController = (BBASelectPictogramViewController *)segue.destinationViewController;
        [_selectPictogramViewController setDelegate:self];
    }
}

#pragma mark Delegate

- (void)BBASelectPictogramViewController:(BBASelectPictogramViewController *)controller didSelectItem:(Pictogram *)item {
    NSLog(@"Selected pictogram: %@", item.title);
    
    if (![[self.schedule pictograms] containsObject:item]) {
        [item addUsedByObject:self.schedule];
        Schedule *s = self.schedule;
        NSLog(@"Responds? %d", [s respondsToSelector:NSSelectorFromString(@"insertObject:inPictogramsAtIndex:")]);
        [s insertObject:item inPictogramsAtIndex:self.schedule.pictograms.count];
        NSLog(@"Added");
    } else {
        NSLog(@"Not added");
    }
}

@end
