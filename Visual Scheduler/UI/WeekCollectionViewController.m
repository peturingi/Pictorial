#import "CalendarView.h"
#import "WeekCollectionViewController.h"
#import "WeekCollectionViewLayout.h"
#import "WeekDataSource.h"

@interface WeekCollectionViewController ()
@property (nonatomic, strong) id<EditableDataSource, UICollectionViewDataSource> dataSource;
@end

@implementation WeekCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.dataSource = [[WeekDataSource alloc] init];
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

- (void)dealloc {
    _dataSource = nil;
}

@end