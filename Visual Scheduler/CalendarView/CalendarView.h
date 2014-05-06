#import <UIKit/UIKit.h>
@class CalendarCell;

@interface CalendarView : UICollectionView
- (CalendarCell *)dequeueReusableCalendarCellForIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)dequeueReusableBackgroundColourViewforIndexPath:indexPath;
@end