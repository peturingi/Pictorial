#import "CalendarCell.h"
#import "CalendarView.h"
#import "Repository.h"
#import "Schedule.h"
#import "WeekDataSource.h"

@implementation WeekDataSource

- (id)init {
    self = [super init];
    if (self) {
        _schedules = [NSMutableArray arrayWithArray:[Schedule allSchedules]];
        NSAssert(self.schedules.count == NUMBER_OF_DAYS_IN_WEEK, @"A week must consist of 7 schedules.");
    }
    return self;
}

- (void)dealloc {
    _schedules = nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Schedule *schedule = [self.schedules objectAtIndex:section];
    NSInteger numberOfItems = schedule.pictograms.count;
    NSAssert(numberOfItems >= 0, @"Invalid number of items: %ld. Must be >=0", (long)numberOfItems);
    if (self.editing) {
        // Make space for 'drag here' pictogram.
        numberOfItems++;
    }
    return numberOfItems;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger numberOfSections = self.schedules.count;
    NSAssert(numberOfSections == NUMBER_OF_DAYS_IN_WEEK, @"A week must consist of 7 schedules.");
    return numberOfSections;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCell *cell = [(CalendarView *)collectionView dequeueReusableCalendarCellForIndexPath:indexPath];
    Schedule *schedule = [self.schedules objectAtIndex:indexPath.section];
    
    // Shows empty box below each schedule in edit mode.
    if (indexPath.item < schedule.count) {
        Pictogram *pictogram = [schedule.pictograms objectAtIndex:indexPath.item];
        cell.imageView.image = pictogram.image;
    }
    else if (self.editing && indexPath.item == schedule.count) {
        cell.imageView.image = nil;
    }
    else {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Invalid state: editing:%d, number of pictograms:%ld", self.editing, (long)schedule.count];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [(CalendarView *)collectionView dequeueReusableBackgroundColourViewforIndexPath:indexPath];
    NSAssert(view, @"Failed to dequeue reusable view.");
    Schedule *schedule = [_schedules objectAtIndex:indexPath.section];
    view.backgroundColor = schedule.color;
    return view;
}

@end