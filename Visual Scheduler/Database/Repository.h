#import <Foundation/Foundation.h>
#import "DataStoreProtocol.h"
#import "Schedule.h"

@interface Repository : NSObject {
    id<DataStoreProtocol> _dataStore;
}
- (id)initWithStore:(id<DataStoreProtocol>)store;
- (Schedule *)scheduleWithTitle:(NSString *)title withColor:(UIColor *)color;
@end
