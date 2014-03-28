#import <UIKit/UIKit.h>
@class Schedule;
@class Pictogram;

@interface BBAShowScheduleCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) Schedule *schedule;
@property (strong, nonatomic) NSArray *dataSource;

- (void)addPictogram:(Pictogram *)pictogram;

@end
