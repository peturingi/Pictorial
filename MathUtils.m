#import "MathUtils.h"
#define FACTOR (60 / M_PI / 2.0f * 60)
@implementation MathUtils
+(CGFloat)angleBetweenCenter:(CGPoint)center andPoint:(CGPoint)point{
    float angle = atan2(center.x - point.x, center.y - point.y);
    if(center.x < point.x){
        angle += TWO_M_PI;
    }
    return angle;
}

+(NSUInteger)secondsFromAngle:(CGFloat)angle{
    return angle * FACTOR;
}

+(CGFloat)angleFromSeconds:(NSUInteger)seconds{
    return seconds / FACTOR;
}

+(CGFloat)normalizeAngleToMinutesForSeconds:(NSUInteger)seconds{
    return seconds / FACTOR;
}

+(NSUInteger)normalizeSecondsToWholeMinutesForSeconds:(NSUInteger)seconds{
    if(seconds < 50){
        return 0;
    }
    return (seconds / 60) * 60.0f + 60;
}

@end
