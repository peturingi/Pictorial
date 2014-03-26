#import <Foundation/Foundation.h>

@protocol DataStoreProtocol <NSObject>

@required
- (NSArray *)contentOfAllSchedules;
- (NSInteger)createSchedule:(NSDictionary *)content;
- (void)deleteScheduleWithID:(NSInteger)identifier;

- (NSArray *)contentOfAllPictograms;
- (NSInteger)createPictogram:(NSDictionary *)content;
- (BOOL)deletePictogramWithID:(NSInteger)identifier;

@optional
- (BOOL)closeStore;

@end