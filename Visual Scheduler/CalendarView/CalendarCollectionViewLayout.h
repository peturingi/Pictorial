#import <UIKit/UIKit.h>

@interface CalendarCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) IBOutlet id<UICollectionViewDataSource> dataSource;

- (id)init __unavailable;

@end