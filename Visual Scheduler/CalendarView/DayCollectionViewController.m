#import "CalendarView.h"
#import "DataSourceCanAddRemovePictogram.h"
#import "DayCollectionViewController.h"
#import "DayCollectionViewLayout.h"
#import "DayDataSource.h"
#import "NowCollectionViewLayout.h"
#import "NSDate+VisualScheduler.h"

@interface DayCollectionViewController ()
@property (nonatomic, strong) id<EditableDataSource, UICollectionViewDelegate, UICollectionViewDataSource> dataSource;
@end

@implementation DayCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        const NSUInteger indexOfScheduleToShow = [NSDate dayOfWeekInDenmark] - 1;
        self.dataSource = [[DayDataSource alloc] initWithScheduleNumber:indexOfScheduleToShow];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    self.collectionView = [[CalendarView alloc] initWithFrame:self.view.frame collectionViewLayout:self.collectionViewLayout];
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self.dataSource;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.dataSource setEditing:editing];
    [self showEmptyPictogramsAtEndOfSchedule:editing];
}

- (void)showEmptyPictogramsAtEndOfSchedule:(BOOL)value {
    NSMutableArray *emptyPictograms = [NSMutableArray array];
    const NSUInteger numberOfSections = self.collectionView.numberOfSections;
    const NSUInteger firstSection = 0;
    if (value) {
        for (NSUInteger section = firstSection; section < numberOfSections; section++) {
            const NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
            NSIndexPath const *destination = [NSIndexPath indexPathForItem:numberOfItemsInSection inSection:section];
            [emptyPictograms addObject:destination];
        }
        [self.collectionView insertItemsAtIndexPaths:emptyPictograms];
    }
    else if (!value) {
        for (NSUInteger section = firstSection; section < numberOfSections; section++) {
            const NSUInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
            NSIndexPath const *locationOfEmptyPictogram = [NSIndexPath indexPathForItem:numberOfItemsInSection-1 inSection:section];
            [emptyPictograms addObject:locationOfEmptyPictogram];
        }
        [self.collectionView deleteItemsAtIndexPaths:emptyPictograms];
    }
}

- (void)switchToViewMode:(NSInteger)viewMode {
    UICollectionViewLayout *layout;
        switch (viewMode) {
            case 0:
                layout = [[NowCollectionViewLayout alloc] init];
                break;
                
            case 1:
                layout = [[DayCollectionViewLayout alloc] init];
                break;
                
            default:
                    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                                   reason:@"Unknown view mode selected." userInfo:nil];
                break;
        }
    [self.collectionView setCollectionViewLayout:layout];
}

- (void)sectionAtPoint:(CGPoint)point {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
}

- (void)addPictogram:(Pictogram *)pictogram atIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath != nil);
    NSParameterAssert(indexPath.section < self.collectionView.numberOfSections);
    NSParameterAssert(indexPath.item < [self.collectionView numberOfItemsInSection:indexPath.section]);
    NSAssert(self.editing, @"Cannot add items unless in edit mode.");
    [self.dataSource addPictogram:pictogram toCollectionView:self.collectionView atIndexPath:indexPath];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)touchedItem {
    NSParameterAssert(touchedItem);
    NSAssert(self.editing == YES, @"Cannot delete item as the collection view is not in edit mode.");
    [self.dataSource deletePictogramInCollectionView:self.collectionView atIndexPath:touchedItem];
}

@end