#import <Foundation/Foundation.h>

@interface NSMutableArray (MoveObject)
- (void)moveObject:(id)obj toIndex:(NSInteger)index;
@end
