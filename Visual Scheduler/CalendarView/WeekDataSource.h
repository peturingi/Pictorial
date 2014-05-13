#import <Foundation/Foundation.h>

@interface WeekDataSource : NSObject <UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *schedules;
@property BOOL editing;

@end