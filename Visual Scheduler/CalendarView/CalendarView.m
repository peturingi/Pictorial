#import "CalendarView.h"

@implementation CalendarView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self registerSupplementaryView];
    }
    return self;
}

- (void)registerSupplementaryView {
    UINib *headerView = [UINib nibWithNibName:@"BackgroundColor" bundle:nil];
    [self registerNib:headerView forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DAY_OF_WEEK_COLOR];
}

@end