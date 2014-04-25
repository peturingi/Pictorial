#import "ContainerViewController.h"
#import "ContainerViewController+Camera.h"

#import <QuartzCore/CAAnimation.h>
#import "PictogramsCollectionViewController.h"
#import "DayCollectionViewLayout.h"
#import "DayCollectionViewController.h"
#import "WeekCollectionViewLayout.h"
#import "CreatePictogram.h"
#import "TimerViewController.h"
#import "WeekCollectionViewController.h"

#import "UIView+HoverView.h"

@interface ContainerViewController ()
/** Controller manageing the view whtin the bottomView
 */
@property (weak, nonatomic) PictogramsCollectionViewController *pictogramViewController;

@property (weak, nonatomic) UICollectionViewController *currentCollectionViewController;
@property (weak, nonatomic) WeekCollectionViewController *weekViewController;
@property (weak, nonatomic) DayCollectionViewController *dayViewController;
@end

@implementation ContainerViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWeekViewController];
    
    [self setupPictogramSelectorViewController];
    [self addShadowToBottomView];
    
    _currentCollectionViewController = self.weekViewController;
    
    [self setupGestureRecognizer];
}

- (void)setupWeekViewController {
    NSAssert(self.topView, @"topView must not be nil.");
    
    WeekCollectionViewLayout *weekLayout = [[WeekCollectionViewLayout alloc] init];
    WeekCollectionViewController *weekController = [[WeekCollectionViewController alloc] initWithCollectionViewLayout:weekLayout];
    weekController.view.frame = self.topView.bounds;
    
    [self addChildViewController:weekController];
    self.weekViewController = weekController;
    [self.topView addSubview:weekController.view];
}

#pragma mark -

- (IBAction)toggleEditing:(id)sender {
    [self setEditing:!self.editing animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        [self animateInBottomView];
    }
    else {
        [self restoreCalendarHeight];
        [self animateOutBottomView];
    }
    
    [self.weekViewController setEditing:self.editing animated:YES];
    [self setDayWeekSegmentEnabled:!self.editing];
    [self setEditGestureRecognizersEnabled:editing];
}

- (void)setEditButtonEnabled:(BOOL)value {
    self.navigationItem.rightBarButtonItem.enabled = value;
}

- (void)setDayWeekSegmentEnabled:(BOOL)value {
    for (NSInteger button = dayWeekSegment.numberOfSegments-1; button >= 0; button--) {
        if (button != dayWeekSegment.selectedSegmentIndex) {
            [dayWeekSegment setEnabled:value forSegmentAtIndex:button];
        }
    }
}

#pragma mark - Show Pictogram Selector

- (void)animateInBottomView {
    self.bottomView.layer.shadowOpacity = PICTOGRAM_SHADOW_OPACITY;
    CGRect frame = [self rectCoveringOneThirdOfBottomScreen];
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomView.frame = frame;
    }completion:^(BOOL completed){
        if (completed) {
            [self shrinkCalendarbyOneThirdItsHeightFromBottom];
        }
    }];
}

- (CGRect)rectCoveringOneThirdOfBottomScreen {
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(self.view.frame.origin.x,
                               self.view.bounds.origin.y + self.view.bounds.size.height/3.0f * 2.0f);
    frame.size = CGSizeMake(self.view.frame.size.width,
                            self.view.bounds.origin.y + self.view.frame.size.height/3.0f);
    return frame;
}

#pragma mark -

- (void)restoreCalendarHeight {
    self.topView.frame = self.view.bounds;
}

#pragma mark - Hide Pictrogram Selector

- (void)animateOutBottomView {
    CGRect frame = [self outOfBoundsBottomViewFrame];
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomView.frame = frame;
    }completion:^(BOOL completed){
        if (completed) {
            self.bottomView.layer.shadowOpacity = 0.0f;
        }
    }];
}

- (CGRect)outOfBoundsBottomViewFrame {
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(self.view.frame.origin.x,
                               self.view.bounds.origin.y + self.view.bounds.size.height);
    frame.size = self.bottomView.frame.size;
    return frame;
}

- (void)setEditGestureRecognizersEnabled:(BOOL)value {
    _topViewGestureRecognizer.enabled = value;
    _bottomViewGestureRecognizer.enabled = value;
}

- (void)setupPictogramSelectorViewController {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    PictogramsCollectionViewController *viewController = [[PictogramsCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    viewController.view.frame = self.bottomView.bounds;

    [self addChildViewController:viewController];
    [self.bottomView addSubview:viewController.view];
    self.pictogramViewController = viewController;
}

- (void)addShadowToBottomView {
    self.bottomView.layer.shadowRadius = PICTOGRAM_SHADOW_RADIUS;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)shrinkCalendarbyOneThirdItsHeightFromBottom {
    CGRect frame = self.topView.frame;
    frame.size.height -= frame.size.height / 3.0f;
    self.topView.frame = frame;
}

#pragma mark Gestures

- (void)setupGestureRecognizer {
    [self setupTopViewGestureRecognizer];
    [self setupBottomViewGestureRecognizer];
}

- (void)setupTopViewGestureRecognizer {
    _bottomViewGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewGesture:)];
    CFTimeInterval requiredPressDuration = PRESS_DURATION_BEFORE_DRAG;
    _bottomViewGestureRecognizer.minimumPressDuration = requiredPressDuration;
    _bottomViewGestureRecognizer.enabled = NO;
    [self.bottomView addGestureRecognizer:_bottomViewGestureRecognizer];
}

- (void)setupBottomViewGestureRecognizer {
    _topViewGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(topViewGesture:)];
    CFTimeInterval timeBeforeDelete = 0.1f;
    _topViewGestureRecognizer.minimumPressDuration = timeBeforeDelete;
    _topViewGestureRecognizer.enabled = NO;
    [self.topView addGestureRecognizer:_topViewGestureRecognizer];
}

- (void)topViewGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    static NSIndexPath *touchedItem = nil;
    CGPoint locationInTopView = [gestureRecognizer locationInView:self.weekViewController.collectionView];

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            touchedItem = [self.weekViewController.collectionView indexPathForItemAtPoint:locationInTopView];
            if (touchedItem) {
                [self.weekViewController deleteItemAtIndexPath:touchedItem];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            touchedItem = nil;
            break;
            
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (void)bottomViewGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    NSAssert(self.editing, @"It must not be possible to reach this method unless in edit mode.");
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self ifPictogramWasTouchedAnimateItToTheFingerLocation:gestureRecognizer];
            break;
            
        case UIGestureRecognizerStateChanged:
            if (_viewFollowingFinger != nil) {
                CGPoint gestureLocation = [gestureRecognizer locationInView:self.view];
                _viewFollowingFinger.frame = [self center:_viewFollowingFinger.frame at:gestureLocation];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (_pictogramBeingDragged != nil) {
                CGPoint locationInTopView = [gestureRecognizer locationInView:self.topView];
                CGPoint locationInCollectionView = [self.weekViewController.collectionView convertPoint:locationInTopView fromView:self.topView];
                if ([self.topView pointInside:locationInTopView withEvent:nil]) {
                    /* If the pictogram was released in a schedule, animate it into place. */
                    NSIndexPath *destination = [self.weekViewController.collectionView indexPathForItemAtPoint:locationInCollectionView];
                    if (destination) {
                        
                        
                        /* Animation */
                        CGRect destinationFrame = [self.currentCollectionViewController.collectionView cellForItemAtIndexPath:destination].frame;
                        destinationFrame = [self.view convertRect:destinationFrame fromView:self.weekViewController.collectionView];
                        
                        // Animate shadow removal, to give effect like layer is moving down
                        NSString *const shadowOpacity = @"shadowOpacity";
                        
                        CABasicAnimation* (^removeShadow)(void) = ^CABasicAnimation*(void){
                            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:shadowOpacity];
                            animation.fromValue = [NSNumber numberWithFloat:_viewFollowingFinger.layer.shadowOpacity];
                            animation.toValue = [NSNumber numberWithFloat:0];
                            animation.duration = ANIMATION_DURATION_INSERT_PICTOGRAM;
                            return animation;
                        };
                        [_viewFollowingFinger.layer addAnimation:removeShadow() forKey:shadowOpacity];
                        
                        // Animate layer moving in place
                        [UIView animateWithDuration:ANIMATION_DURATION_INSERT_PICTOGRAM
                                         animations:^{
                                             _viewFollowingFinger.frame = destinationFrame;
                                             _viewFollowingFinger.layer.shadowOpacity = 0;
                                             for (UIView *subview in _viewFollowingFinger.subviews) {
                                                 CGRect frame = subview.frame;
                                                 CGSize size = destinationFrame.size;
                                                 frame.size = size;
                                                 subview.frame = frame;
                                             }
                                         }completion:^(BOOL finished){
                                             [self.weekViewController addPictogram:_pictogramBeingDragged atIndexPath:destination];
                                             [self resetPictogramDragging];
                                         }];
                    }
                    else {
                        [self animatePictogramBeingDraggedBackToWhereItCameFrom];
                    }
                }
                else {
                    [self animatePictogramBeingDraggedBackToWhereItCameFrom];
                }
            }
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            [self resetPictogramDragging];
            break;
            
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (void)ifPictogramWasTouchedAnimateItToTheFingerLocation:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint locationInBottomView = [gestureRecognizer locationInView:self.bottomView];
    if ([self.bottomView pointInside:locationInBottomView withEvent:nil]) {
        
        /* get pictogram being dragged */
        _pictogramBeingDragged = [self.pictogramViewController pictogramAtPoint:locationInBottomView];
        CGRect frameOfTouchedPictogram = [self.pictogramViewController frameOfPictogramAtPoint:locationInBottomView];
        _originOfTouchedPictogram = [self.view convertRect:frameOfTouchedPictogram fromView:self.bottomView];
        
        _viewFollowingFinger = [self draggablePictogramWith:_originOfTouchedPictogram usingImage:_pictogramBeingDragged.image];
        [self.view addSubview:_viewFollowingFinger];
        
        // Animate to finger
        CGPoint gestureLocationInView = [gestureRecognizer locationInView:self.view];
        CGRect destinationFrameForAnimation = [self rectWithSize:_originOfTouchedPictogram.size withCenter:gestureLocationInView];
        [UIView animateWithDuration:0.1f
                         animations:^{
                             _viewFollowingFinger.frame = destinationFrameForAnimation;
                         }completion:^(BOOL finished){
                             if (finished) {
                                 _viewFollowingFinger.frame = destinationFrameForAnimation;
                             }
                         }];
    }
}

#pragma mark - Abort Dragging Pictogram

- (void)animatePictogramBeingDraggedBackToWhereItCameFrom {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _viewFollowingFinger.frame = _originOfTouchedPictogram;
                     }completion:^(BOOL finished){
                         if (finished) {
                             [self resetPictogramDragging];
                         }
                     }];
}

- (void)resetPictogramDragging {
    [_viewFollowingFinger removeFromSuperview];
    _viewFollowingFinger = nil;
    _pictogramBeingDragged = nil;
    _originOfTouchedPictogram = CGRectNull;
}


#pragma mark - Construct pictogram to follow the finger.

/** Returns a represention of a pictogram, with rounded corners and a casting shadow.
    The representation appears to be hovering.
 */
- (UIView *)draggablePictogramWith:(CGRect)frame usingImage:(UIImage *)image {
    NSParameterAssert(image);
    
    /* A container */
    UIView *container = [[UIView alloc] initWithFrame:frame];
    [container addHoverShadow];
    
    /* Round the corners */
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:container.bounds];
    imageView.image = image;
    [imageView roundBorder];
    
    /* Embed the rounded view in a container, as a workaround;
       rounding corners on a shadowed view will cut away outward
       radiating shadows.*/
    [container addSubview:imageView];
    return container;
}

#pragma mark -

- (CGRect)rectWithSize:(CGSize)size withCenter:(CGPoint)center {
    CGRect rect = CGRectMake(center.x,
                             center.y,
                             size.width,
                             size.height);
    rect = [self center:rect at:center];
    return rect;
}

- (CGRect)center:(CGRect)rect at:(CGPoint)point {
    rect.origin = point;
    rect.origin.x -= rect.size.width / 2.0f;
    rect.origin.y -= rect.size.height / 2.0f;
    return rect;
}

#pragma mark - Device Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //[self restoreCalendarHeight];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    //if (_isShowingBottomView) {
    //    [self showPictogramSelector];
    //} else {
    //    [self hidePictogramSelector];
    //}
}

#pragma mark - Timer
-(IBAction)showTimer:(id)sender{
    [[self navigationController]pushViewController:[[TimerViewController alloc]init] animated:YES];
}

#pragma mark -

- (IBAction)changeCalendarViewMode:(id)sender {
    NSParameterAssert([sender isKindOfClass:[UISegmentedControl class]]);
}

@end