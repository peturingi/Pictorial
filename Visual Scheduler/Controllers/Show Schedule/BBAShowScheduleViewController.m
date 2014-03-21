#import "BBAShowScheduleViewController.h"
#import "BBAColor.h"

@interface BBAShowScheduleViewController ()

@end

@implementation BBAShowScheduleViewController

- (void)viewWillAppear:(BOOL)animated {
    [self setTitle:self.schedule.title];
    [self configureScheduleBackgroundColor];
}

- (void)configureScheduleBackgroundColor {
    NSUInteger backgroundColorIndex = [[self.schedule colour] integerValue];
    [[self tableView] setBackgroundColor:[BBAColor colorForIndex:backgroundColorIndex]];
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
