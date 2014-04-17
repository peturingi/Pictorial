#import "CalendarView.h"

@implementation CalendarView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"BackgroundColour" bundle:nil]
              forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                     withReuseIdentifier:@"DayOfWeekColour"];
    }
    return self;
}

@end