#import "BBAScheduleTableDataSource.h"
#import "Schedule.h"

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
    NSManagedObjectContext *sharedManagedObjectContext = [[BBACoreDataStack sharedInstance] sharedManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:sharedManagedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:30];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    self.dataSource = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:sharedManagedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    [self.dataSource setDelegate:self];
    [self.dataSource performFetch:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.dataSource sections] objectAtIndex:section];
    NSUInteger count = [sectionInfo numberOfObjects];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBBACellIdentifier forIndexPath:indexPath];
    Schedule *schedule = [self.dataSource objectAtIndexPath:indexPath];
    cell.textLabel.text = schedule.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Schedule *selectedSchedule = [self.dataSource objectAtIndexPath:indexPath];
    NSNotification *notification = [NSNotification notificationWithName:kBBANotificationNameForDidSelectItem object:selectedSchedule];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSNotification *notification = [NSNotification notificationWithName:kBBANotificationNameForNewDataAvailable object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
