#import "ContainerViewController.h"
#import "ContainerViewController+Camera.h"
#import <QuartzCore/CAAnimation.h>
#import "DayCollectionViewLayout.h"
#import "DayCollectionViewController.h"
#import "WeekCollectionViewLayout.h"
#import "CreatePictogram.h"
#import "TimerViewController.h"
#import "TimerViewController.h"
#import "WeekCollectionViewController.h"
#import "UIView+HoverView.h"

#ifdef DEBUG
    #import "UIView+ContraintInfo.h"
#endif

@interface ContainerViewController () {
    TimerViewController* _timerViewController;
    UIBarButtonItem *cameraButton;
    UIBarButtonItem *timerButton;
}
/** Controller for the view within the bottomView.
 */

@property (weak, nonatomic) UICollectionViewController *currentCollectionViewController;

@property (strong, nonatomic) NSArray *constraints;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    self.currentCollectionViewController = [self setupWeekViewController];
    [self.topView addSubview:self.currentCollectionViewController.view];
    [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wrapperView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"wrapperView" : self.currentCollectionViewController.view}]];
    [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[wrapperView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"wrapperView" : self.currentCollectionViewController.view}]];
    
   
    */
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Breyta" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEditing)];
    [self.navigationItem setRightBarButtonItem:editButton];
    cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showCamera)];
    timerButton = [[UIBarButtonItem alloc] initWithTitle:@"Klukka" style:UIBarButtonItemStylePlain target:self action:@selector(showTimer)];
    [self.navigationItem setLeftBarButtonItem:timerButton];
    [self setupGestureRecognizer];
}

#pragma mark View Modes (now,day,week)

- (IBAction)changeCalendarViewMode:(id)sender {
    NSParameterAssert([sender isKindOfClass:[UISegmentedControl class]]);
    UISegmentedControl *control = sender;
    switch (control.selectedSegmentIndex) {
        case 0:
        case 1:
        {
            if ([self.currentCollectionViewController isMemberOfClass:[DayCollectionViewController class]] == NO) {
                self.currentCollectionViewController = [self setupDayViewController];
            }
            DayCollectionViewController *controller = (DayCollectionViewController *)self.currentCollectionViewController;
            [controller switchToViewMode:control.selectedSegmentIndex];
            break;
        }
        case 2:
        {
            self.currentCollectionViewController = [self setupWeekViewController];
            break;
        }
        default:
        {
            NSAssert(NO, @"Invalid selection.");
        }
    }
    
    [self presentSchedule];
}

#pragma mark Week View

- (UICollectionViewController *)setupWeekViewController {
    NSAssert(self.topView, @"topView must not be nil.");
    
    WeekCollectionViewLayout *weekLayout = [[WeekCollectionViewLayout alloc] init];
    WeekCollectionViewController *weekController = [[WeekCollectionViewController alloc] initWithCollectionViewLayout:weekLayout];
    NSAssert(weekController, @"Failed to get controller");
    [self addChildViewController:weekController];
    return weekController;
}

#pragma mark Day View

- (UICollectionViewController *)setupDayViewController {
    NSAssert(self.topView, @"topView must not be nil.");
    
    DayCollectionViewLayout *layout = [[DayCollectionViewLayout alloc] init];
    DayCollectionViewController *controller = [[DayCollectionViewController alloc] initWithCollectionViewLayout:layout];
    NSAssert(controller, @"Failed to get controller");
    [self addChildViewController:controller];
    return controller;
}

#pragma mark Helpers

- (void)presentSchedule {
    [self removeAllSubviewsFrom:self.topView];
    [self.topView addSubview:self.currentCollectionViewController.view];
    self.currentCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"collectionView" : self.currentCollectionViewController.view}]];
    [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"collectionView" : self.currentCollectionViewController.view}]];
}

- (void)removeAllSubviewsFrom:(UIView *)view {
    NSParameterAssert(view);
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
    NSAssert(self.topView.subviews.count == 0, @"Not all subviews have been removed.");
}

#pragma mark - Edit Mode

- (void)toggleEditing {
    [self setEditing:!self.editing animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        [self animateInBottomView];
    }
    else {
        [self animateOutBottomView];
    }
    
    [self setEditButtonText:
        (self.editing) ? @"Klára" : @"Breyta"
    ];
    
    [self.navigationItem setLeftBarButtonItem:
        (self.editing) ? cameraButton : timerButton
    ];
    
    [self.currentCollectionViewController setEditing:self.editing animated:YES];
    [self setDayWeekSegmentEnabled:!self.editing];
    [self setEditGestureRecognizersEnabled:editing];
}

- (void)setEditButtonText:(NSString *)value {
    NSParameterAssert(value);
    UIBarButtonItem *button = self.navigationItem.rightBarButtonItem;
    button.title = value;
    NSAssert([button.title isEqualToString:value], @"Failed to set edit button's string.");
}

- (void)setDayWeekSegmentEnabled:(BOOL)value {
    // Toggle all segments, except the one representing the current selection.
    for (NSInteger button = dayWeekSegment.numberOfSegments-1; button >= 0; button--) {
        if (button != dayWeekSegment.selectedSegmentIndex) {
            [dayWeekSegment setEnabled:value forSegmentAtIndex:button];
        }
    }
}

#pragma mark - Bottom View (Pictogram Selector Slide)

- (void)addShadowToBottomView {
    self.bottomView.layer.shadowOpacity = PICTOGRAM_SHADOW_OPACITY;
    self.bottomView.layer.shadowRadius = PICTOGRAM_SHADOW_RADIUS;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
}

#pragma mark Animation
- (void)animateInBottomView {
    [self updateViewConstraints];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.0f
                     animations:^{_bottomViewHeight.constant = (NSInteger)(self.view.frame.size.height / 3.0f); // Else the constraint will try to set the height to a fraction which is illegal.
                       _bottomViewHeight.constant = (NSInteger)(self.view.frame.size.height / 3.0f); // Else the constraint will try to set the height to a fraction which is illegal.
                         //[self.topView layoutSubviews];
                         [self.view layoutSubviews]; // apple says do not use this directly. But if we do the suggested way, it will laag.
                     }];

}

- (void)animateOutBottomView {
    [self updateViewConstraints];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.0f
                     animations:^{
                         _bottomViewHeight.constant = 0;
                        // [self.view setNeedsLayout];
                        // [self.view layoutIfNeeded];
                        [self.view layoutSubviews]; // apple says do not use this directly. But if we do the suggested way, it will laag.
                     }];
}

#pragma mark - Gesture Recognizers

- (void)setEditGestureRecognizersEnabled:(BOOL)value {
    _topViewGestureRecognizer.enabled = value;
    _bottomViewGestureRecognizer.enabled = value;
}

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
    CGPoint locationInTopView = [gestureRecognizer locationInView:self.currentCollectionViewController.collectionView];

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            touchedItem = [self.currentCollectionViewController.collectionView indexPathForItemAtPoint:locationInTopView];
            if (touchedItem) {
                // Todo, make static type check instead of magic.
                [self.currentCollectionViewController performSelector:@selector(deletePictogramAtIndexPath:) withObject:touchedItem];
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
          //  [self ifPictogramWasTouchedAnimateItToTheFingerLocation:gestureRecognizer];
            break;
            
        case UIGestureRecognizerStateChanged:
            if (_viewFollowingFinger != nil) {
                CGPoint gestureLocation = [gestureRecognizer locationInView:self.view];
                _viewFollowingFinger.frame = [self center:_viewFollowingFinger.frame at:gestureLocation];
                
                /* animate shifting while moving */
                CGPoint locationInCollectionView = [gestureRecognizer locationInView:self.currentCollectionViewController.collectionView];
                NSIndexPath *fingerIsOverPictogram = [self.currentCollectionViewController.collectionView indexPathForItemAtPoint:locationInCollectionView];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (_pictogramBeingDragged != nil) {
                CGPoint locationInTopView = [gestureRecognizer locationInView:self.topView];
                CGPoint locationInCollectionView = [self.currentCollectionViewController.collectionView convertPoint:locationInTopView fromView:self.topView];
                if ([self.topView pointInside:locationInTopView withEvent:nil]) {
                    /* If the pictogram was released in a schedule, animate it into place. */
                    NSIndexPath *destination = [self.currentCollectionViewController.collectionView indexPathForItemAtPoint:locationInCollectionView];
                    if (destination) {
                        
                        
                        /* Animation */
                        CGRect destinationFrame = [self.currentCollectionViewController.collectionView cellForItemAtIndexPath:destination].frame;
                        destinationFrame = [self.view convertRect:destinationFrame fromView:self.currentCollectionViewController.collectionView];
                        
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
                                             [self.currentCollectionViewController performSelector:@selector(addPictogram:atIndexPath:) withObject:_pictogramBeingDragged withObject:destination];
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
/*
- (void)ifPictogramWasTouchedAnimateItToTheFingerLocation:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint locationInBottomView = [gestureRecognizer locationInView:self.bottomView];
    if ([self.bottomView pointInside:locationInBottomView withEvent:nil]) {
        
        // get pictogram being dragged
        //_pictogramBeingDragged = [self.pictogramViewController pictogramAtPoint:locationInBottomView];
        //CGRect frameOfTouchedPictogram = [self.pictogramViewController frameOfPictogramAtPoint:locationInBottomView];
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
}*/

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

#pragma mark - Timer

- (void)showTimer{
    if(_timerViewController == nil){
        _timerViewController = [[TimerViewController alloc]init];
    }
    [[self navigationController]pushViewController:_timerViewController animated:YES];
}

@end