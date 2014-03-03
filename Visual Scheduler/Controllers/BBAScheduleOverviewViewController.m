#import "BBAScheduleOverviewViewController.h"
#import <CoreData/CoreData.h>
#import "Schedule.h"
#import "../../BBACoreDataStack.h"

@interface BBAScheduleOverviewViewController ()
    @property (strong, nonatomic) NSFetchedResultsController *dataSource;
    @property (strong, nonatomic) BBACoreDataStack *coreDataStack;
@end

@implementation BBAScheduleOverviewViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

#pragma mark viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupUI];
    [self reloadTableView];
}

- (void)setupDataSource {
    _coreDataStack = [BBACoreDataStack stackWithModelNamed:@"CoreData" andStoreFileNamed:@"CoreData.sqlite"];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    _dataSource = [_coreDataStack fetchedResultsControllerForEntityClass:[Schedule class] batchSize:20 andSortDescriptors:@[sd]];
    [_dataSource performFetch:nil];
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellInScheduleOverview"];
}

- (void)reloadTableView {
    [self.coreDataStack performFetchForResultsController:self.dataSource];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *sections = _dataSource.sections;
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [_dataSource sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellInScheduleOverview";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Schedule *schedule = [_dataSource objectAtIndexPath:indexPath];
    cell.textLabel.text = schedule.title;
    return cell;
}

#pragma mark - UI Interaction

- (void)createSchedule {
    // TODO : Show create schedule UI
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Error Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
