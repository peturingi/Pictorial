#import "CalendarCollectionViewController.h"

#import "CalendarView.h"
#import "NowCollectionViewLayout.h"
#import "TodayCollectionViewLayout.h"
#import "WeekCollectionViewLayout.h"


@implementation CalendarCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCalendarViewMode:) name:NOTIFICATION_CALENDAR_VIEW object:nil];
        self.collectionView = [[CalendarView alloc] initWithFrame:self.view.frame collectionViewLayout:self.collectionViewLayout];
        dataSource = [[CalendarDataSource alloc] init];
        [self.collectionView setDataSource:dataSource];
        [self.collectionView setDelegate:dataSource];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)loadView {
    [super loadView];
    // Makes the collectionView flexible in size, so its size can be managed by a container.
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
}

- (void)handleCalendarViewMode:(NSNotification *)notification {
    if ([notification.name isEqualToString:NOTIFICATION_CALENDAR_VIEW]) {
        NSNumber *viewMode = [notification object];
        UICollectionViewLayout *layout;

        switch (viewMode.integerValue) {
            case 0:
                layout = [[NowCollectionViewLayout alloc] initWithCoder:nil];
                break;
                
            case 1:
                layout = [[TodayCollectionViewLayout alloc] initWithCoder:nil];
                break;
                
            case 2:
                layout = [[WeekCollectionViewLayout alloc] initWithCoder:nil];
                break;
        }
        
        [layout prepareForTransitionFromLayout:self.collectionView.collectionViewLayout];
        [self.collectionViewLayout prepareForTransitionToLayout:layout];
        [self.collectionView setCollectionViewLayout:layout animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end