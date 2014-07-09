#import "ExternalViewDataSource.h"
#import "Repository.h"
#import "Schedule.h"
#import "Pictogram.h"
#import "CalendarCell.h"
#define CELL_IDENTIFIER @"CALENDAR_CELL"

@implementation ExternalViewDataSource
-(id)init{
    self = [super init];
    if(self){
        _data = [[Repository defaultRepository] allSchedules];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    Schedule* schedule = [_data objectAtIndex:section];
    return [[schedule pictograms] count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    Schedule* schedule = [_data objectAtIndex:indexPath.section];
    Pictogram* pictogram = [schedule objectAtIndex:indexPath.item];
    [[cell imageView]setImage:[pictogram image]];
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView* view = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayOfWeekColor" forIndexPath:indexPath];
    view.backgroundColor = [[_data objectAtIndex:indexPath.section] color];
    return view;
}


@end