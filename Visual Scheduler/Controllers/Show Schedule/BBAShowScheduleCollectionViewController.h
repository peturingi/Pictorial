#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface BBAShowScheduleCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) Schedule *schedule;
@property (strong, nonatomic) NSArray *dataSource;

@end
