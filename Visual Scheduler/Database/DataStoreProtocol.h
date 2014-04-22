#import <Foundation/Foundation.h>
#define ID_KEY @"id"
#define COLOR_KEY @"color"
#define TITLE_KEY @"title"
#define IMAGE_KEY @"image"

@protocol DataStoreProtocol <NSObject>

@required
- (NSArray *)contentOfAllSchedules;
- (NSInteger)createSchedule:(NSDictionary *)content;
- (void)deleteScheduleWithID:(NSInteger)identifier;

- (NSArray *)contentOfAllPictogramsIncludingImageData:(BOOL)includesData;
- (NSInteger)createPictogram:(NSDictionary *)content;
- (BOOL)deletePictogramWithID:(NSInteger)identifier;
- (NSArray*)imageContentOfPictogramWithID:(NSInteger)identifier;
-(NSArray*)contentOfPictogramWithID:(NSInteger)identifier;
- (NSArray *)contentOfAllPictogramsInSchedule:(NSInteger)identifier includingImageData:(BOOL)includesData;

- (void)addPictogram:(NSInteger)pictogramIdentifier toSchedule:(NSInteger)scheduleIdentifier atIndex:(NSInteger)index;
- (void)removePictogram:(NSInteger)pictogramIdentifier fromSchedule:(NSInteger)scheduleIdentifier atIndex:(NSInteger)index;

@optional
- (BOOL)closeStore;

@end