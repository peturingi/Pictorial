#import <Foundation/Foundation.h>
#import "DataStoreProtocol.h"
#import "Schedule.h"
#import "Pictogram.h"
#import "ImageCache.h"

@interface Repository : NSObject {
    id<DataStoreProtocol> _dataStore;
    ImageCache* _imageCache;
}
- (id)initWithStore:(id<DataStoreProtocol>)store;
+ (instancetype)defaultRepository;
- (Schedule *)scheduleWithTitle:(NSString *)title withColor:(UIColor *)color;
- (Pictogram *)pictogramWithTitle:(NSString *)title withImage:(UIImage *)image;
-(NSArray*)pictogramsForSchedule:(Schedule*)schedule;
- (void)removeAllPictogramsFromSchedule:(Schedule *)schedule;
-(void)addPictogram:(Pictogram*)pictogram toSchedule:(Schedule*)schedule atIndex:(NSInteger)index;
-(void)removePictogram:(Pictogram*)pictogram fromSchedule:(Schedule*)schedule atIndex:(NSInteger)index;
- (NSArray *)allSchedules;
- (NSArray *)allPictograms;
- (void)deleteSchedule:(Schedule *)aSchedule;
-(UIImage*)imageForPictogram:(Pictogram*)pictogram;


-(Pictogram*)pictogramForIdentifier:(NSInteger)identifier;
@end
