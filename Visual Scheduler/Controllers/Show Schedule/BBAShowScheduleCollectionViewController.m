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

- (UIImageView *)imageViewWithPictogramIn:(PictogramCollectionViewCell *)cell {
    NSParameterAssert(cell != nil);
    UIImage *pictogram = [cell.pictogram image];
    NSAssert(pictogram != nil, @"Failed to get image for pictogram.");
    return [[UIImageView alloc] initWithImage:pictogram];
}

- (IBAction)longPressGesture:(id)sender {
    UIGestureRecognizer *gr = (UIGestureRecognizer *)sender;
    
    static PictogramCollectionViewCell *selectedCell;
    static Pictogram *selectedPictogram;
    static CGRect originalPosition;
    static UIImageView *selectedImage;

    if (gr.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexOfSelectedCell = [self.collectionView indexPathForItemAtPoint:[gr locationInView:self.collectionView]];
        if (indexOfSelectedCell != nil) {
            selectedCell = (PictogramCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexOfSelectedCell];
            [self toggleMarkCellAsOldCell:selectedCell];
            
            originalPosition = selectedCell.frame;
            selectedPictogram = selectedCell.pictogram;
            
            selectedImage = [self imageViewWithPictogramIn:selectedCell];
            selectedImage.frame = [self center:selectedCell.frame at:[gr locationInView:self.view]];
            [self markViewAsBeingDragged:selectedImage];
            [self.view addSubview:selectedImage];
        }
    } else
        if (gr.state == UIGestureRecognizerStateChanged) {
            selectedImage.frame = [self center:selectedImage.frame at:[gr locationInView:self.view]];
    } else
    if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled) {
        UICollectionViewCell *closestCell = [self cellInCollectionViewClosestTo:selectedImage];
        
        CGRect frameOfSelectedImage = [self.collectionView convertRect:selectedImage.frame fromView:self.view];
        CGRect frameOfClosestCell = [self.view convertRect:closestCell.frame fromView:self.view];
        BOOL framesIntersect = CGRectIntersectsRect(frameOfSelectedImage, frameOfClosestCell);
        
        if (framesIntersect) {
            if (closestCell != selectedCell) {
                CGPoint centerOfSelectedImage = [self.collectionView convertPoint:selectedImage.center fromView:self.view];
                CGPoint centerOfClosestCell = [self.view convertPoint:closestCell.center fromView:self.view];
                BOOL destinationIsBelowClosestCell = centerOfSelectedImage.y > centerOfClosestCell.y ? YES : NO;
                
                NSInteger indexOfSelectedCell = [self.dataSource indexOfObject:selectedPictogram];
                NSInteger indexOfClosestPictogram = [self.dataSource indexOfObject:((PictogramCollectionViewCell *)closestCell).pictogram];
                
                NSMutableArray *newDataSource = [NSMutableArray arrayWithArray:self.dataSource];
                if (indexOfSelectedCell < indexOfClosestPictogram) {
                    if (destinationIsBelowClosestCell) {
                        [self moveObject:selectedPictogram in:newDataSource toIndex:indexOfClosestPictogram];
                    } else {
                        [self moveObject:selectedPictogram in:newDataSource toIndex:indexOfClosestPictogram-1];
                    }
                } else if (indexOfSelectedCell > indexOfClosestPictogram) {
                    if (destinationIsBelowClosestCell) {
                        [self moveObject:selectedPictogram in:newDataSource toIndex:indexOfClosestPictogram+1];
                    } else {
                        [self moveObject:selectedPictogram in:newDataSource toIndex:indexOfClosestPictogram];
                    }
                }
                [self setDataSource:newDataSource];
                [self reloadCollectionViewWithAnimation];
            } else {
                [self toggleMarkCellAsOldCell:selectedCell];
            }
            selectedCell = nil;
            selectedPictogram = nil;
            [selectedImage removeFromSuperview];
            selectedImage = nil;
        } else {
            [UIView animateWithDuration:0.5f animations:^{
                selectedImage.frame = [self.collectionView convertRect:originalPosition toView:self.view];
            }
                             completion:^(BOOL finished) {
                                 if (finished) {
                                     [selectedImage removeFromSuperview];
                                     selectedImage = nil;
                                     [self toggleMarkCellAsOldCell:selectedCell];
                                     selectedCell = nil;
                                     selectedPictogram = nil;
                                 }
                             }];

        }
    }
}

- (void)moveObject:(id)obj in:(NSMutableArray *)array toIndex:(NSInteger)index {
    [array removeObject:obj];
    [array insertObject:obj atIndex:index];
}

- (CGRect)center:(CGRect)aRect at:(CGPoint)aPoint {
    aRect.origin = aPoint;
    aRect.origin.x -= aRect.size.width / 2.0f;
    aRect.origin.y -= aRect.size.height / 2.0f;
    return aRect;
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

- (UICollectionViewCell *)cellInCollectionViewClosestTo:(UIView *)source {
    NSInteger shortedEuclidianDistanceFound = INT64_MAX;
    UIView *closestView;
    CGPoint centerOfSource = [self.collectionView convertPoint:source.center fromView:self.view];
    NSLog(@"Center of source: %f,%f", centerOfSource.x, centerOfSource.y);
    for (UIView *subview in self.collectionView.subviews) {
        if ([self isViewAVisibleCollectionViewCell:subview] == YES) {
            CGPoint centerOfSubview = [self.view convertPoint:subview.center fromView:self.view];
            PictogramCollectionViewCell *pv = (PictogramCollectionViewCell*)subview;
            NSLog(@"%@ at %f,%f", pv.pictogram.title, centerOfSubview.x, centerOfSubview.y);
            CGFloat distanceToSubview = sqrtf(powf(centerOfSource.x - centerOfSubview.x, 2.0f) + powf(centerOfSource.y - centerOfSubview.y, 2.0f));
            
            if (distanceToSubview < shortedEuclidianDistanceFound) {
                shortedEuclidianDistanceFound = distanceToSubview;
                closestView = subview;
            }
        }
    }
    NSLog(@"Closest was %@", [(PictogramCollectionViewCell*)closestView pictogram].title);
    return (UICollectionViewCell *)closestView;
}

- (BOOL)isViewAVisibleCollectionViewCell:(UIView *)aView {
    if ([aView isKindOfClass:[UICollectionViewCell class]] == NO) {
        return NO;
    }
    if (aView.isHidden == YES) {
        return NO;
    }
    return YES;
}

@end