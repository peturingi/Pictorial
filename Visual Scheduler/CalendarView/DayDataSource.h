#import <Foundation/Foundation.h>
#import "Schedule.h"
#import "DataSourceCanAddPictogram.h"

@interface DayDataSource : NSObject  <UICollectionViewDataSource, UICollectionViewDelegate, DataSourceCanAddPictogram> {
    Schedule *schedule;
}

@property BOOL editing;

- (id)initWithScheduleNumber:(NSUInteger)number;
- (void)addPictogram:(Pictogram *)pictogram toCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;

@end