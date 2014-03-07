#import "BBAScheduleOverviewViewController.h"

@interface MockScheduleOverviewViewController : BBAScheduleOverviewViewController {
    BOOL _scheduleWasSelectedByUser;
}

- (BOOL)scheduleWasSelectedByUser;

@end
