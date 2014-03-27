#import "BBAShowScheduleCollectionViewController.h"
#import "PictogramCollectionViewCell.h"
#import "BBAColor.h"
#import "Pictogram.h"

@interface BBAShowScheduleCollectionViewController ()

@end

@implementation BBAShowScheduleCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [self configureBackground];
}

- (void)configureBackground {
    [self.collectionView setBackgroundColor:[self.schedule color]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    return self.dataSource.count;
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
    Pictogram *pictogramToDisplay = [self.dataSource objectAtIndex:indexPath.row];
    [pictogramImage setImage:pictogramToDisplay.image];
    [(PictogramCollectionViewCell *)cell setPictogram:pictogramToDisplay];
    return cell;
}
- (IBAction)longPressGesture:(id)sender {
    NSAssert([[sender class] isSubclassOfClass:[UIGestureRecognizer class]],
             @"Only gesture recognizers should call this method.");
    
    static PictogramCollectionViewCell *selectedCell;
    static Pictogram *selectedPictogram;
    static CGRect originalPosition;
    static UIImageView *selectedImage;
    
    UIGestureRecognizer *gr = (UIGestureRecognizer *)sender;
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint gestureLocation = [gr locationInView:self.collectionView];
        NSIndexPath *indexOfSelectedCell = [self.collectionView indexPathForItemAtPoint:gestureLocation];
        if (indexOfSelectedCell != nil) {
            selectedCell = (PictogramCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexOfSelectedCell];
            [self toggleMarkCellAsOldCell:selectedCell];
            selectedPictogram = [selectedCell pictogram];
            selectedImage = [[UIImageView alloc] initWithFrame:selectedCell.frame];
            selectedImage.image = selectedPictogram.image;
            [self markViewAsBeingDragged:selectedImage];
            CGPoint touchLocation = [gr locationInView:self.view];
            CGRect imageLocation = selectedImage.frame;
            originalPosition = imageLocation;
            imageLocation.origin = touchLocation;
            imageLocation.origin.x -= imageLocation.size.width / 2.0f;
            imageLocation.origin.y -= imageLocation.size.height / 2.0f;
            [selectedImage setFrame:imageLocation];
            [self.view addSubview:selectedImage];
        }
    } else
        if (gr.state == UIGestureRecognizerStateChanged) {
            CGPoint touchLocation = [gr locationInView:self.view];
            CGRect imageLocation = selectedImage.frame;
            imageLocation.origin = touchLocation;
            imageLocation.origin.x -= imageLocation.size.width / 2.0f;
            imageLocation.origin.y -= imageLocation.size.height / 2.0f;
            [selectedImage setFrame:imageLocation];
    } else
    if (gr.state == UIGestureRecognizerStateEnded) {
        CGPoint touchUpLocation = [gr locationInView:self.collectionView];
        
        NSIndexPath *indexOfCellNearTouchup = [self.collectionView indexPathForItemAtPoint:touchUpLocation];
        PictogramCollectionViewCell *cellUnderTouch = (PictogramCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexOfCellNearTouchup];
        if (!cellUnderTouch) {
            NSLog(@"No cell");
            // Find closest cell.
        }
        
        if (cellUnderTouch != selectedCell) {
            CGPoint gesturesLocationInCell = [gr locationInView:cellUnderTouch.contentView];
            NSInteger cellsHeight = cellUnderTouch.contentView.frame.size.height;
            BOOL upperPartOfCell = gesturesLocationInCell.y < (cellsHeight / 2);
            NSMutableArray *newDataSource = [NSMutableArray arrayWithArray:self.dataSource];
            
            BOOL movingUpTheSchedule = [newDataSource indexOfObject:selectedPictogram]  < indexOfCellNearTouchup.row ? NO : YES;
            NSUInteger targetIndexForPictogram = upperPartOfCell ? indexOfCellNearTouchup.row-1 : indexOfCellNearTouchup.row;
            if (movingUpTheSchedule) targetIndexForPictogram++;
            [newDataSource removeObject:selectedPictogram];
            [newDataSource insertObject:selectedPictogram atIndex:targetIndexForPictogram];
            
            [self setDataSource:newDataSource];

            [self reloadCollectionViewWithAnimation];
        } else {
            [self toggleMarkCellAsOldCell:selectedCell];
        }
        
        selectedCell = nil;
        selectedPictogram = nil;
        originalPosition = CGRectZero;
        [selectedImage removeFromSuperview];
        selectedImage = nil;
        
            // Check if can relocate
    } else
    if (gr.state == UIGestureRecognizerStateCancelled) {
        // Abort
    }
}

- (void)toggleMarkCellAsOldCell:(UICollectionViewCell *)cell {
    if (cell.alpha > 0.51f)
        cell.alpha = 0.5f;
    else
        cell.alpha = 1.0f;
}

- (void)markViewAsBeingDragged:(UIView *)view {
}

- (void)reloadCollectionViewWithAnimation {
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
}





@end
