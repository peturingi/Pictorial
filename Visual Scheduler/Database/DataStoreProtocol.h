#import <Foundation/Foundation.h>

@protocol DataStoreProtocol <NSObject>

@required
- (NSArray *)contentOfAllSchedules;
- (NSInteger)createSchedule:(NSDictionary *)content;
- (void)deleteScheduleWithID:(NSInteger)identifier;

- (NSArray *)contentOfAllPictograms;
- (NSInteger)createPictogram:(NSDictionary *)content;
- (BOOL)deletePictogramWithID:(NSInteger)identifier;

- (NSArray *)contentOfAllPictogramsInSchedule:(NSInteger)identifier;

- (void)addPictogram:(NSInteger)pictogramIdentifier toSchedule:(NSInteger)scheduleIdentifier atIndex:(NSInteger)index;
- (void)removePictogram:(NSInteger)pictogramIdentifier fromSchedule:(NSInteger)scheduleIdentifier atIndex:(NSInteger)index;

@optional
- (BOOL)closeStore;

@end