#import "NSString+TimeFormatted.h"
@implementation NSString (TimeFormatted)
+(NSString*)timeFormattedStringFromSeconds:(NSUInteger)seconds{
    int hours = (int)seconds / 3600;
    int minutes = seconds / 60 % 60;
    seconds = seconds % 60;
    short int remaining_seconds = seconds % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, remaining_seconds];
}
@end
