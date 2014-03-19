#import "BBAShowScheduleViewController.h"

@interface BBAShowScheduleViewController ()

@end

@implementation BBAShowScheduleViewController

- (void)viewWillAppear:(BOOL)animated {
    [self setTitle:self.schedule.title];
}

- (void)BBA_dismissViewController {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSchedule:(Schedule *)schedule {
    if (!schedule || ![schedule isKindOfClass:[NSManagedObject class]]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"A Schedule must be used as an argument." userInfo:nil] raise];
    }
    _schedule = schedule;
}

@end
