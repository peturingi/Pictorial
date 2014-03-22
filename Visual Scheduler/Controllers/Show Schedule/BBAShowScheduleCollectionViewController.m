#import "BBAShowScheduleCollectionViewController.h"
#import "BBAColor.h"
#import "Pictogram.h"

@interface BBAShowScheduleCollectionViewController ()

@end

@implementation BBAShowScheduleCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [self configureBackground];
}

- (void)configureBackground {
    [self.collectionView setBackgroundColor:[BBAColor colorForIndex:self.schedule.colour.integerValue]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    return self.schedule.pictograms.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"schedulesPictogram" forIndexPath:indexPath];
    [cell setBackgroundColor:[cell.superview backgroundColor]];
    
    UIImageView *pictogramImage;
    for (UIView *subview in cell.contentView.subviews) {
        if (subview.tag == 6472) {
            pictogramImage = (UIImageView *)subview;
            break;
        }
    }
    Pictogram *pictogramToDisplay = [self.schedule.pictograms objectAtIndex:indexPath.row];
    [pictogramImage setImage:[UIImage imageWithContentsOfFile:pictogramToDisplay.imageURL]];
    
    return cell;
}


@end
