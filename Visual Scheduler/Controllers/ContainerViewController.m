#import "ContainerViewController.h"
#import "BBASelectPictogramViewController.h"
#import "../CalendarView/CalendarCollectionViewController.h"
#import "../CalendarView/WeekCollectionViewLayout.h"

@implementation ContainerViewController

- (void)viewDidLoad {
    [self setupChildViewControllers];
}

- (void)setupChildViewControllers {
    [self setupCalendar];
    [self setupPictogramSelectorViewController];
}

- (void)setupCalendar {
    WeekCollectionViewLayout *layout = [[WeekCollectionViewLayout alloc] init];
    CalendarCollectionViewController *vc = [[CalendarCollectionViewController alloc] initWithCollectionViewLayout:layout];
    [self addChildViewController:vc];
    [self.topView addSubview:vc.view];
}

- (void)setupPictogramSelectorViewController {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    BBASelectPictogramViewController *vc = [[BBASelectPictogramViewController alloc] initWithCollectionViewLayout:layout];
    [self addChildViewController:vc];
    [self.bottomView addSubview:vc.view];
}

@end