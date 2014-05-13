#import <Foundation/Foundation.h>
#import "Schedule.h"
#import "DataSourceCanAddRemovePictogram.h"

@interface DayDataSource : NSObject  <UICollectionViewDataSource, UICollectionViewDelegate, EditableDataSource> {
    Schedule *schedule;
}

@property BOOL editing;

- (id)initWithScheduleNumber:(NSUInteger)number;
- (void)addPictogram:(Pictogram *)pictogram toCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;

@end