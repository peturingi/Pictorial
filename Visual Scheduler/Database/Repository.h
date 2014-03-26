#import <Foundation/Foundation.h>
#import "DataStoreProtocol.h"
#import "Schedule.h"
#import "Pictogram.h"

@interface Repository : NSObject {
    id<DataStoreProtocol> _dataStore;
}
- (id)initWithStore:(id<DataStoreProtocol>)store;
- (Schedule *)scheduleWithTitle:(NSString *)title withColor:(UIColor *)color;
- (Pictogram *)pictogramWithTitle:(NSString *)title withImage:(UIImage *)image;
- (NSArray *)allSchedules;
- (NSArray *)allPictograms;
@end
