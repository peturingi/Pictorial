#import "BBAScheduleTableDataSource.h"
#import "Schedule.h"
#import "../Database/SharedRepositoryProtocol.h"

NSString * const kBBACellIdentifier = @"ScheduleCell";
NSString * const kBBANotificationNameForDidSelectItem = @"didSelectObjectInScheduleTableDataSource";
NSString * const kBBANotificationNameForNewDataAvailable = @"didUpdateScheduleTableDataSource";

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
    id appDelegate = [[UIApplication sharedApplication] delegate];
    _repository = [appDelegate valueForKey:@"sharedRepository"];
    NSAssert(_repository != nil, @"Failed to get the shared repository.");
    _dataSource = [_repository allSchedules];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Schedule *objToDelete = [self.dataSource objectAtIndex:indexPath.row];
#warning NOT IMPLEMENTED
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    NSAssert(self.dataSource != nil, @"The data source must not be nil. It is not possible to display a list of schedules.");
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBBACellIdentifier forIndexPath:indexPath];
    Schedule *schedule = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = schedule.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Schedule *selectedSchedule = [self.dataSource objectAtIndex:indexPath.row];
    NSNotification *notification = [NSNotification notificationWithName:kBBANotificationNameForDidSelectItem object:selectedSchedule];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSNotification *notification = [NSNotification notificationWithName:kBBANotificationNameForNewDataAvailable object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
