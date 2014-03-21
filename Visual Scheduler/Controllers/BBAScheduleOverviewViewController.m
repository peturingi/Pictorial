#import "BBAScheduleOverviewViewController.h"
#import "Show Schedule/BBAShowScheduleViewController.h"
#import <CoreData/CoreData.h>
#import "BBAScheduleTableDataSource.h"
#import "Pictogram.h"

static NSString * const kBBASortCellsBy = @"title";

@implementation BBAScheduleOverviewViewController {
    Schedule *userSelectedSchedule;
    __weak IBOutlet UIBarButtonItem *addScheduleButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self tableView] reloadData];
    [self controlAccessToAddScheduleButton];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tableDataStoreDidSelectItem:)
                                                 name:kBBANotificationNameForDidSelectItem
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableViewData:)
                                                 name:kBBANotificationNameForNewDataAvailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlAccessToAddScheduleButton)
                                                 name:UIAccessibilityGuidedAccessStatusDidChangeNotification
                                               object:nil];
}

- (void)tableDataStoreDidSelectItem:(NSNotification *)notification {
    if (![[notification object] isKindOfClass:[NSManagedObject class]]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"The receiver does not know what to do with an object of this type." userInfo:nil];
    }
    userSelectedSchedule = [notification object];
    [self performSegueWithIdentifier:@"showSchedule" sender:self];
}

- (void)reloadTableViewData:(NSNotification *)notification {
    [[self tableView] reloadData];
}

#pragma mark - UI Interaction

- (IBAction)createSchedule:(id)sender {
    [self performSegueWithIdentifier:@"addSchedule" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSchedule"]) {
        BBAShowScheduleViewController *destination = [segue destinationViewController];
        [destination setSchedule:userSelectedSchedule];
    }
}

- (void)controlAccessToAddScheduleButton {
    self.navigationItem.rightBarButtonItem.enabled = !UIAccessibilityIsGuidedAccessEnabled();
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
