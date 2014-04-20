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
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.view addGestureRecognizer:gr];
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    static UIImageView *imageBeingDragged = nil;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint locationInTopView = [gestureRecognizer locationInView:self.topView];
        if ([self.topView pointInside:locationInTopView withEvent:nil])
            NSLog(@"top");
    
        CGPoint locationInBottomView = [gestureRecognizer locationInView:self.bottomView];
        if ([self.bottomView pointInside:locationInBottomView withEvent:nil]) {
            imageBeingDragged = [[UIImageView alloc] init];
            imageBeingDragged.frame = CGRectMake([gestureRecognizer locationInView:self.view].x - 50,
                                                 [gestureRecognizer locationInView:self.view].y - 50,
                                                 100,
                                                 100);
            imageBeingDragged.image = [self.pictogramViewController pictogramAtPoint:locationInBottomView];
            [imageBeingDragged.layer setZPosition:2000];
            [self.view addSubview:imageBeingDragged];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (imageBeingDragged != nil) {
            imageBeingDragged.frame = [self center:imageBeingDragged.frame at:[gestureRecognizer locationInView:self.view]];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [imageBeingDragged removeFromSuperview];
        imageBeingDragged = nil;
    }
}

- (CGRect)center:(CGRect)aRect at:(CGPoint)aPoint {
    aRect.origin = aPoint;
    aRect.origin.x -= aRect.size.width / 2.0f;
    aRect.origin.y -= aRect.size.height / 2.0f;
    return aRect;
}

@end