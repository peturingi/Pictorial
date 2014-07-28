#import <UIKit/UIKit.h>
#import "WeekDataSource.h"

@interface ScheduleCollectionViewController : UICollectionViewController
@property (weak, nonatomic) IBOutlet WeekDataSource *dataSource;

@end
