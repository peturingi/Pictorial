#import "BBAShowScheduleViewController.h"
#import "BBAColor.h"

@interface BBAShowScheduleViewController ()
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
    [[self tableView] setBackgroundColor:[BBAColor colorForIndex:backgroundColorIndex]];
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

@end
