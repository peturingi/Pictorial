#import "CalendarDataSource.h"
#import "../Database/Repository.h"
#import "CalendarCell.h"
#import "../Protocols/ImplementsCount.h"
#import "../Protocols/ContainsImage.h"

#define CELL_IDENTIFIER @"CALENDAR_CELL"

@implementation CalendarDataSource

- (id)init {
    self = [super init];
    if (self) {
        _data = [NSMutableArray arrayWithArray:[[Repository defaultRepository] allSchedules]];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<ImplementsCount> obj = [_data objectAtIndex:section];
    return (self.editing ? obj.count + 1 : obj.count);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCell *cell = (CalendarCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    id<ImplementsObjectAtIndex> selectedSection = [_data objectAtIndex:indexPath.section];
    
    // Shows empty box below each schedule in edit mode.
    if (indexPath.item < ((NSArray *)selectedSection).count) {
        id<ContainsImage> objcontainingImage = [selectedSection objectAtIndex:indexPath.item];
        cell.imageView.image = objcontainingImage.image;
    } else if (self.editing && indexPath.item == ((NSArray *)selectedSection).count) {
        cell.imageView.image = nil;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DayOfWeekColour" forIndexPath:indexPath];
    view.backgroundColor = [[_data objectAtIndex:indexPath.section] valueForKey:@"color"]; // TODO fix this. Not very safe to use KVC here.
    return view;
}

@end