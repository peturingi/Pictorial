#import "DayDataSource.h"
#import "../Database/Repository.h"
#import "CalendarCell.h"
#import "../Protocols/ImplementsCount.h"
#import "../Protocols/ContainsImage.h"

#define CELL_IDENTIFIER @"CALENDAR_CELL"

@implementation DayDataSource

- (id)init {
    NSAssert(NO, @"Use initWithScheduleNumber:");
    return self;
}

- (id)initWithScheduleNumber:(NSUInteger)number {
    self = [super init];
    if (self) {
        schedule = [[Repository defaultRepository] scheduleNumber:number];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.editing ? schedule.pictograms.count + 1 : schedule.pictograms.count);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCell *cell = (CalendarCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Shows empty box below each schedule in edit mode.
    if (indexPath.item < schedule.pictograms.count) {
        Pictogram *pictogram = [schedule.pictograms objectAtIndex:indexPath.item];
        cell.imageView.image = pictogram.image;
    } else if (self.editing && indexPath.item == schedule.pictograms.count) {
        cell.imageView.image = nil;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DayOfWeekColour" forIndexPath:indexPath];
    view.backgroundColor = schedule.color;
    return view;
}

- (void)addPictogram:(Pictogram *)pictogram toCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
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
        if (itemToDelete < numberOfItemsInSection-1) {
            [schedule removePictogramAtIndex:itemToDelete];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
}

@end