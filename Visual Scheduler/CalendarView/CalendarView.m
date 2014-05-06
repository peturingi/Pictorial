#import "CalendarView.h"
#import "CalendarCell.h"
@implementation CalendarView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self registerViews];
    }
    return self;
}

- (void)registerViews {
    UINib *headerView = [UINib nibWithNibName:@"BackgroundColour" bundle:nil];
    [self registerNib:headerView forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DayOfWeekColour"];
    [self registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CALENDAR_CELL"];
}

- (CalendarCell *)dequeueReusableCalendarCellForIndexPath:(NSIndexPath *)indexPath {
    CalendarCell *cell = (CalendarCell *)[self dequeueReusableCellWithReuseIdentifier:@"CALENDAR_CELL" forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)dequeueReusableBackgroundColourViewforIndexPath:indexPath {
    UICollectionReusableView *view = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"DayOfWeekColour" forIndexPath:indexPath];
    return view;
}

@end