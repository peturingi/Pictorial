#import "BBAScheduleOverviewViewController.h"
#import "Show Schedule/BBAShowScheduleViewController.h"
#import "../../BBAModel/BBAModel/BBAModelStack.h"
#import "BBAScheduleTableDataSource.h"
#import <CoreData/CoreData.h>

static NSString * const kBBACellReuseIdentifier = @"ScheduleCell";
static NSString * const kBBASortCellsBy = @"title";

@implementation BBAScheduleOverviewViewController {
    Schedule *userSelectedSchedule;
    BBAScheduleTableDataSource *tableViewDataSourceAndDelegate;
}

#pragma mark viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableDataSource];
    [self setupUI];
    [self registerForNotifications];
}

- (void)setupTableDataSource {
    tableViewDataSourceAndDelegate = [[BBAScheduleTableDataSource alloc] init];
}

- (void)setupUI {
    self.title = @"Schedules";
    [self setupAddScheduleButton];
    [self setupTableView];
}

- (void)setupAddScheduleButton {
    SEL actionForButton = @selector(createSchedule);
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:actionForButton];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)setupTableView {
    NSAssert(tableViewDataSourceAndDelegate, @"Cannot configure tableView - it will not be able to configure its delegates");
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kBBACellReuseIdentifier];
    [self.tableView setDataSource:tableViewDataSourceAndDelegate];
    [self.tableView setDelegate:tableViewDataSourceAndDelegate];
}

#pragma mark - Notifications

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tableDataStoreDidSelectItem:)
                                                 name:kBBANotificationNameForDidSelectItem
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tableDataStoreDidRequestTableViewReloadData:)
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

- (void)tableDataStoreDidRequestTableViewReloadData:(NSNotification *)notification {
    [[self tableView] reloadData];
}

#pragma mark - UI Interaction

- (void)createSchedule {
    [self performSegueWithIdentifier:@"addSchedule" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSchedule"]) {
        BBAShowScheduleViewController *destination = [segue destinationViewController];
        [destination setSchedule:userSelectedSchedule];
    }
}

@end
