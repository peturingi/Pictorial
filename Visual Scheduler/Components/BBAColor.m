#import "BBAColor.h"

@implementation BBAColor


+ (UIColor *)colorForIndex:(NSUInteger)index {
    NSParameterAssert(index < [self availableColors].count);
    return [[self availableColors]objectAtIndex:index];
}

+ (NSUInteger)indexForColor:(UIColor *)colour {
    NSParameterAssert([[self availableColors]containsObject:colour]);
    return [[self availableColors] indexOfObject:colour];
}

+ (NSArray *)availableColors {
    return @[[UIColor greenColor],
             [UIColor purpleColor],
             [UIColor orangeColor],
             [UIColor blueColor],
             [UIColor yellowColor],
             [UIColor orangeColor],
             [UIColor whiteColor]];
}

@end