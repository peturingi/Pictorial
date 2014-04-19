#import <Foundation/Foundation.h>
#import "DataStoreProtocol.h"
#import "Schedule.h"
#import "Pictogram.h"

@interface Repository : NSObject {
    id<DataStoreProtocol> _dataStore;
}
- (id)initWithStore:(id<DataStoreProtocol>)store;
+ (instancetype)sharedStore;
- (Schedule *)scheduleWithTitle:(NSString *)title withColor:(UIColor *)color;
- (Pictogram *)pictogramWithTitle:(NSString *)title withImage:(UIImage *)image;
-(NSArray*)pictogramsForSchedule:(Schedule*)schedule includingImages:(BOOL)value;
- (void)removeAllPictogramsFromSchedule:(Schedule *)schedule;
-(void)addPictogram:(Pictogram*)pictogram toSchedule:(Schedule*)schedule atIndex:(NSInteger)index;
- (NSArray *)allSchedules;
- (NSArray *)allPictogramsIncludingImages:(BOOL)value;
- (void)deleteSchedule:(Schedule *)aSchedule;
-(UIImage*)imageForPictogram:(Pictogram*)pictogram;
@end
