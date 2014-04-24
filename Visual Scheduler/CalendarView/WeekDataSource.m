#import "WeekDataSource.h"
#import "../Database/Repository.h"
#import "CalendarCell.h"
#import "../Protocols/ImplementsCount.h"
#import "../Protocols/ContainsImage.h"
#import "Schedule.h"

#define CELL_IDENTIFIER @"CALENDAR_CELL"

#define NUMBER_OF_DAYS_IN_WEEK 7

@implementation WeekDataSource

- (id)init {
    self = [super init];
    if (self) {
// TODO here we should not assume that there are only 7 schedules. Must get only 7 schedules.
        _schedules = [NSMutableArray arrayWithArray:[[Repository defaultRepository] allSchedules]];
        NSAssert(self.schedules.count == NUMBER_OF_DAYS_IN_WEEK, @"A week must consist of 7 schedules.");
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Schedule *schedule = [self.schedules objectAtIndex:section];
    NSInteger numberOfItems = schedule.pictograms.count;
    NSAssert(numberOfItems >= 0, @"Invalid number of items. Must be >=0");
    if (self.editing ) {
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
    CalendarCell *cell = (CalendarCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
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
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DayOfWeekColour" forIndexPath:indexPath];
    Schedule *schedule = [_schedules objectAtIndex:indexPath.section];
    view.backgroundColor = schedule.color;
    return view;
}

- (void)addPictogram:(Pictogram *)pictogram toCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    Schedule *schedule = [self.schedules objectAtIndex:indexPath.section];
    [schedule addPictogram:pictogram atIndex:indexPath.item];
    [collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void)deletePictogramInCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    Schedule *schedule = [self.schedules objectAtIndex:indexPath.section];
    [schedule removePictogramAtIndex:indexPath.item];
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)dealloc {
    _schedules = nil;
}

@end