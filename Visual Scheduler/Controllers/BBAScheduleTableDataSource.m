#import "BBAScheduleTableDataSource.h"

@implementation BBAScheduleTableDataSource

NSString * const kBBACellIdentifier = @"ScheduleCell";

#pragma mark - UITableViewDataSource

- (id)init {
    self = [super init];
    if (self) {
        [self setupDataSource];
    }
    return self;
}

- (void)setupDataSource {
    _dataSource = [Schedule fetchedResultsController];
    [_dataSource setDelegate:self];
    [_dataSource errorHandledFetch];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_dataSource sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *sections = _dataSource.sections;
    return [sections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    NSParameterAssert(indexPath.row < self.dataSource.fetchedObjects.count);
    UITableViewCell *cell = [tableViewControllersTableView dequeueReusableCellWithIdentifier:kBBACellIdentifier forIndexPath:indexPath];
    Schedule *schedule = [_dataSource objectAtIndexPath:indexPath];
    cell.textLabel.text = schedule.title;
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [tableViewControllersTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView indexPathForSelectedRow];
    [tableViewController scheduleTableDataSource:self scheduleWasSelectedByUser:[self.dataSource objectAtIndexPath:indexPath]];
}



@end
