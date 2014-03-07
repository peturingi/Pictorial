#import "BBAScheduleTableDataSource.h"

NSString * const kBBACellIdentifier = @"ScheduleCell";
NSString * const kBBANotificationNameForDidSelectItem = @"didSelectObjectInScheduleTableDataSource";
NSString * const kBBANotificationNameForNewDataAvailable = @"newDataAvailableInScheduleTableDataSource";

@implementation BBAScheduleTableDataSource

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
    NSParameterAssert(section == 0);
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.dataSource sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBBACellIdentifier forIndexPath:indexPath];
    Schedule *schedule = [self.dataSource objectAtIndexPath:indexPath];
    cell.textLabel.text = schedule.title;
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSNotification *notification = [NSNotification notificationWithName:kBBANotificationNameForNewDataAvailable object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Schedule *selectedSchedule = [self.dataSource objectAtIndexPath:indexPath];
    NSNotification *notification = [NSNotification notificationWithName:kBBANotificationNameForDidSelectItem object:selectedSchedule];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}



@end
