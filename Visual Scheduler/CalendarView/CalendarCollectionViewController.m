#import "CalendarCollectionViewController.h"
#import "WeekDataSource.h"
#import "CalendarView.h"
#import "WeekCollectionViewLayout.h"
#import "DayDataSource.h"
#import "DayCollectionViewLayout.h"
#import "NowCollectionViewLayout.h"
#import "DataSourceCanAddPictogram.h"

#import "Schedule.h"
#import "Pictogram.h"

@interface CalendarCollectionViewController ()
    @property (nonatomic, strong) id<DataSourceCanAddPictogram, UICollectionViewDelegate, UICollectionViewDataSource> dataSource;
@end

@implementation CalendarCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
#warning shows schedule for 0
        self.dataSource = [[WeekDataSource alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self setupCollectionView];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    if (editing) {
        [self.dataSource setEditing:YES];
        // Inform collectionview that mock-fields are available from datasource.
        NSMutableArray *mockItemsAtEndOfSchedule = [NSMutableArray array];
        for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
            [mockItemsAtEndOfSchedule addObject:[NSIndexPath indexPathForItem:numberOfItemsInSection inSection:section]];
        }
        [self.collectionView insertItemsAtIndexPaths:mockItemsAtEndOfSchedule];
        
    } else {
        [self.dataSource setEditing:NO];
        NSMutableArray *mockItemsToRemoveFromSchedule = [NSMutableArray array];
        for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
            numberOfItemsInSection--;
            [mockItemsToRemoveFromSchedule addObject:[NSIndexPath indexPathForItem:numberOfItemsInSection inSection:section]];
        }
        [self.collectionView deleteItemsAtIndexPaths:mockItemsToRemoveFromSchedule];
    }
}

- (void)setupCollectionView {
    self.collectionView = [[CalendarView alloc] initWithFrame:self.view.frame collectionViewLayout:self.collectionViewLayout];
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self.dataSource;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)switchToViewMode:(NSInteger)viewMode {
    UICollectionViewLayout *layout;
    CalendarView *view;
    CGRect oldFrame = self.view.bounds;
        switch (viewMode) {
            case 0:
                layout = [[NowCollectionViewLayout alloc] init];
                view = [[CalendarView alloc] initWithFrame:oldFrame collectionViewLayout:layout];
                self.dataSource = [[DayDataSource alloc] initWithScheduleNumber:0];
                break;
                
            case 1:
                layout = [[DayCollectionViewLayout alloc] init];
                view = [[CalendarView alloc] initWithFrame:oldFrame collectionViewLayout:layout];
                self.dataSource = [[DayDataSource alloc] initWithScheduleNumber:0]; // TODO set correct date
                break;
                
            case 2:
                layout = [[WeekCollectionViewLayout alloc] init];
                view = [[CalendarView alloc] initWithFrame:oldFrame collectionViewLayout:layout];
                self.dataSource = [[WeekDataSource alloc] init];
                break;
            
            default:
                    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                                   reason:@"Unknown view mode selected." userInfo:nil];
                break;
        }
    view.dataSource = self.dataSource;
    view.backgroundColor = [UIColor whiteColor];
    self.collectionView = view;
}

- (void)sectionAtPoint:(CGPoint)point {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    NSLog(@"Section: %ld, Item: %ld", (long)indexPath.section, (long)indexPath.item);
}

- (void)addPictogram:(Pictogram *)pictogram atIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath != nil);
    NSParameterAssert(indexPath.section < self.collectionView.numberOfSections);
    NSParameterAssert(indexPath.item < [self.collectionView numberOfItemsInSection:indexPath.section]);
    [self.dataSource addPictogram:pictogram toCollectionView:self.collectionView atIndexPath:indexPath];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)touchedItem {
    NSAssert(self.editing == YES, @"Cannot delete item as the collection view is not in edit mode.");
    NSMutableArray *data = self.dataSource;
    Schedule *schedule = [data objectAtIndex:touchedItem.section];
    [schedule removePictogramAtIndex:touchedItem.item];

    [self.collectionView deleteItemsAtIndexPaths:@[touchedItem]];
}

@end