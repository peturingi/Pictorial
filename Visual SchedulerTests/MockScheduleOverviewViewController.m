#import "MockScheduleOverviewViewController.h"
#import "Schedule.h"

@interface MockScheduleOverviewViewController ()

@end

@implementation MockScheduleOverviewViewController

- (void)scheduleTableDataSource:(BBAScheduleTableDataSource *)sender scheduleWasSelectedByUser:(Schedule *)selection {
    _scheduleWasSelectedByUser = YES;
}

- (BOOL)scheduleWasSelectedByUser {
    return _scheduleWasSelectedByUser;
}

@end
