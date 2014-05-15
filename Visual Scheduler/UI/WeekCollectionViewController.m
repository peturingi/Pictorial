#import "CalendarView.h"
#import "Schedule.h"
#import "UICollectionView+AbortScrollAnimation.h"
#import "WeekCollectionViewController.h"
#import "WeekCollectionViewLayout.h"
#import "WeekDataSource.h"

@interface WeekCollectionViewController ()
@property (nonatomic, strong) WeekDataSource *dataSource;
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

- (void)viewDidLoad {
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView" : self.collectionView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView" : self.collectionView}]];
    [self.view setNeedsUpdateConstraints];

}

- (void)setupCollectionView {
    // This view will be managed with auto layout.
    self.collectionView = [[CalendarView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.dataSource setEditing:editing];
    [self showEmptyPictogramsAtEndOfSchedule:editing];
   // [self.collectionView abortScrollAnimation];
}

- (void)showEmptyPictogramsAtEndOfSchedule:(BOOL)value {
    NSMutableArray *emptyPictograms = [NSMutableArray array];
    const NSUInteger firstSection = 0;
    const NSUInteger numberOfSections = self.collectionView.numberOfSections;
    if (value) {
        for (NSUInteger section = firstSection; section < numberOfSections; section++) {
            const NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
            NSIndexPath const *destination = [NSIndexPath indexPathForItem:numberOfItemsInSection inSection:section];
            [emptyPictograms addObject:destination];
        }
        [UIView performWithoutAnimation:^(void){
            [self.collectionView insertItemsAtIndexPaths:emptyPictograms];
        }];
    }
    else if (!value) {
        for (NSUInteger section = firstSection; section < numberOfSections; section++) {
            const NSUInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
            NSIndexPath const *locationOfEmptyPictogram = [NSIndexPath indexPathForItem:numberOfItemsInSection-1 inSection:section];
            [emptyPictograms addObject:locationOfEmptyPictogram];
        }
        [UIView performWithoutAnimation:^(void){
            [self.collectionView deleteItemsAtIndexPaths:emptyPictograms];
        }];
    }
}

- (void)addPictogram:(Pictogram *)pictogram atIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(pictogram);
    NSParameterAssert(indexPath);
    NSParameterAssert(indexPath.section < self.collectionView.numberOfSections);
    NSParameterAssert(indexPath.item < [self.collectionView numberOfItemsInSection:indexPath.section]);
    NSAssert(self.editing, @"Cannot add items unless in edit mode.");
    
    Schedule *schedule = [self.dataSource.schedules objectAtIndex:indexPath.section];
    [schedule addPictogram:pictogram atIndex:indexPath.item];
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void)deletePictogramAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    NSAssert(self.isEditing, @"Trying to modify the datasource while not in edit mode.");
    
    const NSUInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:indexPath.section];
    const NSUInteger itemToDelete = indexPath.item;
    const NSUInteger sectionToDeleteFrom = indexPath.section;
    if (itemToDelete < numberOfItemsInSection-1) {
        Schedule *schedule = [self.dataSource.schedules objectAtIndex:sectionToDeleteFrom];
        [schedule removePictogramAtIndex:itemToDelete];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)dealloc {
    _dataSource = nil;
}

@end