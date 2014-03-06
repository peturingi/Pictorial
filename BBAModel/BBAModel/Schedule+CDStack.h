#import "Schedule.h"
#import "ModelProtocol.h"

@interface Schedule (CDStack) <ModelProtocol>
+(void)insertWithTitle:(NSString *)title logo:(Pictogram *)pictogram backGround:(NSUInteger)colorIndex;
@end