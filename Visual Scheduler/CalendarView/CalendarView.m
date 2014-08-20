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
    NSAssert(headerView, @"Failed to load nib.");
    [self registerNib:headerView forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DAY_HEADER];
    
    UINib *footerView = [UINib nibWithNibName:@"DayFooter" bundle:nil];
    NSAssert(footerView, @"Failed to load nib.");
    [self registerNib:footerView forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DAY_FOOTER];
}

@end