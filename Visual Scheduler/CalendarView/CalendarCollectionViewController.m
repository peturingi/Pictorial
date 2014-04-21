#import "CalendarCollectionViewController.h"
#import "CalendarDataSource.h"
#import "CalendarView.h"
#import "NowCollectionViewLayout.h"
#import "TodayCollectionViewLayout.h"
#import "WeekCollectionViewLayout.h"

#import "Schedule.h"
#import "Pictogram.h"

@interface CalendarCollectionViewController ()
    @property (nonatomic, strong) CalendarDataSource *dataSource;
@end

@implementation CalendarCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCalendarViewMode:) name:NOTIFICATION_CALENDAR_VIEW object:nil];
        self.dataSource = [[CalendarDataSource alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self setupCollectionView];
}

- (void)viewDidLoad {
    // TODO REMOVE
    NSLog(@"Entering edit mode");
    [self setEditing:YES animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        [self.dataSource setEditing:YES];
    } else {
        [self.dataSource setEditing:NO];
    }
}

- (void)setupCollectionView {
    self.collectionView = [[CalendarView alloc] initWithFrame:self.view.frame collectionViewLayout:self.collectionViewLayout];
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self.dataSource;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
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

- (void)sectionAtPoint:(CGPoint)point {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    NSLog(@"Section: %ld, Item: %ld", (long)indexPath.section, (long)indexPath.item);
}

- (void)addPictogram:(Pictogram *)pictogram atIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath != nil);
    NSParameterAssert(indexPath.section < self.collectionView.numberOfSections);
    NSParameterAssert(indexPath.item < [self.collectionView numberOfItemsInSection:indexPath.section]);
    
    Schedule *schedule = [self.dataSource.data objectAtIndex:indexPath.section];
    [schedule addPictogram:pictogram atIndex:indexPath.item];
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)touchedItem {
    NSMutableArray *data = [NSMutableArray arrayWithArray:self.dataSource.data];
    Schedule *schedule = [data objectAtIndex:touchedItem.section];
    NSMutableArray *pictograms = [NSMutableArray arrayWithArray:schedule.pictograms];
    [pictograms removeObjectAtIndex:touchedItem.item];
    schedule.pictograms = pictograms;
    [data replaceObjectAtIndex:touchedItem.section withObject:schedule];
    [self.collectionView deleteItemsAtIndexPaths:@[touchedItem]];
}

@end