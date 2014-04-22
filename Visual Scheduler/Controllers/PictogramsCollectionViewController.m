#import "PictogramsCollectionViewController.h"
#import "CreatePictogram.h"
#import "UIView+BBASubviews.h"
#import "../Database/Repository.h"

#define INSETS  30

NSString * const kCellReusableIdentifier = @"pictogramSelector";
NSInteger const kCellTagForImageView = 1;
NSInteger const kCellTagForLabelView = 2;

@interface PictogramsCollectionViewController ()
@property (strong, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) Repository *repository;
@end

@implementation PictogramsCollectionViewController

- (void)dealloc {
    self.dataSource = nil;
    self.repository = nil;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"SelectPictogramCell" bundle:nil] forCellWithReuseIdentifier:@"pictogramSelector"];
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.collectionViewLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(INSETS, INSETS, INSETS, INSETS);
    
    // Makes the collectionView flexible in size, so its size can be managed by a container.
    //self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

- (void)setupDataSource {
    _repository = [Repository defaultRepository];
    NSAssert(_repository != nil, @"Failed to get shared repository.");
    _dataSource = [_repository allPictograms];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(100, 135);
    return size;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSAssert(_dataSource != nil, @"Must not be nil.");
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   UICollectionViewCell *reusableCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReusableIdentifier forIndexPath:indexPath];
   [self configureCell:reusableCell atIndexPath:indexPath];
   return reusableCell;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imageView = (UIImageView *)[cell.contentView firstSubviewWithTag:kCellTagForImageView];
    UIImage *image = [self imageForPictogramAtIndexPath:indexPath];
    [imageView setImage:image];
    
    UILabel *labelView = (UILabel *)[cell.contentView firstSubviewWithTag:kCellTagForLabelView];
    NSString *title = [self titleForPictogramIndexPath:indexPath];
    [labelView setText:title];
    
    imageView.layer.borderWidth = PICTOGRAM_BORDER_WIDTH;
    imageView.layer.cornerRadius = PICTOGRAM_CORNER_RADIUS;
}

- (UIImage *)imageForPictogramAtIndexPath:(NSIndexPath *)indexPath {
    Pictogram *pictogram = [self.dataSource objectAtIndex:indexPath.row];
    NSAssert(pictogram.image != nil, @"Failed to load image from pictogram.");
    return pictogram.image;
}

- (NSString *)titleForPictogramIndexPath:(NSIndexPath *)indexPath {
    Pictogram *pictogram = [self.dataSource objectAtIndex:indexPath.row];
    return pictogram.title;
}

#pragma mark Public - used by container

- (Pictogram *)pictogramAtPoint:(CGPoint)point {
    point.x += self.collectionView.contentOffset.x;
    point.y += self.collectionView.contentOffset.y;
    
    NSIndexPath *selection = [self.collectionView indexPathForItemAtPoint:point];
    return [self.dataSource objectAtIndex:selection.item];
}

- (CGRect)frameOfPictogramAtPoint:(CGPoint)point {
    CGPoint contentPoint = point;
    contentPoint.x += self.collectionView.contentOffset.x;
    contentPoint.y += self.collectionView.contentOffset.y;
    
    NSIndexPath *selection = [self.collectionView indexPathForItemAtPoint:contentPoint];
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:selection];
    UIImageView *image = (UIImageView *)[cell.contentView firstSubviewWithTag:kCellTagForImageView];
    
    CGPoint origin = cell.frame.origin;
    origin = [self.view convertPoint:origin fromView:self.collectionView];
    CGSize size = image.frame.size;
    CGRect frame = { origin, size };
    
    return frame;
}

@end