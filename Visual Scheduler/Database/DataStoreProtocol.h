#import <Foundation/Foundation.h>

@protocol DataStoreProtocol <NSObject>

@required
- (NSArray *)contentOfAllSchedules;
- (NSInteger)createSchedule:(NSDictionary *)content;
- (void)deleteScheduleWithID:(NSInteger)identifier;

- (NSArray *)contentOfAllPictograms;

@optional
- (BOOL)closeStore;

@end