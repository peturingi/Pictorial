#import "NSDate+VisualScheduler.h"

@implementation NSDate (VisualScheduler)

/** The current day of the week. (0)Monday to (6)Sunday.
 *
 */
+ (NSUInteger)dayOfWeekInDenmark {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"c"]; // Stand-Alone local day of week (UTS #35 LDML).
    NSLocale *dkLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
    [formatter setLocale:dkLocale];
    NSString *dayOfWeek = [formatter stringFromDate:[NSDate date]];
    NSAssert(dayOfWeek, @"Failed to get a string representation for today.");
    const NSInteger day = [dayOfWeek integerValue];
    return day;
}

@end