#import "ContainerViewController.h"
#import <QuartzCore/CAAnimation.h>
#import "PictogramsCollectionViewController.h"
#import "CalendarCollectionViewController.h"
#import "WeekCollectionViewLayout.h"
#import "CreatePictogram.h"

#define PICTOGRAM_SHADOW_COLOR [UIColor blackColor].CGColor
#define PICTOGRAM_SHADOW_RADIUS 10.0f
#define PICTOGRAM_SHADOW_OPACITY 0.8f
#define PICTOGRAM_SHADOW_OFFSET CGSizeMake(0, 0)
#define PICTOGRAM_BORDER_COLOR [UIColor blackColor].CGColor

#define PRESS_DURATION_BEFORE_DRAG 0.1f

#define ANIMATION_DURATION_INSERT_PICTOGRAM 0.3f

@interface ContainerViewController ()
@property (weak, nonatomic) PictogramsCollectionViewController *pictogramViewController;
@property (weak, nonatomic) CalendarCollectionViewController *calendarViewController;
@end

@implementation ContainerViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        isShowingBottomView = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [self setupCalendar];
    [self setupGestureRecognizer];
}

- (void)setupCalendar {
    NSAssert(self.topView, @"topView must not be nil.");
    
    WeekCollectionViewLayout *layout = [[WeekCollectionViewLayout alloc] init];
    CalendarCollectionViewController *collectionViewController = [[CalendarCollectionViewController alloc] initWithCollectionViewLayout:layout];
    collectionViewController.view.frame = self.topView.bounds;
    self.calendarViewController = collectionViewController;
    
    [self addChildViewController:collectionViewController];
    [self.topView addSubview:collectionViewController.view];
}

#pragma mark -

- (IBAction)toggleEditing:(id)sender {
    if (self.editing == NO) {
        [self setEditButtonEnabled:NO];
        if (self.pictogramViewController == nil) {
            [self setupPictogramSelectorViewController];
            [self addShadowToBottomView];
        }
        [self showPictogramSelector];
        [self setEditGestureRecognizersEnabled:YES];
        self.editing = YES;
    } else {
        [self restoreCalendarHeight];
        [self hidePictogramSelector];
        [self setEditGestureRecognizersEnabled:NO];
        self.editing = NO;
    }
    [self.calendarViewController setEditing:self.editing animated:YES];
}

- (void)setEditButtonEnabled:(BOOL)value {
    self.navigationItem.rightBarButtonItem.enabled = value;
}

#pragma mark - Show Pictogram Selector

- (void)showPictogramSelector {
    isShowingBottomView = YES;
    [self animateInBottomView];
}

- (void)animateInBottomView {
    self.bottomView.layer.shadowOpacity = PICTOGRAM_SHADOW_OPACITY;
    CGRect frame = [self rectCoveringOneThirdOfBottomScreen];
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomView.frame = frame;
    }completion:^(BOOL completed){
        if (completed) {
            self.bottomView.frame = frame;
            [self shrinkCalendarbyOneThirdItsHeightFromBottom];
            [self setEditButtonEnabled:YES];
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

- (void)hidePictogramSelector {
    isShowingBottomView = NO;
    [self setEditButtonEnabled:NO];
    [self animateOutBottomView];
}

- (void)animateOutBottomView {
    CGRect frame = [self outOfBoundsBottomViewFrame];
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomView.frame = frame;
    }completion:^(BOOL completed){
        if (completed) {
            self.bottomView.layer.shadowOpacity = 0.0f;
            self.bottomView.frame = frame;
            [self setEditButtonEnabled:YES];
            [self.pictogramViewController removeFromParentViewController];
            self.pictogramViewController = nil;
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
    topViewGestureRecognizer.enabled = value;
    bottomViewGestureRecognizer.enabled = value;
}

- (void)setupPictogramSelectorViewController {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    PictogramsCollectionViewController *viewController = [[PictogramsCollectionViewController alloc] initWithCollectionViewLayout:layout];
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
    bottomViewGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewGesture:)];
    CFTimeInterval requiredPressDuration = PRESS_DURATION_BEFORE_DRAG;
    bottomViewGestureRecognizer.minimumPressDuration = requiredPressDuration;
    bottomViewGestureRecognizer.enabled = NO;
    [self.bottomView addGestureRecognizer:bottomViewGestureRecognizer];
}

- (void)setupBottomViewGestureRecognizer {
    topViewGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(topViewGesture:)];
    CFTimeInterval timeBeforeDelete = 0.1f;
    topViewGestureRecognizer.minimumPressDuration = timeBeforeDelete;
    topViewGestureRecognizer.enabled = NO;
    [self.topView addGestureRecognizer:topViewGestureRecognizer];
}

- (void)topViewGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    static NSIndexPath *recentlyTouchedItem = nil;
    CGPoint locationInTopView = [gestureRecognizer locationInView:self.calendarViewController.collectionView];

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            recentlyTouchedItem = [self.calendarViewController.collectionView indexPathForItemAtPoint:locationInTopView];
            [self.calendarViewController deleteItemAtIndexPath:recentlyTouchedItem];
            break;
            
        case UIGestureRecognizerStateChanged:
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            recentlyTouchedItem = nil;
            break;
            
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (void)bottomViewGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    NSAssert(self.editing, @"It must not be possible to reach this method unless in edit mode.");
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint locationInBottomView = [gestureRecognizer locationInView:self.bottomView];
            if ([self.bottomView pointInside:locationInBottomView withEvent:nil]) {
                
                /* get pictogram being dragged */
                pictogramBeingDragged = [self.pictogramViewController pictogramAtPoint:locationInBottomView];
                CGRect frameOfTouchedPictogram = [self.pictogramViewController frameOfPictogramAtPoint:locationInBottomView];
                originOfTouchedPictogram = [self.view convertRect:frameOfTouchedPictogram fromView:self.bottomView];
                
                viewFollowingFinger = [self draggablePictogramWith:originOfTouchedPictogram usingImage:pictogramBeingDragged.image];
                [self.view addSubview:viewFollowingFinger];
                
                CGPoint gestureLocationInView = [gestureRecognizer locationInView:self.view];
                CGRect destinationFrameForAnimation = CGRectMake(gestureLocationInView.x,
                                                                 gestureLocationInView.y,
                                                                 originOfTouchedPictogram.size.width,
                                                                 originOfTouchedPictogram.size.height);
                /* The pictogram to be dragged animates to the fingers position, as its touched for the first time. */
                // Center around the finger
                destinationFrameForAnimation.origin = [self centerOfRect:destinationFrameForAnimation];
                // Animate to finger
                [UIView animateWithDuration:0.1f
                                 animations:^{
                                     viewFollowingFinger.frame = destinationFrameForAnimation;
                                 }completion:^(BOOL finished){
                                     if (finished) {
                                         viewFollowingFinger.frame = destinationFrameForAnimation;
                                     }
                                 }];
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
            if (viewFollowingFinger != nil) {
                CGPoint gestureLocation = [gestureRecognizer locationInView:self.view];
                viewFollowingFinger.frame = [self center:viewFollowingFinger.frame at:gestureLocation];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (pictogramBeingDragged != nil) {
                CGPoint locationInTopView = [gestureRecognizer locationInView:self.topView];
                CGPoint locationInCollectionView = [self.calendarViewController.collectionView convertPoint:locationInTopView fromView:self.topView];
                if ([self.topView pointInside:locationInTopView withEvent:nil]) {
                    /* If the pictogram was released in a schedule, animate it into place. */
                    NSIndexPath *destination = [self.calendarViewController.collectionView indexPathForItemAtPoint:locationInCollectionView];
                    if (destination) {
                        
                        
                        /* Animation */
                        CGRect destinationFrame = [self.calendarViewController.collectionView cellForItemAtIndexPath:destination].frame;
                        destinationFrame = [self.view convertRect:destinationFrame fromView:self.calendarViewController.collectionView];
                        
                        // Animate shadow removal, to give effect like layer is moving down
                        NSString *const shadowOpacity = @"shadowOpacity";
                        
                        CABasicAnimation* (^removeShadow)(void) = ^CABasicAnimation*(void){
                            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:shadowOpacity];
                            animation.fromValue = [NSNumber numberWithFloat:viewFollowingFinger.layer.shadowOpacity];
                            animation.toValue = [NSNumber numberWithFloat:0];
                            animation.duration = ANIMATION_DURATION_INSERT_PICTOGRAM;
                            return animation;
                        };
                        [viewFollowingFinger.layer addAnimation:removeShadow() forKey:shadowOpacity];
                        
                        // Animate layer moving in place
                        [UIView animateWithDuration:ANIMATION_DURATION_INSERT_PICTOGRAM
                                         animations:^{
                                             viewFollowingFinger.frame = destinationFrame;
                                             viewFollowingFinger.layer.shadowOpacity = 0;
                                             for (UIView *subview in viewFollowingFinger.subviews) {
                                                 CGRect frame = subview.frame;
                                                 CGSize size = destinationFrame.size;
                                                 frame.size = size;
                                                 subview.frame = frame;
                                             }
                                         }completion:^(BOOL finished){
                                             [self.calendarViewController addPictogram:pictogramBeingDragged atIndexPath:destination];
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

#pragma mark - Abort Dragging Pictogram

- (void)animatePictogramBeingDraggedBackToWhereItCameFrom {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         viewFollowingFinger.frame = originOfTouchedPictogram;
                     }completion:^(BOOL finished){
                         if (finished) {
                             [self resetPictogramDragging];
                         }
                     }];
}

- (void)resetPictogramDragging {
    [viewFollowingFinger removeFromSuperview];
    viewFollowingFinger = nil;
    pictogramBeingDragged = nil;
    originOfTouchedPictogram = CGRectNull;
}


#pragma mark - Construct pictogram to follow the finger.

/** Returns a represention of a pictogram, with rounded corners and a casting shadow.
    The representation appears to be hovering.
 */
- (UIView *)draggablePictogramWith:(CGRect)frame usingImage:(UIImage *)image {
    NSParameterAssert(image);
    
    /* A container */
    UIView *container = [[UIView alloc] initWithFrame:frame];
    [self addHoverShadowTo:container];
    
    /* Round the corners */
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:container.bounds];
    imageView.image = image;
    [self addRoundedBorderTo:imageView];
    
    /* Embed the rounded view in a container, as a workaround;
       rounding corners on a shadowed view will cut away outward
       radiating shadows.*/
    [container addSubview:imageView];
    return container;
}

/** Adds shadow to the view's layer.
 *  The view appears to be raised above whatever is under it.
 */
- (void)addHoverShadowTo:(UIView *)view {
    NSParameterAssert(view);
    view.layer.shadowColor = PICTOGRAM_SHADOW_COLOR;
    view.layer.shadowOffset = PICTOGRAM_SHADOW_OFFSET;
    view.layer.shadowOpacity = PICTOGRAM_SHADOW_OPACITY;
    view.layer.shadowRadius = PICTOGRAM_SHADOW_RADIUS;
}

- (void)addRoundedBorderTo:(UIView *)view {
    [view.layer setBorderWidth:PICTOGRAM_BORDER_WIDTH];
    [view.layer setCornerRadius:PICTOGRAM_CORNER_RADIUS];
    [view.layer setBorderColor:PICTOGRAM_BORDER_COLOR];
    [view.layer setMasksToBounds:YES];
}

#pragma mark -

- (CGPoint)centerOfRect:(CGRect)aRect {
    aRect.origin.x -= aRect.size.width / 2.0f;
    aRect.origin.y -= aRect.size.height / 2.0f;
    return aRect.origin;
}

- (CGRect)center:(CGRect)rect at:(CGPoint)point {
    rect.origin = point;
    rect.origin.x -= rect.size.width / 2.0f;
    rect.origin.y -= rect.size.height / 2.0f;
    return rect;
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

#pragma mark - Camera

- (IBAction)cameraButton:(id)sender {
    [self setupCamera];
    [self showCamera];
}

- (void)setupCamera {
    camera = [[Camera alloc] initWithViewController:self usingDelegate:self];
}

- (void)showCamera {
    BOOL success = [camera show];
    if (!success) {
        [self alertUserCameraIsNotAvailable];
    }
}

#pragma mark Delegate

- (void)cameraDidSnapPhoto:(Camera *)aCamera {
    [self showCreatePictogramView];
}

- (void)showCreatePictogramView {
    NSAssert(camera, @"The camera must not be nil.");
    CreatePictogram *viewController = [[CreatePictogram alloc] init];
    viewController.photo = [camera developPhoto];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:viewController animated:YES completion:^{
        camera = nil;
    }];
}

- (void)alertUserCameraIsNotAvailable {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The camera is unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark -

- (IBAction)changeCalendarViewMode:(id)sender {
    NSParameterAssert([sender isKindOfClass:[UISegmentedControl class]]);
    UISegmentedControl *control = sender;
    [self.calendarViewController switchToViewMode:control.selectedSegmentIndex];
}

@end