#import "ScheduleViewController.h"

@implementation ScheduleViewController
- (IBAction)switchCalendarRepresentation:(id)sender {
    NSInteger selectedViewMode = ((UISegmentedControl *)sender).selectedSegmentIndex;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CALENDAR_VIEW  object:[NSNumber numberWithInteger:selectedViewMode]];
}
- (IBAction)edit:(id)sender {
}

@end