#import "CalendarView.h"
#import "CalendarCell.h"

@implementation CalendarView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"BackgroundColour" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DayOfWeekColour"];
        [self registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CALENDAR_CELL"];
    }
    return self;
}

@end