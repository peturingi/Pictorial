#import <UIKit/UIKit.h>
#import "WeekDataSource.h"

@class MasterViewController;

@interface ScheduleCollectionViewController : UICollectionViewController

@property (weak, nonatomic) IBOutlet WeekDataSource *dataSource;
@property (weak, nonatomic) MasterViewController *delegate;

/** Attempt to add the given pictogram to the schedule responsible for pictograms in the given point.
 @return YES the pictogram was added
 @return NO the pictogram was not added
 @note If the pictogram was not added, it is because it was released in an area which does not represent a schedule.
 */
- (BOOL)addPictogramWithID:(NSManagedObjectID * const)objectID atPoint:(CGPoint const)point relativeToView:(UIView *)view;

@end
