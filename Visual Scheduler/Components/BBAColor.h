#import <Foundation/Foundation.h>

@interface BBAColor : NSObject

+ (UIColor *)colorForIndex:(NSUInteger)index;
+ (NSUInteger)indexForColor:(UIColor *)colour;
+ (NSArray *)availableColors;
@end