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
    self.dataSource = [Schedule fetchedResultsController];
    [self.dataSource setDelegate:self];
    [self.dataSource errorHandledFetch];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.dataSource sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *sections = self.dataSource.sections;
    return [sections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    NSParameterAssert(indexPath.row < self.dataSource.fetchedObjects.count);
    UITableViewCell *cell = [self.delegate.tableView dequeueReusableCellWithIdentifier:kBBACellIdentifier forIndexPath:indexPath];
    Schedule *schedule = [self.dataSource objectAtIndexPath:indexPath];
    cell.textLabel.text = schedule.title;
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.delegate.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.row < self.dataSource.fetchedObjects.count);
    [tableView indexPathForSelectedRow];
    [self.delegate scheduleTableDataSource:self scheduleWasSelectedByUser:[self.dataSource objectAtIndexPath:indexPath]];
}



@end
