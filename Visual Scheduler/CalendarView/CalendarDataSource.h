#import <Foundation/Foundation.h>

@interface CalendarDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSArray *_schedules;
}

@end