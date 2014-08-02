#import "NSArray+ObjectsOfType.h"

@implementation NSArray (ObjectsOfType)

- (NSArray *)objectsOfType:(Class)class {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id obj in self) {
        if ([obj isKindOfClass:class]) [result addObject:obj];
    }
    return result;
}

@end
