#import "BBAScheduleOverviewViewController.h"
#import "Show Schedule/BBAShowScheduleViewController.h"
#import "BBAScheduleTableDataSource.h"
#import <CoreData/CoreData.h>
#import "Pictogram.h"

static NSString * const kBBASortCellsBy = @"title";

@implementation BBAScheduleOverviewViewController {
    Schedule *userSelectedSchedule;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self tableView] reloadData];
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

@end
