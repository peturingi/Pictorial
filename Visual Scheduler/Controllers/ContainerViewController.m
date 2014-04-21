#import "ContainerViewController.h"
#import "PictogramsCollectionViewController.h"
#import "../CalendarView/CalendarCollectionViewController.h"
#import "../CalendarView/WeekCollectionViewLayout.h"

@interface ContainerViewController ()

@property (weak, nonatomic) PictogramsCollectionViewController *pictogramViewController;
@property (weak, nonatomic) CalendarCollectionViewController *calendarViewController;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [self setupChildViewControllers];
            [self setupGestureRecognizer];
}

- (void)setupChildViewControllers {
    [self setupCalendar];
    [self setupPictogramSelectorViewController];
}

- (void)setupCalendar {
    WeekCollectionViewLayout *layout = [[WeekCollectionViewLayout alloc] init];
    CalendarCollectionViewController *vc = [[CalendarCollectionViewController alloc] initWithCollectionViewLayout:layout];
    self.calendarViewController = vc;
    [self addChildViewController:vc];
    [self.topView addSubview:vc.view];
    
    // Fit the view within its contained view.
    self.calendarViewController.view.frame = self.topView.bounds;
}

- (void)setupPictogramSelectorViewController {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    PictogramsCollectionViewController *vc = [[PictogramsCollectionViewController alloc] initWithCollectionViewLayout:layout];
    self.pictogramViewController = vc;
    [self addChildViewController:vc];
    [self.bottomView addSubview:vc.view];
    
    // Fit the view of each controller within their contained views.
    self.pictogramViewController.view.frame = self.bottomView.bounds;
}

#pragma mark Gestures

- (void)setupGestureRecognizer {
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewGesture:)];
    CFTimeInterval requiredPressDuration = 0.1f;
    gr.minimumPressDuration = requiredPressDuration;
    [self.bottomView addGestureRecognizer:gr];
    
    UILongPressGestureRecognizer *deleteGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(topViewGesture:)];
    CFTimeInterval timeBeforeDelete = 0.1f;
    deleteGesture.minimumPressDuration = timeBeforeDelete;
    [self.topView addGestureRecognizer:deleteGesture];
}

- (void)topViewGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    static NSIndexPath *touchedItem = nil;
    CGPoint locationInTopView = [gestureRecognizer locationInView:self.calendarViewController.collectionView]; // Point in scrollview

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            touchedItem = [self.calendarViewController.collectionView indexPathForItemAtPoint:locationInTopView];
            NSLog(@"Touchdown at: %ld, %ld", (long)touchedItem.section, (long)touchedItem.item);
            [self.calendarViewController deleteItemAtIndexPath:touchedItem];
            touchedItem = nil;
            break;
            
        case UIGestureRecognizerStateChanged:
            break;
            
        case UIGestureRecognizerStateEnded:
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            break;
            
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (void)bottomViewGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    static UIView *draggedView = nil;
    static Pictogram *pictogramBeingDragged = nil;
    static CGRect pictogramOriginInBottomView;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint locationInTopView = [gestureRecognizer locationInView:self.topView];
        if ([self.topView pointInside:locationInTopView withEvent:nil])
            NSLog(@"top");
    
        CGPoint locationInBottomView = [gestureRecognizer locationInView:self.bottomView];
        if ([self.bottomView pointInside:locationInBottomView withEvent:nil]) {
            
            /* get pictogram being dragged */
            pictogramBeingDragged = [self.pictogramViewController pictogramAtPoint:locationInBottomView];
            CGRect frame = [self.pictogramViewController frameOfPictogramAtPoint:locationInBottomView];
            pictogramOriginInBottomView = [self.view convertRect:frame fromView:self.bottomView];
            
            CGPoint gestureLocationInView = [gestureRecognizer locationInView:self.view];
            
            /*  ImageView is placed within a View in order to mask to bounds
                without masking the desired shadow effect. */
            draggedView = [[UIView alloc] initWithFrame:pictogramOriginInBottomView];
            /* Shadow */
            [draggedView.layer setShadowColor:[UIColor blackColor].CGColor];
            [draggedView.layer setShadowOffset:CGSizeMake(0, 0)];
            [draggedView.layer setShadowOpacity:0.8f];
            [draggedView.layer setShadowRadius:10.0f];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:draggedView.bounds];
            [imageView setImage:pictogramBeingDragged.image];
            /* Border */
            [imageView.layer setBorderWidth:PICTOGRAM_BORDER_WIDTH];
            [imageView.layer setCornerRadius:PICTOGRAM_CORNER_RADIUS];
            [imageView.layer setBorderColor:[UIColor blackColor].CGColor];
            [imageView.layer setMasksToBounds:YES];
            
            [draggedView addSubview:imageView];
            [self.view addSubview:draggedView];
            
            CGRect destinationFrameForAnimation = CGRectMake(gestureLocationInView.x,
                                                             gestureLocationInView.y,
                                                             pictogramOriginInBottomView.size.width,
                                                             pictogramOriginInBottomView.size.height);
            /* The pictogram to be dragged animates to the fingers position. */
            // Center around the finger
            destinationFrameForAnimation.origin = [self centerOfRect:destinationFrameForAnimation];
            // Animate to finger
            [UIView animateWithDuration:0.1f
                             animations:^{
                                 draggedView.frame = destinationFrameForAnimation;
                             }completion:^(BOOL finished){
                                 if (finished) {
                                     draggedView.frame = destinationFrameForAnimation;
                                 }
                             }];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (draggedView != nil) {
            draggedView.frame = [self center:draggedView.frame at:[gestureRecognizer locationInView:self.view]];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded && pictogramBeingDragged != nil) {
        
        // Convert the point of the gesture recognizer, to the collection view, sinze the collection view is a scroll view
        // which might have been offset by scrolling.
        CGPoint locationInTopView = [gestureRecognizer locationInView:self.topView];
        CGPoint locationInCollectionView = [self.calendarViewController.collectionView convertPoint:locationInTopView fromView:self.topView];
        
        if ([self.topView pointInside:locationInTopView withEvent:nil]) {
            [self.calendarViewController sectionAtPoint:locationInCollectionView];
            [self.calendarViewController addPictogram:pictogramBeingDragged atIndexPath:[self.calendarViewController.collectionView indexPathForItemAtPoint:locationInCollectionView]];
            
            [draggedView removeFromSuperview];
            draggedView = nil;
            pictogramBeingDragged = nil;
            pictogramOriginInBottomView = CGRectNull;
        } else {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 draggedView.frame = pictogramOriginInBottomView;
                             }completion:^(BOOL finished){
                                 if (finished) {
                                     [draggedView removeFromSuperview];
                                     draggedView = nil;
                                     pictogramBeingDragged = nil;
                                     pictogramOriginInBottomView = CGRectNull;
                                 }
                             }];
        }
        

    } else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [draggedView removeFromSuperview];
        draggedView = nil;
        pictogramBeingDragged = nil;
    }
}

- (CGPoint)centerOfRect:(CGRect)aRect {
    aRect.origin.x -= aRect.size.width / 2.0f;
    aRect.origin.y -= aRect.size.height / 2.0f;
    return aRect.origin;
}

- (CGRect)center:(CGRect)aRect at:(CGPoint)aPoint {
    aRect.origin = aPoint;
    aRect.origin.x -= aRect.size.width / 2.0f;
    aRect.origin.y -= aRect.size.height / 2.0f;
    return aRect;
}

@end