#import "NSMutableArray+MoveObject.h"

@implementation NSMutableArray (MoveObject)
- (void)moveObject:(id)obj toIndex:(NSInteger)index {
    if (obj == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"obj was nil." userInfo:nil];
    if (index < 0) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"index out of bounds." userInfo:nil];
    [self removeObject:obj];
    [self insertObject:obj atIndex:index];
}
@end
