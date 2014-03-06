#import "BBAShowScheduleViewController.h"
#import "../../../BBAModel/BBAModel/BBAModelStack.h"

@interface BBAShowScheduleViewController ()

@end

@implementation BBAShowScheduleViewController

- (void)setSchedule:(Schedule *)schedule {
    if (!schedule || ![schedule isKindOfClass:[Schedule class]]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"A Schedule must be used as an argument." userInfo:nil] raise];
    }
    _schedule = schedule;
}

@end
