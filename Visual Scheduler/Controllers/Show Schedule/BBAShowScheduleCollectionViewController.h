#import <UIKit/UIKit.h>
@class Schedule;
@class Pictogram;

@interface BBAShowScheduleCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) Schedule *schedule;

- (void)addPictogram:(Pictogram *)pictogram;

@end
