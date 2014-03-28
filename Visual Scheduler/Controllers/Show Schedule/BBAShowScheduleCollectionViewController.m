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
        UICollectionViewCell *closestCell = [self cellInCollectionViewClosestTo:selectedImage];
        NSIndexPath *indexOfClosestCell = [self.collectionView indexPathForCell:closestCell];
//        NSIndexPath *indexOfSelectedImage;
        
        if (closestCell != selectedCell) {
            CGPoint centerOfSelectedImageRelativeToCollectionView = [self.collectionView convertPoint:selectedImage.center fromView:self.view];
            NSLog(@"selected: %f,%f", centerOfSelectedImageRelativeToCollectionView.x, centerOfSelectedImageRelativeToCollectionView.y);
            CGPoint centerOfClosestCellRelativeToCollectionView = [self.view convertPoint:closestCell.center fromView:self.view];
            NSLog(@"closest: %f,%f", centerOfClosestCellRelativeToCollectionView.x, centerOfClosestCellRelativeToCollectionView.y);

            BOOL isSelectedImageBelowClosestCell = centerOfSelectedImageRelativeToCollectionView.y > centerOfClosestCellRelativeToCollectionView.y ? YES : NO;
            NSLog(@"Below? %d", isSelectedImageBelowClosestCell);
            
            
            NSInteger arrayPositionOfSelectedCell = [self.dataSource indexOfObject:selectedPictogram];
            NSInteger arrayPosOfClosestPictogram = [self.dataSource indexOfObject:((PictogramCollectionViewCell *)closestCell).pictogram];
            NSInteger arrayPosTargetForPictogram = -1; // To throw exception if failed to be changed.
            
            NSMutableArray *newDataSource = [NSMutableArray arrayWithArray:self.dataSource];
            
            if (arrayPositionOfSelectedCell < arrayPosOfClosestPictogram) {
            /* Moving pictogram down the list */
            /*
             on lower part
             x = pos of target item
             delete current item
             insert current item at x
             */
                /*
                 on upper part
                 x = pos of target item - 1
                 delete current item
                 insert current item at x
                 
                 ..
                 */
                if (isSelectedImageBelowClosestCell) {
                    arrayPosTargetForPictogram = arrayPosOfClosestPictogram;
                    [newDataSource removeObject:selectedPictogram];
                    [newDataSource insertObject:selectedPictogram atIndex:arrayPosTargetForPictogram];
                } else {
                    arrayPosTargetForPictogram = arrayPosOfClosestPictogram - 1;
                    [newDataSource removeObject:selectedPictogram];
                    [newDataSource insertObject:selectedPictogram atIndex:arrayPosTargetForPictogram];
                }


            } else if (arrayPositionOfSelectedCell > arrayPosOfClosestPictogram) {
                /* Moving pictogram up the list */
                /*
                 is below, moved up
                 
                 on lower part
                 x = pos of target item
                 delete current item
                 insert current item at x+1
                 
                 on upper part
                 x = pos of target item
                 delete current item
                 insert current item at x
                 */
                if (isSelectedImageBelowClosestCell) {
                    arrayPosTargetForPictogram = arrayPosOfClosestPictogram + 1;
                    [newDataSource removeObject:selectedPictogram];
                    [newDataSource insertObject:selectedPictogram atIndex:arrayPosTargetForPictogram];
                } else {
                    arrayPosTargetForPictogram = arrayPosOfClosestPictogram;
                    [newDataSource removeObject:selectedPictogram];
                    [newDataSource insertObject:selectedPictogram atIndex:arrayPosTargetForPictogram];
                }

            } else {
                // Closest pictogram was the pictogram being dragged. Could indicate that user wanted to abort. Do Nothing.
            }
            
            
            
            

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
