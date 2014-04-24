#import <Foundation/Foundation.h>
#define TWO_M_PI (2.0f * M_PI)

@interface MathUtils : NSObject
+(CGFloat)normalizeAngleToMinutesForSeconds:(NSUInteger)seconds;
+(CGFloat)angleBetweenCenter:(CGPoint)center andPoint:(CGPoint)point;
+(NSUInteger)secondsFromAngle:(CGFloat)angle;
+(CGFloat)angleFromSeconds:(NSUInteger)seconds;
+(NSUInteger)normalizeSecondsToWholeMinutesForSeconds:(NSUInteger)seconds;
@end
