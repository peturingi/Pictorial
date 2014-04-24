#import <Foundation/Foundation.h>
@interface MathUtils : NSObject
+(CGFloat)normalizeAngleToMinutesForSeconds:(NSUInteger)seconds;
+(CGFloat)angleBetweenCenter:(CGPoint)center andPoint:(CGPoint)point;
+(NSUInteger)secondsFromAngle:(CGFloat)angle;
+(CGFloat)angleFromSeconds:(NSUInteger)seconds;
+(NSUInteger)normalizeSecondsToWholeMinutesForSeconds:(NSUInteger)seconds;
@end
