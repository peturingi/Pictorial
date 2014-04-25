#import <Foundation/Foundation.h>
#import "DataSourceCanAddPictogram.h"
@class Pictogram;

@interface WeekDataSource : NSObject <UICollectionViewDataSource, EditableDataSource>

@property (strong, nonatomic) NSMutableArray *schedules;
@property BOOL editing;

- (void)addPictogram:(Pictogram *)pictogram toCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;

@end