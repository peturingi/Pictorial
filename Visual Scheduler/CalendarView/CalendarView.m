#import "CalendarView.h"

@implementation CalendarView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self registerSupplementaryView];
    }
    NSAssert(self, @"Failed to init");
    return self;
}

- (void)registerSupplementaryView {
    UINib *headerView = [UINib nibWithNibName:@"DayHeader" bundle:nil];
    if (headerView == nil) @throw [NSException exceptionWithName:@"Failed to load nib." reason:@"Unknown" userInfo:nil];
    [self registerNib:headerView forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DAY_HEADER];
}

@end