#import <Foundation/Foundation.h>

@interface CalendarDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *data;
@property BOOL editing;

@end