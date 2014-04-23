#import "PictogramsCollectionViewController.h"
#import "CreatePictogram.h"
#import "../Database/Repository.h"
#import "UIView+BBASubviews.h"
#import "PictogramsCollectionViewDelegateFlowLayout.h"

#define INSETS 30
#define BACKGROUND_COLOR [UIColor whiteColor]
#define CELL_REUSE_IDENTIFIER @"pictogramSelector"

@interface PictogramsCollectionViewController ()
@property (strong, nonatomic) PictogramsCollectionDataSource *dataSource;
@property (strong, nonatomic) PictogramsCollectionViewDelegateFlowLayout *layoutDelegate;
@end

@implementation PictogramsCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    NSParameterAssert(layout);
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self registerCollectionViewCell];
    }
    return self;
}

- (void)registerCollectionViewCell {
    NSString * const nibName = @"SelectPictogramCell";
    if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil) {
        [self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:CELL_REUSE_IDENTIFIER];
    }
    else {
        @throw [NSException exceptionWithName:@"Could not regsiter nib." reason:@"File not found." userInfo:nil];
    }
}

- (void)loadView {
    [super loadView];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.collectionViewLayout];
    _dataSource = [[PictogramsCollectionDataSource alloc] init];
    self.collectionView.dataSource = self.dataSource;
    _layoutDelegate = [[PictogramsCollectionViewDelegateFlowLayout alloc] init];
    self.collectionView.delegate = self.layoutDelegate;
    self.collectionView.backgroundColor = BACKGROUND_COLOR;
    self.collectionView.contentInset = UIEdgeInsetsMake(INSETS, INSETS, INSETS, INSETS);
}

#pragma mark - Public

- (Pictogram *)pictogramAtPoint:(CGPoint)point {
    CGPoint itemPoint = [self addPoint:point toPoint:self.collectionView.contentOffset];
    NSIndexPath *selection = [self.collectionView indexPathForItemAtPoint:itemPoint];
    Pictogram *pictogram = [self.dataSource pictogramAtIndexPath:selection];
    return pictogram;
}

- (CGRect)frameOfPictogramAtPoint:(CGPoint)point {
    CGPoint contentPoint = [self addPoint:point toPoint:self.collectionView.contentOffset];
    NSIndexPath *selection = [self.collectionView indexPathForItemAtPoint:contentPoint];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:selection];
    UIImageView *image = (UIImageView *)[cell.contentView firstSubviewWithTag:CELL_TAG_FOR_IMAGE_VIEW];
    CGPoint origin = [self.view convertPoint:cell.frame.origin fromView:self.collectionView];
    CGRect frame = { origin, image.frame.size };
    return frame;
}

- (CGPoint)addPoint:(CGPoint)first toPoint:(CGPoint)second {
    CGPoint result;
    result.x = first.x + second.x;
    result.y = first.y + second.y;
    return result;
}

#pragma mark - dealloc

- (void)dealloc {
    [self nilIvars];
    [self deRegisterCollectionViewCell];
}

- (void)nilIvars {
    self.dataSource = nil;
    self.layoutDelegate = nil;
}

- (void)deRegisterCollectionViewCell {
    [self.collectionView registerNib:nil forCellWithReuseIdentifier:CELL_REUSE_IDENTIFIER];
}

#pragma mark -

@end