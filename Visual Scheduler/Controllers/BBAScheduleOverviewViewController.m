#import "BBAScheduleOverviewViewController.h"
#import "Show Schedule/BBAShowScheduleViewController.h"
#import "../../BBAModel/BBAModel/BBAModelStack.h"

static NSString * const kBBACellReuseIdentifier = @"ScheduleCell";
static NSString * const kBBASortCellsBy = @"title";

@implementation BBAScheduleOverviewViewController {
    Schedule *userSelectedSchedule;
}

#pragma mark viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kBBACellReuseIdentifier];
}

#pragma mark - UI Interaction

- (void)createSchedule {
    [self performSegueWithIdentifier:@"addSchedule" sender:self];
}

- (void)scheduleTableDataSource:(BBAScheduleTableDataSource *)sender scheduleWasSelectedByUser:(Schedule *)selection {
    userSelectedSchedule = selection;
    [self performSegueWithIdentifier:@"showSchedule" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSchedule"]) {
        BBAShowScheduleViewController *destination = [segue destinationViewController];
        [destination setSchedule:userSelectedSchedule];
    }
}

@end
