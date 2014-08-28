#import <Foundation/Foundation.h>

@interface PointHelper : NSObject

+ (CGPoint)addPointA:(CGPoint const)a andB:(CGPoint const)b;
+ (CGPoint)subPointA:(CGPoint const)a fromB:(CGPoint const)b;

@end
