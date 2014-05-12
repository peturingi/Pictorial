#import "WeekDataSource.h"
#import "../Database/Repository.h"
#import "CalendarCell.h"
#import "Schedule.h"
#import "CalendarView.h"

#define NUMBER_OF_DAYS_IN_WEEK 7

@implementation WeekDataSource

- (id)init {
    self = [super init];
    if (self) {
// TODO here we should not assume that there are only 7 schedules. Must get only 7 schedules.
        _schedules = [NSMutableArray arrayWithArray:[Schedule allSchedules]];
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
    NSParameterAssert(collectionView);
    NSParameterAssert(indexPath);
    
    if (!self.editing) {
        [NSException raise:NSInternalInconsistencyException format:@"Trying to modify the datasource while it is not in edit mode."];
    } else  if (indexPath && collectionView) {
        const NSUInteger numberOfItemsInSection = [self collectionView:collectionView numberOfItemsInSection:indexPath.section];
        const NSUInteger itemToDelete = indexPath.item;
        const NSUInteger sectionToDeleteFrom = indexPath.section;
        if (itemToDelete < numberOfItemsInSection-1) {
            Schedule *schedule = [self.schedules objectAtIndex:sectionToDeleteFrom];
            [schedule removePictogramAtIndex:itemToDelete];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
}


- (void)dealloc {
    _schedules = nil;
}

@end