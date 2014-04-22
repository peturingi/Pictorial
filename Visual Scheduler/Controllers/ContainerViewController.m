#import <QuartzCore/CAAnimation.h>
#import "ContainerViewController.h"
#import "PictogramsCollectionViewController.h"
#import "../CalendarView/CalendarCollectionViewController.h"
#import "../CalendarView/WeekCollectionViewLayout.h"

@interface ContainerViewController ()

@property (weak, nonatomic) PictogramsCollectionViewController *pictogramViewController;
@property (weak, nonatomic) CalendarCollectionViewController *calendarViewController;

@end

@implementation ContainerViewController

- (id)init {
    NSAssert(false, @"Use initWithCoder");
    return nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSAssert(false, @"Use initWithCoder");
    return nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        isShowingBottomView = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [self setupCalendar];
#warning possible race condition, if childViewControllers are not initialized before the gestureRecognizers try to addthemselfs.
    [self setupGestureRecognizer];
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

#pragma mark - User Interaction

- (IBAction)toggleEditing:(id)sender {
    if (self.editing == NO) {
        [self showPictogramSelector];
        self.editing = YES;
    } else {
        [self restoreCalendarHeight];
        [self hidePictogramSelector];
        self.editing = NO;
    }

    [self.calendarViewController setEditing:self.editing animated:YES];
    topViewGestureRecognizer.enabled = self.editing;
    bottomViewGestureRecognizer.enabled = self.editing;
}

- (void)setupPictogramSelectorViewController {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    PictogramsCollectionViewController *vc = [[PictogramsCollectionViewController alloc] initWithCollectionViewLayout:layout];
    vc.view.frame = self.bottomView.bounds;
    [self addChildViewController:vc];
    [self.bottomView addSubview:vc.view];
    self.pictogramViewController = vc;
    
    // Shadow
    self.bottomView.layer.shadowRadius = 10.0f;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;    
}

- (void)showPictogramSelector {
    if (self.pictogramViewController == nil) {
        [self setupPictogramSelectorViewController];
    }
    isShowingBottomView = YES;
    self.bottomView.layer.shadowOpacity = 0.8f;
    
    CGRect frame = self.view.frame;
    // Cover 1/3 of the screen
    frame.origin = CGPointMake(self.view.frame.origin.x,
                               self.view.bounds.origin.y + self.view.bounds.size.height/3.0f * 2.0f);
    frame.size = CGSizeMake(self.view.frame.size.width,
                            self.view.bounds.origin.y + self.view.frame.size.height/3.0f);
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomView.frame = frame;
    }completion:^(BOOL completed){
        if (completed) {
            self.bottomView.frame = frame;
            [self shrinkCalendarbyOneThirdItsHeightFromBottom];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
}

- (void)shrinkCalendarbyOneThirdItsHeightFromBottom {
    CGRect frame = self.topView.frame;
    frame.size.height -= frame.size.height / 3.0f;
    self.topView.frame = frame;
}

- (void)restoreCalendarHeight {
    self.topView.frame = self.view.bounds;
}

- (void)hidePictogramSelector {
    isShowingBottomView = NO;
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(self.view.frame.origin.x,
                               self.view.bounds.origin.y + self.view.bounds.size.height);
    frame.size = self.bottomView.frame.size;
    self.navigationItem.rightBarButtonItem.enabled = NO;

    [UIView animateWithDuration:0.3f animations:^{
        self.bottomView.frame = frame;
    }completion:^(BOOL completed){
        if (completed) {
            self.bottomView.layer.shadowOpacity = 0.0f;
            self.bottomView.frame = frame;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            [self.pictogramViewController removeFromParentViewController];
            self.pictogramViewController = nil;
        }
    }];
}

#pragma mark Gestures

- (void)setupGestureRecognizer {
    bottomViewGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewGesture:)];
    CFTimeInterval requiredPressDuration = 0.1f;
    bottomViewGestureRecognizer.minimumPressDuration = requiredPressDuration;
    bottomViewGestureRecognizer.enabled = NO;
    [self.bottomView addGestureRecognizer:bottomViewGestureRecognizer];
    
    topViewGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(topViewGesture:)];
    CFTimeInterval timeBeforeDelete = 0.1f;
    topViewGestureRecognizer.minimumPressDuration = timeBeforeDelete;
    topViewGestureRecognizer.enabled = NO;
    [self.topView addGestureRecognizer:topViewGestureRecognizer];
}

- (void)topViewGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    static NSIndexPath *touchedItem = nil;
    CGPoint locationInTopView = [gestureRecognizer locationInView:self.calendarViewController.collectionView]; // Point in scrollview

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            touchedItem = [self.calendarViewController.collectionView indexPathForItemAtPoint:locationInTopView];
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
    NSAssert(self.editing, @"It must not be possible to reach this method unless in edit mode.");
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
            NSIndexPath *destination = [self.calendarViewController.collectionView indexPathForItemAtPoint:locationInCollectionView];
            // Ensure target destination is valid.
            if (destination) {
                CGRect destinationFrame = [self.calendarViewController.collectionView cellForItemAtIndexPath:destination].frame;
                destinationFrame = [self.view convertRect:destinationFrame fromView:self.calendarViewController.collectionView];
                
                
                /* Animation */
                CGFloat duration = 0.3;
                CGFloat animationTargetShadowOpacity = 0.0f;
                // Animate shadow removal, to give effect like layer is moving down
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
                animation.fromValue = [NSNumber numberWithFloat:draggedView.layer.shadowOpacity];
                animation.toValue = [NSNumber numberWithFloat:animationTargetShadowOpacity];
                animation.duration = duration;
                [draggedView.layer addAnimation:animation forKey:@"shadowOpacity"];
                // Animate layer moving in place
                [UIView animateWithDuration:duration
                                 animations:^{
                                     draggedView.frame = destinationFrame;
                                     draggedView.layer.shadowOpacity = animationTargetShadowOpacity; // Triggers the above defined shadow animation.
                                     for (UIView *subview in draggedView.subviews) {
                                         CGRect frame = subview.frame;
                                         CGSize size = destinationFrame.size;
                                         frame.size = size;
                                         subview.frame = frame;
                                     }
                                 }completion:^(BOOL finished){
                                     [self.calendarViewController addPictogram:pictogramBeingDragged atIndexPath:destination];
                                     [draggedView removeFromSuperview];
                                     draggedView = nil;
                                     pictogramBeingDragged = nil;
                                     pictogramOriginInBottomView = CGRectNull;
                                 }];

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

#pragma mark - 

- (NSString *)description {
    return [NSString stringWithFormat:@"ViewController\nisEditing: %d", self.isEditing];
}

#pragma mark - Device Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self restoreCalendarHeight];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (isShowingBottomView) {
        [self showPictogramSelector];
    } else {
        [self hidePictogramSelector];
    }
}


@end