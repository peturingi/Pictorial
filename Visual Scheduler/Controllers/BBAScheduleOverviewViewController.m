#import "BBAScheduleOverviewViewController.h"
//#import "Schedule.h"
//#import "../../BBACoreDataStack.h"
#import "Show Schedule/BBAShowScheduleViewController.h"
#import "../../BBAModel/BBAModel/BBAModelStack.h"

static NSString * const kBBACellReuseIdentifier = @"ScheduleCell";
static NSString * const kBBASortCellsBy = @"title";

@interface BBAScheduleOverviewViewController ()
    @property (strong, nonatomic) NSFetchedResultsController *dataSource;
@end

@implementation BBAScheduleOverviewViewController

#pragma mark viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupDataSource];
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

- (void)setupDataSource {
    // TODO Temporary implementation for use during development. Change to a proper one before release.
    /*
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kBBASortCellsBy ascending:YES];
    BBACoreDataStack *coreDataStack = [BBACoreDataStack sharedInstance];
    _dataSource = [coreDataStack fetchedResultsControllerForEntityClass:[Schedule class] batchSize:20 andSortDescriptors:@[sortDescriptor]];
    _dataSource.delegate = self;
    [[BBACoreDataStack sharedInstance] fetchFor:_dataSource];
     */
    _dataSource = [Schedule fetchedResultsController];
    [_dataSource setDelegate:self];
    [_dataSource errorHandledFetch];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *sections = _dataSource.sections;
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_dataSource sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBBACellReuseIdentifier forIndexPath:indexPath];
    Schedule *schedule = [_dataSource objectAtIndexPath:indexPath];
    cell.textLabel.text = schedule.title;
    return cell;
}

#pragma mark - FetchedResultsController Delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self reloadTableView];
}

- (void)reloadTableView {
    [self.tableView reloadData];
}

#pragma mark - UI Interaction

- (void)createSchedule {
    [self performSegueWithIdentifier:@"addSchedule" sender:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showSchedule" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSchedule"]) {
        BBAShowScheduleViewController *destination = [segue destinationViewController];
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
        Schedule *selectedSchedule = [_dataSource objectAtIndexPath:selectedRow];
        [destination setSchedule:selectedSchedule];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
